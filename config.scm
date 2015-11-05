;; This is an operating system configuration template
;; for a "desktop" setup with X11.

(use-modules (gnu) (gnu system nss))
(use-service-modules ssh networking desktop)
(use-package-modules haskell xfce ssh ratpoison certs wm lsh)

(operating-system
  (host-name "antelope")
  (timezone "Europe/Paris")
  (locale "en_US.UTF-8")

  ;; Assuming /dev/sdX is the target hard disk, and "root" is
  ;; the label of the target root file system.
  (bootloader (grub-configuration (device "/dev/sda")))

  ;; Here we assume that /dev/sdX1 contains a LUKS-encrypted
  ;; root partition created with 'cryptsetup luksFormat'.
;  (mapped-devices (list (mapped-device
;                          (source "/dev/sdX1")
;                          (target "root-partition")
;                          (type luks-device-mapping))))

  ;; Mount said encrypted partition.
  (file-systems (cons (file-system
                        (device "/dev/sda1")
                        (mount-point "/")
                        (type "ext3"))
                      %base-file-systems))

  (users (cons (user-account
                (name "paul")
                (comment "Alice's brother")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"))
                (home-directory "/home/paul"))
               %base-user-accounts))

  (packages (cons* xfce 	     ;desktop environments
                   nss-certs         ;for HTTPS access
		   xmobar
		   openssh
		   ghc
		   xmonad
		   ghc-network
		   ghc-xmonad-contrib
		   %base-packages))

  ;; Use the "desktop" services, which include the X11
  ;; log-in service, networking with Wicd, and more.
  (services (cons* (lsh-service)
		%desktop-services))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
