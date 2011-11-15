Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab1KOT6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:58:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab1KOT6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:58:46 -0500
Message-ID: <1321387118.27038.17.camel@fourier>
Subject: Re: [PATCH] i915: Fix bug where screen brightness is not restored
From: Kamal Mostafa <kamal@canonical.com>
To: Alex Davis <alex14641@yahoo.com>, Keith Packard <keithp@keithp.com>,
        "mjg@redhat.com" <mjg@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Date: Tue, 15 Nov 2011 11:58:38 -0800
In-Reply-To: <1321324952.13838.YahooMailNeo@web130105.mail.mud.yahoo.com>
References: <1321324952.13838.YahooMailNeo@web130105.mail.mud.yahoo.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-iFt7jtqXXUldpoHNBEU5"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iFt7jtqXXUldpoHNBEU5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-11-14 at 18:42 -0800, Alex Davis wrote:
> From: Alex Davis<alex14641@yahoo.com>
>=20
> This patch fixes an issue where the screen would remain dark when
>=20
> a key was pressed when the laptop lid was reopened or after the
> laptop had gone into power-save mode.

[cross-posting to intel-gfx]

Keith, also note that Alex and I did respond to your request to test the
already committed patch "drm/i915/panel: Always record the backlight
level again (but cleverly)".  We both determined that patch does *not*
fix the problem.  Alex's patch below does fix it.

Matthew, any comment on the question that I fielded?:

>> Why does intel_panel_disable_backlight even want to set the
>> brightness to 0 anyway?...  Its only caller is just about to turn
>> off power to the panel.  Is that call to
>> intel_panel_{,actually_}set_backlight(dev, 0) really necessary
>> or useful on *any* systems?

 -Kamal


> It seems that there are a number of people with different machines
> that have this problem:
>=20
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/872652
> https://launchpad.net/~kamalmostafa/+archive/stuck-backlight
> and https://bugs.freedesktop.org/show_bug.cgi?id=3D41926
>=20
> This patch is against Linux 3.1
>=20
> Putting printk's in ./drivers/gpu/drm/i915/intel_panel.c showed that=20
> intel_get_brightness was being called after the panel was disabled,
> which caused a 0 to be saved as the value to restore the brightness.=20
> intel_panel_disable_backlight merely sets the brightness to 0. Commenting
> out this call allows the correct brightness value to be saved.
>=20
> Signed-off-by: Alex Davis <alex14641@yahoo.com>
> Tested-by: Kamal Mostafa <kamal@canonical.com>
> -----
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/in=
tel_panel.c
> index a9e0c7b..6f56676 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -262,8 +262,6 @@ void intel_panel_disable_backlight(struct drm_device =
*dev)
>                 dev_priv->backlight_level =3D intel_panel_get_backlight(d=
ev);
>                 dev_priv->backlight_enabled =3D false;
>         }
> -
> -       intel_panel_set_backlight(dev, 0);
>  }
>=20
>  void intel_panel_enable_backlight(struct drm_device *dev)
>=20
> =20
>=20
> I code, therefore I am
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20


--=-iFt7jtqXXUldpoHNBEU5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJOwsRuAAoJEOf3EFVUCeQiJ4MP/jpPD4fmnpUY1DcoTIZSTZFS
x3INDaHVEu4FjWijrMrxLdaWmnVNKMx4COJMnhlicQpIBJgbrBH1+jaiZTPTr4Rd
EHqqhdfk/GHWIZ/Dm4UwMCO9OkgXrWHZgc3+T7Ydhi14ionTpOC65pBbMdWCdH9A
5xcoNBglhucYK0j5yQBlBg5pZYpE4vP9SXgkuciCtNjego0PekNWODRURGkP0yJ7
ez6o16pTYM0SSvDXSEoW1CGHuKdpp8/miNLabHObKQE/UOMYwJRoYCu+ymVVEls5
TnIc43iqSs52gBbKNj/Guyql61AuIaMy+FLdt3kXsOB02a0Gus9bAKiN0Tj1ytmj
Hn3EplZXTY8l4d+fX73wCgKHi4XPCEio9zO1VLCjV1J59rEqb6ebMx6/5mgQhwVA
Ui8mB1wu/Oh1ZUStk95kHQOstG5GfFB5qfpwstuEvhJLpFtmQvOhEfv/9wvArpRj
sUrIgG5O12PG4QDFO5fyo7FLxS45njUavajlPKX3j++Jcgt93+HfepX74vdB3CYB
1oWQ+HRe0fUbUCzuUSPGm/UcBUV1Fvi/vTGKw7J7sKDgv7O1xKCaLueOgavwYkUs
XPyx24yrksxX/pW4bzfQOtVHOkuNdV6V4sOFqijg/R0yIjVz3a7XNSXQ75Jg00Q/
kYzkJSQr/UTUQ2n7nEPH
=qxd3
-----END PGP SIGNATURE-----

--=-iFt7jtqXXUldpoHNBEU5--

