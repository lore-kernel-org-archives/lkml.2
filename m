Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab1KOVzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:55:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41145 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1KOVy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:54:59 -0500
Message-ID: <1321394084.32358.17.camel@fourier>
Subject: Re: [Intel-gfx] [PATCH] i915: Fix bug where screen brightness is
	not restored
From: Kamal Mostafa <kamal@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alex Davis <alex14641@yahoo.com>, Keith Packard <keithp@keithp.com>,
        "mjg@redhat.com" <mjg@redhat.com>, intel-gfx@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Nov 2011 13:54:44 -0800
In-Reply-To: <s5hehx96sgk.wl%tiwai@suse.de>
References: <1321324952.13838.YahooMailNeo@web130105.mail.mud.yahoo.com>
	 <1321387118.27038.17.camel@fourier> <s5hehx96sgk.wl%tiwai@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-qBZ6aoWWnJbWxwbKazns"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qBZ6aoWWnJbWxwbKazns
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-11-15 at 21:28 +0100, Takashi Iwai wrote:
> My rough guess is the inconsistency of property taken during the
> backlight disabled.  How about the patch below (untested!) in addition
> to the fix in 3.2?
>=20
>=20
> Takashi

Yes Takashi, your patch below (plus the already committed fix[0]) does
indeed fix the problem[1] for me.  Thanks!

Tested-by: Kamal Mostafa <kamal@canonical.com>

 -Kamal

[0] f52c619a590fa75276c07dfcaf380dee53e4ea4c
    drm/i915/panel: Always record the backlight level again (but cleverly)

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/872652



> ---
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/in=
tel_panel.c
> index 499d4c0..21f60b7 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -326,7 +326,8 @@ static int intel_panel_update_status(struct backlight=
_device *bd)
>  static int intel_panel_get_brightness(struct backlight_device *bd)
>  {
>  	struct drm_device *dev =3D bl_get_data(bd);
> -	return intel_panel_get_backlight(dev);
> +	struct drm_i915_private *dev_priv =3D dev->dev_private;
> +	return dev_priv->backlight_level;
>  }
> =20
>  static const struct backlight_ops intel_panel_bl_ops =3D {
>=20


--=-qBZ6aoWWnJbWxwbKazns
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJOwt+kAAoJEOf3EFVUCeQiMagP/A11JqmDfz+KoKT0Bv0SooxM
kYOpAx7gC/QOvGQriXHaECiS+bG2vG6uRTzhCtc7taTiogEFYV5p6fVur+ZcdOYH
4mUwsvjKUD/3K5gvyXVf/+rNCTDHmWVv4PstHuCQHhzCb2IPbVX8o6eX4SEJxbUn
3wcNvMRxEb1gMpID+fE9sMMpNkAc889m0f8MHVfRri6pJEqRk0b5TNa2U+IowY1v
/6Pnz81rSsvOTow/3YLxmFIxTIHnS77ozVLrEmKd3FVfvLa7dAnXt1UeZbmyEsdL
Jf9CoJKb2WqRiyanOxjbJMfOslxBndfietUBiB4IoSpedoF7/w50FuvnLrdpEzho
ez7Dq5L85iFnjTjzL+1+lEehTH3hwd4PIUHfk1W5aSlCMHKWdu1cNKhb3gUt/Nkg
oEhcKipT5nCuwrNdJySw9r3VpjLGCcgMVBCymZpC9Fsxbp1YO6ikoET6eAjVQ1QG
vFnpYuNCpqXEfW/GkVXDxdVwuaOUCG7B594Yxc6d7EXm/pRxj5QKtViPviupeDeo
lc+J6hM1w5/2OYmmnx6ycGni6s85BzW9Dy6cp3soZxM78a5UF2LGGhwpNvlslzMG
QJgHXGHpGmvY9EPXy3H98iTJ9E76eTTIwXQvkenOlFQuUzQd0TsOLBuQiSWqZ4Ul
vLjee0aM08kkT5iUQXmU
=G5i3
-----END PGP SIGNATURE-----

--=-qBZ6aoWWnJbWxwbKazns--

