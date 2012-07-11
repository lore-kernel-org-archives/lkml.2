Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab2GKBgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:36:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52700 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755064Ab2GKBgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:36:44 -0400
Message-ID: <1341970599.25597.314.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 26/48] udf: Avoid run away loop when partition table length
 is corrupted
From: Ben Hutchings <ben@decadent.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Wed, 11 Jul 2012 02:36:39 +0100
In-Reply-To: <20120710160452.GB19005@quack.suse.cz>
References: <20120709143116.348975190@decadent.org.uk>
	 <20120709143120.461951078@decadent.org.uk>
	 <20120710155226.GH1894@decadent.org.uk>
	 <20120710160452.GB19005@quack.suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8dk5zu+AsDz4I4X2A2yk"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8dk5zu+AsDz4I4X2A2yk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-10 at 18:04 +0200, Jan Kara wrote:
> On Tue 10-07-12 16:52:26, Ben Hutchings wrote:
> > On Mon, Jul 09, 2012 at 03:31:42PM +0100, Ben Hutchings wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Jan Kara <jack@suse.cz>
> > >=20
> > > commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.
> > >=20
> > > Check provided length of partition table so that (possibly maliciousl=
y)
> > > corrupted partition table cannot cause accessing data beyond current =
buffer.
> > >=20
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > ---
> > >  fs/udf/super.c |   10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/fs/udf/super.c b/fs/udf/super.c
> > > index 9da6f4e..ce911f5 100644
> > > --- a/fs/udf/super.c
> > > +++ b/fs/udf/super.c
> > [...]
> > > @@ -1232,13 +1233,20 @@ static int udf_load_logicalvol(struct super_b=
lock *sb, sector_t block,
> > >  		return 1;
> > >  	BUG_ON(ident !=3D TAG_IDENT_LVD);
> > >  	lvd =3D (struct logicalVolDesc *)bh->b_data;
> > > +	table_len =3D le32_to_cpu(lvd->mapTableLength);
> > > +	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
> > [...]
> >=20
> > I don't think this is sufficient, unless there has been some prior
> > validation of lvd->mapTableLength.  On a 32-bit machine, the addition
> > may overflow.  The untrusted value has to be validated before doing
> > any arithmetic on it, e.g.:
> >=20
> > 	if (table_len > sb->s_blocksize - sizeof(*lv)) {
>   Yeah, thanks for spotting this! I've queued the attached patch. I don't
> find this really pressing so I'll push it in the next merge window. OK?

It's the sort of thing that I would expect to go into distribution
security updates a.s.a.p.  I don't see why it should wait that long
(though of course the merge window isn't *that* far away).

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-8dk5zu+AsDz4I4X2A2yk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/zYp+e/yOyVhhEJAQpHsxAAnpZA8ymFLFXwZk7CLmH9O2CSZxDRerzS
N8w9TzzuAxulexWa6amyw4GoydBPXkeN6MAOUkm5EidnvUBWiMmUlx6NVgdSlTYD
FE+064I01pes3FwmOJF5r5k1l/laCRZOkv3wygmWWZjNy4snM11y0XViTkYgYijq
LueX5exdvHKN1sQEvi0wg1dK6R2Zdgduird/A/7blyZiozroXmG1Ok3fk3Xmc4js
0zBmHafQXRCrW0SOOClI3c0R0qUwQevS4k78BqrqyAeo0RmB1jy3JtGp1CgvdOmD
PSS9lsNn4gbTBlQA03jdpP2I/B0o3JijlFCG2gWexK9/OXfrTb4RNwjD1RuTcTyv
+dAZV698Zj1+g156LvSGwJNMs8+l54MvZ7Vl9ZTQ4MyoKIKpEnnhIgwRbcgh+Ssq
lExEmJ99HZIUT+JWynAXBJ1MlQ9mWORq/TCVH53epj2ndZoD7inmyxtWUGyXr3jv
z3sdLeK/g1JhVZju5nPVgEajrPTsxjIhl/kqev5t2Otiv5QjTYE+Nb/I6WTC4a2i
V9bzZoeFWEcwfZvBcxyUXTRao928Q/E8eaXiEBqOLLxizMZiH0YGMQEewa/xbJXk
uUztC65W/FmGJ/oHbWCUAoCDfQRasyLBCc7pS7p0Zp8DydBNsmiNDaIvRVmIZ3X8
WL8ZgjtrzG8=
=nCHf
-----END PGP SIGNATURE-----

--=-8dk5zu+AsDz4I4X2A2yk--
