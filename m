Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab1DMIoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:44:37 -0400
Received: from smtp205.alice.it ([82.57.200.101]:56174 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab1DMIof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:44:35 -0400
Date: Wed, 13 Apr 2011 10:44:02 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH v2] rfkill: Regulator consumer driver for rfkill
Message-Id: <20110413104402.d0115659.ospite@studenti.unina.it>
In-Reply-To: <1302608642.3639.17.camel@jlt3.sipsolutions.net>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
	<1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
	<1302608488.3639.15.camel@jlt3.sipsolutions.net>
	<1302608642.3639.17.camel@jlt3.sipsolutions.net>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_Apr_2011_10_44_02_+0200_3ahMGlXs2nCEJT5K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Apr_2011_10_44_02_+0200_3ahMGlXs2nCEJT5K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Apr 2011 13:44:02 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Tue, 2011-04-12 at 13:41 +0200, Johannes Berg wrote:
>=20
> > > + * static struct regulator_consumer_supply pcap_regulator_V6_consume=
rs [] =3D {
> > > + * 	{ .dev_name =3D "rfkill-regulator.0", supply =3D "vrfkill" },
> > > + * };
> >=20
> > It's a comment, but it should be .supply =3D (missing the .)
> >

well spotted, I'll fix this.

> > > +	if (pdata->name =3D=3D NULL || pdata->type =3D=3D 0) {
> > > +		dev_err(&pdev->dev, "invalid name or type in platform data\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	vcc =3D regulator_get_exclusive(&pdev->dev, "vrfkill");
> >=20
> > Wasn't that supposed to use pdata->supply? Actually, there's no member
> > "supply" in the struct?
>=20
> Oh wait, I think I just misunderstood how this works. But if the name is
> "vrfkill" how does that really work with multiple instances?
>

That's how the regulator framework works, I know Mark already replied to
you but I try to elaborate more for the records and to organize my=20
thoughts about that:

 - In the consumers for the regulator we choose the virtual supply,
   "vrfkill" in this case, and which driver is going to use it.

 - Wrt. to multiple instances, they are distinguished using device ids.

   When we set consumers for a physical regulator we can tell: device
   "rfkill-regulator.1" will call this regulator "vrfkill" and we
   declare the relative rfkill-regulator platform device with .id=3D1,
   this way the regulator framework knows what physical regulator to
   return when asked for vrfkill _from_ a rfkill-regulator platform
   device instance with .id=3D=3D1

I hope I am not introducing any inaccuracies :)

A v3 of the patch is on its way.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__13_Apr_2011_10_44_02_+0200_3ahMGlXs2nCEJT5K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2lYlIACgkQ5xr2akVTsAEHgwCeLoQn+4pdfzjNybhGqkO/UQsZ
2roAn30ToYZp7oaoPNBIotE9FXiybPpv
=AUSS
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Apr_2011_10_44_02_+0200_3ahMGlXs2nCEJT5K--
