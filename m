Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2JONfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:35:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33636 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2JONfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:35:46 -0400
Date: Mon, 15 Oct 2012 16:30:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Constantine Shulyupin <const@MakeLinux.com>
CC: <nsekhar@ti.com>, <gregkh@linuxfoundation.org>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7] Enable USB peripheral mode on dm365 EVM
Message-ID: <20121015133014.GU24333@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349973274-24936-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ggEtdcIX3XIOBw6T"
Content-Disposition: inline
In-Reply-To: <1349973274-24936-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ggEtdcIX3XIOBw6T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 11, 2012 at 06:34:34PM +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
>=20
> Sets USB PHY clock source to 24 MHz clock.
>=20
> Tested with OTG configuration, usb gadget g_zero on DM365 EVM connected t=
o PC.
>=20
> To active the patch need to call davinci_setup_usb from dm365_evm_init
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
> Changes since v6
> - moved call to davinci_setup_usb from dm365_evm_init to another patch ac=
cordinly request of Sergei
> =20
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
>  drivers/usb/musb/davinci.c              |    3 +++
>  drivers/usb/musb/davinci.h              |    1 +
>=20
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

NAK!!! No machine_is_* in drivers/ directory. You shouldn't control your
PHY directly, you need a PHY driver.

--=20
balbi

--ggEtdcIX3XIOBw6T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfA/mAAoJEIaOsuA1yqREbssQAIdrvvS8iL5u7QSHry04HcvF
7lW5oua8SpgGjim258febzOH2no638JFJHN5nPfRQPPnMGI9CTEXjZtRm472pIMO
2WOLnxOsMd8oiv5yOPhi9F01E00jf0FguuL92149W6xZwfn2yMmWw1rAA5OEyfvU
cDhCm67OoXqHVhkP4DW+ZZsMVC42oLWKYdbpWgU1xEJwb3Ris00JwgyNT5HFYp7J
hopdTb4brDlCZf2YI5f5rVYDog/IRaj2mDWJ7fLSvxtufFfmvBZUIh3xPQ7mVuaE
vI+svFi7bLvjemS6omPeajZX/lbk/pNDbLjEX7789jV1lgCIuQtOYNNMSKOr/x22
EDMjRfwz0SbN2U2ydWfUhW+L0wLu+4c5nZadB9wfX/wRy1rJXgHRJ9s4SDTGiwfm
qt735TXUZwZ+OywavmwCYbwyqFWu/81g6cZ8DyK9l1GVKfFuYnbqdg9nRpNNSmwd
38PtTfJH+5Zj3URKIwGgeCUJkhbDKEIsKzKwXalh9OPX03qmyw8Gqcng7sLwZwyP
/RLAbIwWJSkAZ/S1j4NRtTVxrdsXFekPbJgiDKcSkHHamy8V1OrotUyEph55m3QG
2kb/Q68F5TGnjhfgu65OnSAn1uNQqAAcnVHfsw4gH8HAy+YM1+d1WiaHwnavVIeK
6rDKdApFwZY4CQFqdp9m
=58K/
-----END PGP SIGNATURE-----

--ggEtdcIX3XIOBw6T--
