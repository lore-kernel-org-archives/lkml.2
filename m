Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab2GHUwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 16:52:39 -0400
Received: from mail.gw90.de ([188.40.100.199]:44938 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab2GHUwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 16:52:38 -0400
Message-ID: <1341780745.4660.8.camel@mattotaupa>
Subject: Re: [PATCH 4/7] drivers/gpu/drm: remove invalid reference to list
 iterator variable
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: David Airlie <airlied@linux.ie>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Sun, 08 Jul 2012 22:52:25 +0200
In-Reply-To: <1341747464-1772-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1341747464-1772-5-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NQbdjuBh9LbTw/oXyUOw"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NQbdjuBh9LbTw/oXyUOw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Julia,


Am Sonntag, den 08.07.2012, 13:37 +0200 schrieb Julia Lawall:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> If list_for_each_entry, etc complete a traversal of the list, the iterato=
r
> variable ends up pointing to an address at an offset from the list head,
> and not a meaningful structure.  Thus this value should not be used after
> the end of the iterator.
>=20
> In the first two cases, a a break is added after the switch; the break in

s,a a,a,

> the switch would jump out of the switch, but not out of the complete
> iteration.
>=20
> In the first case, the null test on connector is removed, because the
> iterator variable of list_for_each_entry is never null.
>=20
> In the third case, entry->base.crtc.fb is not a meaningful value.  What
> seems to be intended is crtc->fb, which gets the information from the las=
t
> element of the list.

maybe three separate patches would have been better?

> These problems were found using Coccinelle (http://coccinelle.lip6.fr/).

I always liked your example Coccinelle code snippets. Could you add them
again to your commit messages? That would be awesome!

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
>  drivers/gpu/drm/gma500/mdfld_intel_display.c |    4 +---
>  drivers/gpu/drm/gma500/oaktrail_crtc.c       |    1 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c          |    2 +-
>  3 files changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/gma500/mdfld_intel_display.c b/drivers/gpu/d=
rm/gma500/mdfld_intel_display.c
> index 3f3cd61..fc1ced0 100644
> --- a/drivers/gpu/drm/gma500/mdfld_intel_display.c
> +++ b/drivers/gpu/drm/gma500/mdfld_intel_display.c
> @@ -755,9 +755,6 @@ static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
>  					sizeof(struct drm_display_mode));
> =20
>  	list_for_each_entry(connector, &mode_config->connector_list, head) {
> -		if (!connector)
> -			continue;
> -
>  		encoder =3D connector->encoder;
> =20
>  		if (!encoder)
> @@ -779,6 +776,7 @@ static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
>  			is_hdmi =3D true;
>  			break;
>  		}
> +		break;
>  	}
> =20
>  	/* Disable the VGA plane that we never use */
> diff --git a/drivers/gpu/drm/gma500/oaktrail_crtc.c b/drivers/gpu/drm/gma=
500/oaktrail_crtc.c
> index f821c83..4b2172e 100644
> --- a/drivers/gpu/drm/gma500/oaktrail_crtc.c
> +++ b/drivers/gpu/drm/gma500/oaktrail_crtc.c
> @@ -329,6 +329,7 @@ static int oaktrail_crtc_mode_set(struct drm_crtc *cr=
tc,
>  			is_mipi =3D true;
>  			break;
>  		}
> +		break;
>  	}
> =20
>  	/* Disable the VGA plane that we never use */
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c b/drivers/gpu/drm/vmwgfx=
/vmwgfx_ldu.c
> index 070fb23..634611a 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
> @@ -93,7 +93,7 @@ static int vmw_ldu_commit_list(struct vmw_private *dev_=
priv)
> =20
>  		if (crtc =3D=3D NULL)
>  			return 0;
> -		fb =3D entry->base.crtc.fb;
> +		fb =3D crtc->fb;
> =20
>  		return vmw_kms_write_svga(dev_priv, w, h, fb->pitches[0],
>  					  fb->bits_per_pixel, fb->depth);

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>


Thanks,

Paul

--=-NQbdjuBh9LbTw/oXyUOw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk/58wkACgkQPX1aK2wOHViFEwCgg6jnQ8eQ8AODrd4z7YUQh4JW
vTkAoIrEyrVY+YXodmegg0eJsvxbntvM
=Hh2I
-----END PGP SIGNATURE-----

--=-NQbdjuBh9LbTw/oXyUOw--

