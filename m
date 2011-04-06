Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1DFOZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:25:04 -0400
Received: from smtp208.alice.it ([82.57.200.104]:42592 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab1DFOZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:25:01 -0400
Date: Wed, 6 Apr 2011 16:24:31 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
Message-Id: <20110406162431.cbcb0fd6.ospite@studenti.unina.it>
In-Reply-To: <1302098968.4090.0.camel@jlt3.sipsolutions.net>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	<1302082178.3811.7.camel@jlt3.sipsolutions.net>
	<20110406160654.e629dfde.ospite@studenti.unina.it>
	<1302098968.4090.0.camel@jlt3.sipsolutions.net>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Apr_2011_16_24_31_+0200_kM4C5eEmAhm0ndUk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Apr_2011_16_24_31_+0200_kM4C5eEmAhm0ndUk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Apr 2011 16:09:28 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2011-04-06 at 16:06 +0200, Antonio Ospite wrote:
>=20
> > > > +	if (regulator_is_enabled(vcc)) {
> > > > +		dev_dbg(&pdev->dev, "Regulator already enabled\n");
> > > > +		rfkill_data->reg_enabled =3D 1;
> > > > +	}
> > > > +	rfkill_init_sw_state(rf_kill, !rfkill_data->reg_enabled);
> > > > +
> > > > +	ret =3D rfkill_register(rf_kill);
> > >=20
> > > We recently had a thread about how rfkill_init_sw_state() isn't quite
> > > working the right way. Also, it is indented to be used for devices th=
at
> > > keep their state over resume. I think you should remove it here and r=
ely
> > > on rfkill to sync you after registration.
> > >=20
> > > Cf. the long thread here:
> > > http://thread.gmane.org/gmane.linux.acpi.devel/49577
> > >
> >=20
> > Ok, but I still need to replace that call with a rfkill_set_sw_state()
> > to expose the initial status of the regulator to the rfkill system,
> > right?
>=20
> Well, you could, but if you don't do that then the rfkill subsystem will
> simply call set_block() shortly after registration to put it into the
> state that it thinks it should be in, which is usually more useful.
>=20

I see, let's just drop rfkill_init_sw_state() then.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__6_Apr_2011_16_24_31_+0200_kM4C5eEmAhm0ndUk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2cd58ACgkQ5xr2akVTsAF/kQCfbMOLILqwo6ezUCgKUrV7EtcQ
lKoAnikpZcgtBRBntMph9zxpklX8nREz
=nDLU
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Apr_2011_16_24_31_+0200_kM4C5eEmAhm0ndUk--
