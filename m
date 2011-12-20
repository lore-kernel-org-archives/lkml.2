Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1LTLEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:04:21 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:46236 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab1LTLEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:04:12 -0500
Date: Tue, 20 Dec 2011 13:04:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Benoit Goby <benoit@android.com>, Li Yang <leoli@freescale.com>,
        "open list:MUSB MULTIPOINT H..." <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v4 4/4] usb: simplify hdrc configuration
Message-ID: <20111220110404.GD31842@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
 <1324343717-7292-5-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
In-Reply-To: <1324343717-7292-5-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 20, 2011 at 03:15:17AM +0200, Felipe Contreras wrote:
> HDRC requires either NOP_USB_XCEIV or TWLX030_USB, and it selects the

that's not entirely true. Like any USB Link controller, MUSB needs a PHY
to work, but can be any off-the-shelf PHY. Nokia has used isp1704 and
isp1707 for instance. I guess Nokia also used tusb1211 and none of them
are listed there.

I would rather remove all the dependencies because the person compiling
the kernel should know that a Link needs a PHY. Maybe add a note
somewhere stating that you should enable the PHY driver for your
platform ?

> right one based on architectures or board.
>=20
> However, many OMAP2+ boards are excluded from this selection and it's
> possible to have a configuration with no transceiver, so HDRC doesn't
> work.
>=20
> What we need is a 'soft' dependency, and this can be achieved by
> transforming the 'selects' to 'default'. This way we can have sane
> defaults for all OMAP2+ boards, and the ones that need NOP can just
> specify that manually.
>=20
> This simplifies the config from:
>=20
>      CONFIG_USB=3Dy
>      CONFIG_TWL4030_CORE=3Dy
>      CONFIG_TWL4030_USB=3Dy
>=20
> To:
>=20
>      CONFIG_USB=3Dy
>      CONFIG_TWL4030_CORE=3Dy
>=20
> And so on.
>=20
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  drivers/usb/musb/Kconfig |    4 +---
>  drivers/usb/otg/Kconfig  |    3 +++
>  2 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
> index 07a0346..b60d3a5 100644
> --- a/drivers/usb/musb/Kconfig
> +++ b/drivers/usb/musb/Kconfig
> @@ -7,9 +7,7 @@
>  config USB_MUSB_HDRC
>  	depends on USB && USB_GADGET
>  	depends on (ARM || (BF54x && !BF544) || (BF52x && !BF522 && !BF523))
> -	select NOP_USB_XCEIV if (ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN)
> -	select TWL4030_USB if MACH_OMAP_3430SDP
> -	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
> +	depends on (NOP_USB_XCEIV || TWL4030_USB || TWL6030_USB)

on commit log, you said you were converting select to default, but here
you're converting select to depend. I have just added a patch allowing
musb to compile on all ARCHes and cannot take this step backwards.
Sorry. Any chance to resping this patch in another way ?

--=20
balbi

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8GukAAoJEIaOsuA1yqRE0XEQAJnicQ+Wftt/vJriU8nQ/ctP
3H/6CIeaG4iJU8LyBz0deYs540Hb2gOCJtnMCeUSi8DfELZ70rbZ9NWhua/m/4F7
vGMt+0OAd/qBBbJzfyb2Dw1bc2dSVBI2ZvMIkvkexp1busSg/s5pIcVpugAFHd6w
u8WRLn6T1XQbUtUJ7EVzpw9bfl2mkzafpxelHZYSbB2DG3K7VmAnp9xQZ+pRnnpb
SV9ivCfpOy6NTZoWaDiQHOYKLis53sZ2FpaTpSYnqsmYgutyZDH3CMSDIXRVJu9a
EABDfTBCWtL+lsmHYcmEreRUV9oyIvnDIMLFOkeC8Fm29/XUocpbKzTGS9Hug53g
50TM0GqcrD9m7Wn1UgqS+oiDkQUbB1ukcJ5VINniLU3pY3BUQQqtBGf2n79Rs4tS
wgEwZqGsB6y8lowukuzWsCAZOTL6k/kiBLsiFSMHun4L9md0+69+8jpWcHNFGd1q
x+kQk5HSPyXTzq3XMSGXQJ+kyowDDoUP8NnXHgiNklVQWhSoemgRIs1cBp3Uucia
4AT2S6+kOdK1e4c6dme4I/8dC7LaioavActNXNRpGzLOtawaDjoDc2nm6Zd+tIA3
CDcADcuoqwYKDjgc+6fYzWdyBWp36y60vZXIBARcDKiHnVLgGwmf1puB9FMr2z76
EaFyf64VOLVo96i9Yuta
=uq+R
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--
