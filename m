Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab2HKIvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 04:51:05 -0400
Received: from mail.gw90.de ([188.40.100.199]:51911 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab2HKIvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 04:51:02 -0400
Message-ID: <1344675049.5674.14.camel@mattotaupa>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: ingore eDP bpc settings
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Date: Sat, 11 Aug 2012 10:50:49 +0200
In-Reply-To: <1344589820-9753-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1344589820-9753-1-git-send-email-daniel.vetter@ffwll.ch>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BJY5GZIAO6ExwyGkxWgr"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BJY5GZIAO6ExwyGkxWgr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 10.08.2012, 11:10 +0200 schrieb Daniel Vetter:

There is a typo in the commit summary: i*gn*ore.

> This has originally been introduced to not oversubscribe the dp links
> in
>=20
> commit 885a5fb5b120a5c7e0b3baad7b0feb5a89f76c18
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Tue Jan 12 05:38:31 2010 +0800
>=20
>     drm/i915: fix pixel color depth setting on eDP
>=20
> Since then we've fixed up the dp link bandwidth calculation code for
> code

`for code` should be removed.

> and should now automatically fall back to 6bpc dithering. So this
> is unnecessary.
>=20
> Furthermore it seems to break the new MacbookPro with retina display,
> hence let's just rip this out.
>=20
> Reported-by: Benoit Gschwind <gschwind@gnu-log.net>
> Cc: Benoit Gschwind <gschwind@gnu-log.net>
> Cc: Francois Rigaut <frigaut@gmail.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>=20
> --
>=20
> Testing feedback highgly welcome, and thanks for Benoit for finding
> out that the bpc computations are busted.
> -Daniel
> ---
>  drivers/gpu/drm/i915/intel_display.c |   11 -----------
>  1 file changed, 11 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/=
intel_display.c
> index bddb290..ddd4db3 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -3755,17 +3755,6 @@ static bool intel_choose_pipe_bpp_dither(struct dr=
m_crtc *crtc,
>  			continue;
>  		}
> =20
> -		if (intel_encoder->type =3D=3D INTEL_OUTPUT_EDP) {
> -			/* Use VBT settings if we have an eDP panel */
> -			unsigned int edp_bpc =3D dev_priv->edp.bpp / 3;
> -
> -			if (edp_bpc < display_bpc) {
> -				DRM_DEBUG_KMS("clamping display bpc (was %d) to eDP (%d)\n", display=
_bpc, edp_bpc);
> -				display_bpc =3D edp_bpc;
> -			}
> -			continue;
> -		}
> -
>  		/* Not one of the known troublemakers, check the EDID */
>  		list_for_each_entry(connector, &dev->mode_config.connector_list,
>  				    head) {

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>


Thanks,

Paul

--=-BJY5GZIAO6ExwyGkxWgr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAmHOkACgkQPX1aK2wOHVg+CwCdF4qKtm9YkOvDH1i5LTG1mg9g
DGYAniuUdJjDZQGnM8hkg/RSOKd0VO6d
=F++p
-----END PGP SIGNATURE-----

--=-BJY5GZIAO6ExwyGkxWgr--

