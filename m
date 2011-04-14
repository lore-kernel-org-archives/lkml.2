Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab1DNKjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:39:32 -0400
Received: from smtp205.alice.it ([82.57.200.101]:50568 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932734Ab1DNKjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:39:31 -0400
Date: Thu, 14 Apr 2011 12:39:12 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH v3] rfkill: Regulator consumer driver for rfkill
Message-Id: <20110414123912.71e4bd52.ospite@studenti.unina.it>
In-Reply-To: <1302724383.3731.19.camel@jlt3.sipsolutions.net>
References: <1302686356.3731.1.camel@jlt3.sipsolutions.net>
	<1302723645-5286-1-git-send-email-ospite@studenti.unina.it>
	<1302724383.3731.19.camel@jlt3.sipsolutions.net>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_Apr_2011_12_39_12_+0200_L80X_2yOHb.gfFab"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Apr_2011_12_39_12_+0200_L80X_2yOHb.gfFab
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Apr 2011 21:53:03 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2011-04-13 at 21:40 +0200, Antonio Ospite wrote:
>=20
> > +static int __devinit rfkill_regulator_probe(struct platform_device *pd=
ev)
>=20
> ...
>=20
> > +	platform_set_drvdata(pdev, rfkill_data);
>=20
> > +static int __devexit rfkill_regulator_remove(struct platform_device *p=
dev)
> > +{
> > +	struct rfkill_regulator_data *rfkill_data =3D platform_get_drvdata(pd=
ev);
> > +	struct rfkill *rf_kill =3D rfkill_data->rf_kill;
> > +
> > +	rfkill_unregister(rf_kill);
> > +	rfkill_destroy(rf_kill);
> > +	regulator_put(rfkill_data->vcc);
> > +	kfree(rfkill_data);
> > +
> > +	return 0;
> > +}
>=20
> Should remove do platform_set_drvdata(pdev, NULL)?
>

AFAICS this is not strictly necessary because we never check for NULL
here and we are setting drvdata again in _probe() each time the module
is loaded anyways. If it is considered a good practice for symmetry
reasons then I'll add it, no problem. Does anyone has comments on that?

> In any case, that's the only thing I see now and I did read the code
> carefully, so if that's not necessary:
>=20
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Otherwise, feel free to include that in v4.
>=20
> johannes
>=20

Thanks for taking the time to look at the code Johannes.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Thu__14_Apr_2011_12_39_12_+0200_L80X_2yOHb.gfFab
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2mztAACgkQ5xr2akVTsAHD4wCfU3uRGqi81k+JSR45pHapfyW2
u00AnjTt0UdYFp0W+Esg+XOpA8v/rNqm
=rVRz
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Apr_2011_12_39_12_+0200_L80X_2yOHb.gfFab--
