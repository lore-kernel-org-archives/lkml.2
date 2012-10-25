Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab2JYHMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:12:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49693 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab2JYHMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:12:40 -0400
Date: Thu, 25 Oct 2012 10:06:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: Constantine Shulyupin <const@MakeLinux.com>
CC: <nsekhar@ti.com>, <gregkh@linuxfoundation.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6] Enable USB peripheral mode on dm365 EVM
Message-ID: <20121025070653.GB5259@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349872412-22040-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <1349872412-22040-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 10, 2012 at 02:33:32PM +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
>=20
> Sets USB PHY clock source to 24 MHz clock and call USB configuration from=
 board initialization.
>=20
> Tested with OTG configuration, usb gadget g_zero on DM365 EVM connected t=
o PC.
>=20
> References:
>=20
> Definition of USB_PHY_CTRL and PHYCLKFREQ:
> - http://www.makelinux.com/lib/ti/DM36x_ARM/doc-141
>=20
> Original patch by miguel.aguilar@ridgerun.com three years ago:
> - http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.=
com/msg14741.html
>=20
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> ---
>=20
> Note:
>=20
> Changelog
>=20
> Changes since v5 http://www.spinics.net/lists/kernel/msg1413120.html
> accordingy feedback of nsekhar@ti.com http://www.spinics.net/lists/kernel=
/msg1414914.html
> - phy configuration moved to drivers/usb/musb/davinci.c
> - USB_OTG configuration is submitted in separated patch: http://www.spini=
cs.net/lists/kernel/msg1414964.html
> - Setting current limit to 1000 mA. Any way the current is limited to 510=
 mA in davinci_setup_usb.
>=20
> Changes since v4 http://www.spinics.net/lists/kernel/msg1412995.html
> - removed fix of dev_info in musb_init_controller
>=20
> Changes since v3 http://www.spinics.net/lists/kernel/msg1412544.html:
> - removed optional altering of pr_info
>=20
> Changes since v1  http://marc.info/?l=3Dlinux-kernel&m=3D130894150803661&=
w=3D2:
> - removed optional code and reordered
> - removed alternation of GPIO33, which is multiplexed with DRVVBUS, becau=
se is not need for peripheral USB
>=20
> This patch is based on code from projects Arago, Angstom and RidgeRun.
>=20
> ---
>  arch/arm/mach-davinci/board-dm365-evm.c |    2 ++
>  drivers/usb/musb/davinci.c              |    3 +++
>  drivers/usb/musb/davinci.h              |    1 +
>  3 files changed, 6 insertions(+)
>=20
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davi=
nci/board-dm365-evm.c
> index 688a9c5..ba5ffc1 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -38,6 +38,7 @@
>  #include <mach/mmc.h>
>  #include <mach/nand.h>
>  #include <mach/keyscan.h>
> +#include <mach/usb.h>
> =20
>  #include <media/tvp514x.h>
> =20
> @@ -610,6 +611,7 @@ static __init void dm365_evm_init(void)
> =20
>  	dm365_init_spi0(BIT(0), dm365_evm_spi_info,
>  			ARRAY_SIZE(dm365_evm_spi_info));
> +	davinci_setup_usb(1000, 8);
>  }
> =20
>  MACHINE_START(DAVINCI_DM365_EVM, "DaVinci DM365 EVM")
> diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
> index 472c8b4..af09ebf 100644
> --- a/drivers/usb/musb/davinci.c
> +++ b/drivers/usb/musb/davinci.c
> @@ -428,6 +428,9 @@ static int davinci_musb_init(struct musb *musb)
>  		__raw_writel(deepsleep, DM355_DEEPSLEEP);
>  	}
> =20
> +	if (machine_is_davinci_dm365_evm())
> +		writel(readl(USB_PHY_CTRL) | USBPHY_CLKFREQ_24MHZ, USB_PHY_CTRL);

no such checks in drivers. Please find another way to do this.

--=20
balbi

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiOUNAAoJEIaOsuA1yqREhikP/Rh4NPoCV/XIHLJ2nQxfGq6h
Oy3MvfKpDNVunVRDZyjmtPEmgwRKYpN1YqtB6wn0Sz0ka7NM5SgniA+J35fKBYMi
f40Apo7RC0l7rF7b2lhyS1wKmMCqvlj46IhCn5SOJKJpxBbdbagCSkf3jOWp4BOo
sv0t4UsAmRv+C73NjoSL/hjx6sr+kJrifkFgZ/BdhQSFZmO/E6baFwfnZ9NaDKbI
rh6GVyr3i5uJ9trDrEBIqL/KfFGvDAIwtpETsUxp3jdJmkiw0mp5dWTHEq9jIpQT
XWs2k7cPZS4M9F+os485qi9CRQzpUBiEMM+mUNqXw7uL1LQqCAysjgogx1yja4mf
9zg8DbXga/2NTvTBYhapaHVGNfymSNFbeOLso+EV1ffowiD9PGxmupYYSTFyxSvE
wG74Z37HJzSwZx4ublwpeN7/wFviEGj4w/g975XFRJ4/jyoELk16ybQC9tUsJ47Z
zbZuiLHD6INDsN6n70MXwVTgJr6vo2rcAHKLQ6jEaJJNikPf0OTYky3w92xMHugN
oQdjR/dOMTKQP4IbB8Qu4lrYNXW6bstmdAw3DmX8g7FrkyH7Rr4ArpPezk94NbXL
mx4tO/IRoQg6oQw31gbXpxzy3RdzPF/+1+OtBenCjqaFTST71gQpTQmAUALsODAy
yQUWHfbTGYWJ8iq4PZwS
=+RyF
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
