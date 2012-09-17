Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2IQPSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:18:48 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:34678 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091Ab2IQPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:18:46 -0400
Date: Mon, 17 Sep 2012 18:14:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Neil Zhang <zhangwm@marvell.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] USB: remove CONFIG_EXPERIMENTAL dependancies
Message-ID: <20120917151401.GK7699@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120915041550.GA28736@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1EIGrW/+75u5Nmw"
Content-Disposition: inline
In-Reply-To: <20120915041550.GA28736@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L1EIGrW/+75u5Nmw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 14, 2012 at 09:15:50PM -0700, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> As discussed at the kernel summit this year, CONFIG_EXPERIMENTAL means
> nothing, so let's get rid of it.
>=20
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: David Herrmann <dh.herrmann@googlemail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Neil Zhang <zhangwm@marvell.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For drivers/usb/gadget:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/core/Kconfig     |    2 +-
>  drivers/usb/gadget/Kconfig   |   17 ++++++-----------
>  drivers/usb/host/Kconfig     |   22 ++++++++++------------
>  drivers/usb/wusbcore/Kconfig |    3 +--
>  4 files changed, 18 insertions(+), 26 deletions(-)
>=20
> Any objections to me applying this patch to the usb-next branch?
>=20
> diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
> index 9981984..f70c1a1 100644
> --- a/drivers/usb/core/Kconfig
> +++ b/drivers/usb/core/Kconfig
> @@ -56,7 +56,7 @@ config USB_SUSPEND
> =20
>  config USB_OTG
>  	bool "OTG support"
> -	depends on USB && EXPERIMENTAL
> +	depends on USB
>  	depends on USB_SUSPEND
>  	default n
>  	help
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index a53be32..dfb51a4 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -557,7 +557,7 @@ config USB_ZERO_HNPTEST
>  	  one serve as the USB host instead (in the "B-Host" role).
> =20
>  config USB_AUDIO
> -	tristate "Audio Gadget (EXPERIMENTAL)"
> +	tristate "Audio Gadget"
>  	depends on SND
>  	select USB_LIBCOMPOSITE
>  	select SND_PCM
> @@ -672,8 +672,7 @@ config USB_G_NCM
>  	  dynamically linked module called "g_ncm".
> =20
>  config USB_GADGETFS
> -	tristate "Gadget Filesystem (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Gadget Filesystem"
>  	help
>  	  This driver provides a filesystem based API that lets user mode
>  	  programs implement a single-configuration USB device, including
> @@ -681,15 +680,11 @@ config USB_GADGETFS
>  	  All endpoints, transfer speeds, and transfer types supported by
>  	  the hardware are available, through read() and write() calls.
> =20
> -	  Currently, this option is still labelled as EXPERIMENTAL because
> -	  of existing race conditions in the underlying in-kernel AIO core.
> -
>  	  Say "y" to link the driver statically, or "m" to build a
>  	  dynamically linked module called "gadgetfs".
> =20
>  config USB_FUNCTIONFS
> -	tristate "Function Filesystem (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Function Filesystem"
>  	select USB_LIBCOMPOSITE
>  	select USB_FUNCTIONFS_GENERIC if !(USB_FUNCTIONFS_ETH || USB_FUNCTIONFS=
_RNDIS)
>  	help
> @@ -799,8 +794,8 @@ config USB_G_SERIAL
>  	  make MS-Windows work with CDC ACM.
> =20
>  config USB_MIDI_GADGET
> -	tristate "MIDI Gadget (EXPERIMENTAL)"
> -	depends on SND && EXPERIMENTAL
> +	tristate "MIDI Gadget"
> +	depends on SND
>  	select USB_LIBCOMPOSITE
>  	select SND_RAWMIDI
>  	help
> @@ -867,7 +862,7 @@ config USB_G_ACM_MS
>  	  dynamically linked module called "g_acm_ms".
> =20
>  config USB_G_MULTI
> -	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
> +	tristate "Multifunction Composite Gadget"
>  	depends on BLOCK && NET
>  	select USB_G_MULTI_CDC if !USB_G_MULTI_RNDIS
>  	select USB_LIBCOMPOSITE
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 13cd6d5..b1deb0f 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -18,8 +18,8 @@ config USB_C67X00_HCD
>  	  module will be called c67x00.
> =20
>  config USB_XHCI_HCD
> -	tristate "xHCI HCD (USB 3.0) support (EXPERIMENTAL)"
> -	depends on USB && USB_ARCH_HAS_XHCI && EXPERIMENTAL
> +	tristate "xHCI HCD (USB 3.0) support"
> +	depends on USB && USB_ARCH_HAS_XHCI
>  	---help---
>  	  The eXtensible Host Controller Interface (xHCI) is standard for USB 3=
=2E0
>  	  "SuperSpeed" host controller hardware.
> @@ -262,7 +262,7 @@ config USB_ISP116X_HCD
> =20
>  config USB_ISP1760_HCD
>  	tristate "ISP 1760 HCD support"
> -	depends on USB && EXPERIMENTAL
> +	depends on USB
>  	---help---
>  	  The ISP1760 chip is a USB 2.0 host controller.
> =20
> @@ -376,7 +376,7 @@ config USB_OHCI_HCD_PCI
> =20
>  config USB_OHCI_HCD_SSB
>  	bool "OHCI support for Broadcom SSB OHCI core (DEPRECATED)"
> -	depends on USB_OHCI_HCD && (SSB =3D y || SSB =3D USB_OHCI_HCD) && EXPER=
IMENTAL
> +	depends on USB_OHCI_HCD && (SSB =3D y || SSB =3D USB_OHCI_HCD)
>  	select USB_HCD_SSB
>  	select USB_OHCI_HCD_PLATFORM
>  	default n
> @@ -414,7 +414,7 @@ config USB_CNS3XXX_OHCI
> =20
>  config USB_OHCI_HCD_PLATFORM
>  	bool "Generic OHCI driver for a platform device"
> -	depends on USB_OHCI_HCD && EXPERIMENTAL
> +	depends on USB_OHCI_HCD
>  	default n
>  	---help---
>  	  Adds an OHCI host driver for a generic platform device, which
> @@ -424,7 +424,7 @@ config USB_OHCI_HCD_PLATFORM
> =20
>  config USB_EHCI_HCD_PLATFORM
>  	bool "Generic EHCI driver for a platform device"
> -	depends on USB_EHCI_HCD && EXPERIMENTAL
> +	depends on USB_EHCI_HCD
>  	default n
>  	---help---
>  	  Adds an EHCI host driver for a generic platform device, which
> @@ -591,8 +591,7 @@ config USB_RENESAS_USBHS_HCD
>  	  module will be called renesas-usbhs.
> =20
>  config USB_WHCI_HCD
> -	tristate "Wireless USB Host Controller Interface (WHCI) driver (EXPERIM=
ENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Wireless USB Host Controller Interface (WHCI) driver"
>  	depends on PCI && USB && UWB
>  	select USB_WUSB
>  	select UWB_WHCI
> @@ -604,8 +603,7 @@ config USB_WHCI_HCD
>  	  will be called "whci-hcd".
> =20
>  config USB_HWA_HCD
> -	tristate "Host Wire Adapter (HWA) driver (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Host Wire Adapter (HWA) driver"
>  	depends on USB && UWB
>  	select USB_WUSB
>  	select UWB_HWA
> @@ -656,7 +654,7 @@ config USB_OCTEON2_COMMON
> =20
>  config USB_HCD_BCMA
>  	tristate "BCMA usb host driver"
> -	depends on BCMA && EXPERIMENTAL
> +	depends on BCMA
>  	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
>  	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
>  	help
> @@ -668,7 +666,7 @@ config USB_HCD_BCMA
> =20
>  config USB_HCD_SSB
>  	tristate "SSB usb host driver"
> -	depends on SSB && EXPERIMENTAL
> +	depends on SSB
>  	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
>  	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
>  	help
> diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
> index f29fdd7..8bf1976 100644
> --- a/drivers/usb/wusbcore/Kconfig
> +++ b/drivers/usb/wusbcore/Kconfig
> @@ -2,8 +2,7 @@
>  # Wireless USB Core configuration
>  #
>  config USB_WUSB
> -	tristate "Enable Wireless USB extensions (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Enable Wireless USB extensions"
>  	depends on USB
>  	depends on PCI
>  	depends on UWB

--=20
balbi

--L1EIGrW/+75u5Nmw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQVz45AAoJEIaOsuA1yqRE4ewP/RRS84ZJV7jJ+nuCZ9WSBdal
vwyFTytczDp4eW/Cl+UihzqpBcTFyO4yMixZS2qpwLneGoySRdbcE8UIM8+XYDNL
QKqSLKtGLXkDT+kxa+LA2sTI29KiYIn+9sXrUhbzFWfADWSRd549EXEI/w5sxFFl
3JHO/76NiC+NjEwkFLd9tfvXomiASPjTnPnSKa7nsq0tTQAYS2NJHxMPM+/brnJM
0zrdEmDQA0xrlqp7U+Sx/PBL5ympBXK773pb7xuD3UsAr07COiGhP7i7bQTcYEmi
CjhzPg01B3NYzRAvO5YlR5LniV/9wgKcyCqfeO5SzADv53ED45j7dytTQImFDRcd
7nEXc1FZCXwKz5kXUdECwR6ZBWhC1I6TROwWl5BOZSypk8QvK5oiueIQaJbADsxA
iA5qAM2xgPqTTKjdkqON9IZX0czrsSX3jzSR8c1vWBNBdq10zTqDS8M8tXX6aalB
8Go6qEQiKxg4M0e01K0JE3MOhl7I6x0D2L+BOiNq0CCa6N4xiebZF/7XCvZWFk+O
GeuIiBeB7DMJaFbH684jzYCfZn9gVwhi3GrFUQzjFzx4atNabqAJganTU9PG59kF
MCUQi271wtQSR68DoGhGiPLDUhKW+J3RX0GDla7BszEbQm9rhRQFIvnSidiE30TP
PPAkQwK5fg7bt2Q859vE
=RUf/
-----END PGP SIGNATURE-----

--L1EIGrW/+75u5Nmw--
