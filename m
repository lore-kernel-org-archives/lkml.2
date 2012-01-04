Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2ADHM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:12:26 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:49647 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910Ab2ADHMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:12:23 -0500
Subject: Re: [PATCH 12/15] module_param: make bool parameters really bool
 (drivers & misc)
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
In-Reply-To: <87ehw6sesk.fsf@rustcorp.com.au>
References: <87ehw6sesk.fsf@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mP76F8GUuwUIEJF6t4kO"
Date: Wed, 04 Jan 2012 09:12:18 +0200
Message-ID: <1325661138.1875.6.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mP76F8GUuwUIEJF6t4kO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2011-12-15 at 13:48 +1030, Rusty Russell wrote:
> module_param(bool) used to counter-intuitively take an int.  In
> fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
> trick.
>=20
> It's time to remove the int/unsigned int option.  For this version
> it'll simply give a warning, but it'll break next kernel version.
>=20
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

The changes below break compilation for omapdss and omapfb: dss_debug
and omapfb_debug are declared in dss.h and omapfb.h, and those
declarations are not changed, resulting in conflicting types error.

Perhaps extra care should be taken in cases where the variable in
question is not declared as static.

 Tomi

> diff --git a/drivers/video/omap2/dss/core.c
> b/drivers/video/omap2/dss/core.c
> --- a/drivers/video/omap2/dss/core.c
> +++ b/drivers/video/omap2/dss/core.c
> @@ -50,7 +50,7 @@ module_param_named(def_disp, def_disp_na
>  MODULE_PARM_DESC(def_disp, "default display name");
> =20
>  #ifdef DEBUG
> -unsigned int dss_debug;
> +bool dss_debug;
>  module_param_named(debug, dss_debug, bool, 0644);
>  #endif


> diff --git a/drivers/video/omap2/omapfb/omapfb-main.c
> b/drivers/video/omap2/omapfb/omapfb-main.c
> --- a/drivers/video/omap2/omapfb/omapfb-main.c
> +++ b/drivers/video/omap2/omapfb/omapfb-main.c
> @@ -43,18 +43,18 @@
> =20
>  static char *def_mode;
>  static char *def_vram;
> -static int def_vrfb;
> +static bool def_vrfb;
>  static int def_rotate;
> -static int def_mirror;
> +static bool def_mirror;
>  static bool auto_update;
>  static unsigned int auto_update_freq;
>  module_param(auto_update, bool, 0);
>  module_param(auto_update_freq, uint, 0644);
> =20
>  #ifdef DEBUG
> -unsigned int omapfb_debug;
> +bool omapfb_debug;
>  module_param_named(debug, omapfb_debug, bool, 0644);
> -static unsigned int omapfb_test_pattern;
> +static bool omapfb_test_pattern;
>  module_param_named(test, omapfb_test_pattern, bool, 0644);
>  #endif

--=-mP76F8GUuwUIEJF6t4kO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPA/vOAAoJEPo9qoy8lh71idMQAKXzm+3bojxo+B1RxjckaSmd
PynXe85D4ekfSPmCrkYGVEVWNc3ImLZn8HhIt+YXZY/HtPNuROy+zgNSD64hkhJf
j/hXQWoF9yyqi/nSX1kd8qA026CtDeSvEel49xlFbVUNeyvKG+MSOQAsKz3VEIcr
9RuUECmMqxv9UZx+N+2l/rO0R8NYGqpPlSd+hUeG4fOgVAizWxZgyD5xSDAwRUPy
lFhHL5dq521kzxSK5a/BTdQlsSfkvDBWDhez1c5yi3LSjTUd/FZJL9yoZz3orYUs
21fxGxT5oLMMRxkevc5ZWqNGfk6BmTc2XTWA7LjnRzIsUfKCfHrx7esu0IsnpqRK
eHU6I/Wf311Nk34Zcx6NvwoW9cSz46wQOZEn8PPpRrFVbhKtnoX5cxzeC4Aroz+N
7uRFvrOmQay8aj/jW4l3D0XbO22BJssPO4u7w6g1NIRKY9Sbo0JzA6YunGW+fB32
9a+zWHViswRmyMkI9e/0YVKd8r4ZZAACo60ex9AIynyLO97a6Ufk/t667J84Qol7
Gy/ikcAD1Xo5QSKwd0GeyiQT+X/j+214sWjts5/i8Fk3kua0pIomRsC/syVvnjDk
47YZcy47twzbfTV4KKMxutVbiV3cXNYKRirvB6IZXvrKDJAjl1rNSTOA7MuVIEZE
dCP9HSN/TVvnRwKEB1z0
=nMyR
-----END PGP SIGNATURE-----

--=-mP76F8GUuwUIEJF6t4kO--

