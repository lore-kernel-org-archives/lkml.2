Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2IDD6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 23:58:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49814 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab2IDD6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 23:58:40 -0400
Date: Tue, 4 Sep 2012 13:58:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: linux-next: build warnings after merge of the drm tree
Message-Id: <20120904135829.6beb08f80919aa2b5c8bf55f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Sep_2012_13_58_29_+1000_Ns+_TNFZ68oHViFq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Sep_2012_13_58_29_+1000_Ns+_TNFZ68oHViFq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

drivers/gpu/drm/udl/Kconfig:1:error: recursive dependency detected!
drivers/gpu/drm/udl/Kconfig:1:	symbol DRM_UDL depends on USB_ARCH_HAS_HCD
drivers/usb/Kconfig:76:	symbol USB_ARCH_HAS_HCD depends on USB_SUPPORT
drivers/usb/Kconfig:58:	symbol USB_SUPPORT is selected by DRM_USB
drivers/gpu/drm/Kconfig:22:	symbol DRM_USB is selected by DRM_UDL
warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct de=
pendencies (USB_SUPPORT && USB_OHCI_HCD)
warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has=
 unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD)
warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILI=
NX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet dir=
ect dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || =
440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OC=
TEON || PMC_MSP || SPARC_LEON || MIPS_SEAD3))

The x86_64 allmodconfig produces these:

drivers/gpu/drm/udl/Kconfig:1:error: recursive dependency detected!
drivers/gpu/drm/udl/Kconfig:1:	symbol DRM_UDL depends on USB_ARCH_HAS_HCD
drivers/usb/Kconfig:76:	symbol USB_ARCH_HAS_HCD depends on USB_SUPPORT
drivers/usb/Kconfig:58:	symbol USB_SUPPORT is selected by DRM_USB
drivers/gpu/drm/Kconfig:22:	symbol DRM_USB is selected by DRM_UDL
warning: (MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYST=
ICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG &&=
 TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT=
_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK &&=
 INPUT_CM109 && RC_ATI_REMOTE && IR_IMON && IR_MCEUSB && IR_REDRAT3 && IR_S=
TREAMZAP && IR_IGUANA && IR_TTUSBIR && DRM_USB) selects USB which has unmet=
 direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD)

Maybe introduced by commit df0b34430072 ("drm/usb: select USB_SUPPORT in
Kconfig"), maybe interacting with a commit 8f057d7bca54 ("gpu/mfd/usb:
Fix USB randconfig problems") from Linus' tree (that added "depends on
USB_ARCH_HAS_HCD" to "config DRM_USB" and "config DRM_UDL").

I have left this mess for now, but it needs addressing.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Sep_2012_13_58_29_+1000_Ns+_TNFZ68oHViFq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRXxlAAoJEECxmPOUX5FEG8sP/ifSYmjMeRBlnJEl+EqiCikG
LJ5L4kIm+LfHinakkGIlGJJQ6vAqI9UMQjpQ+YGm/ZTMruQzOTDUOQKtUG4++n5o
3kXscQVAomQJOvQUSWwPU9uiXDlfuRBbM33TtkHuyDOXzQFS08p02MNSclo3ETPe
DXKLHTYr0jExz3v4j42p93Vu2I9CLEhGY9z3WuTq7SbRgSKZPUGjLNr5wj5i4nvB
yVdFFTSIotNW57UhjP8ACoU6CnR69RaFeQfwfAgmtwx1bFMJeo7HDdVv33XBcQBg
J06J/VCc8W6gVdlcQ3KdHkozhsSOxJ8Qdl+c6KI9xFpI+p51FqDHqTTSnBufMMAR
SQ6XZ4jjeemIzQGKkmcrD+sbraltQn2onWJPeaqMzWRn7Sv8pUXNQKz3jpv2qGC4
KJFyZMFJTeg/nqh3Z6Jt0rA5wyFoeFRPD+Pc/0PYCbYPjfJq8EQuSw5a1RAF6C1r
x3diH5mhVvuIYK/LTCvAhlEhmCBX1gA2iIhl/jihaN+OAzVFMkfXttdffFBzlcwa
OO8FFv4kIX7fq3Jwy8BrrdPHEecA1VFxteI4AVb9eS1jAzyuB8SsSsApuFx5TiF4
VNXPXhvf9yUQdr92L+bGSvvQWbXAs+XtfNeXQoIrQXMzAuAJQcdVI5eXTIz3i1SV
yiHOVkw8PDIdjb7fIAGA
=bHKG
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Sep_2012_13_58_29_+1000_Ns+_TNFZ68oHViFq--
