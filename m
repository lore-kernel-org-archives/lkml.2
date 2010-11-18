Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0KRLCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:02:18 -0500
Received: from ozlabs.org ([203.10.76.45]:47213 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808Ab0KRLCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:02:17 -0500
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during
 boot (v2)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Ingo Molnar <mingo@redhat.com>, Andres Salomon <dilinger@queued.net>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101118083420.GC26398@elte.hu>
References: <20101111214546.4e573cad@queued.net>
	 <reply-olpc-3-v2@mdm.bga.com> <20101112002704.50c629e2@queued.net>
	 <20101114095013.GB24206@elte.hu> <4CE0B54E.6000101@zytor.com>
	 <20101115070254.GA25243@elte.hu> <4CE17133.2050101@zytor.com>
	 <20101118083420.GC26398@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TDsR970TqK/BnEdaUhgh"
Date: Thu, 18 Nov 2010 22:02:15 +1100
Message-ID: <1290078135.22575.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TDsR970TqK/BnEdaUhgh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-18 at 09:34 +0100, Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
>=20
> > On 11/14/2010 11:02 PM, Ingo Molnar wrote:
> > >=20
> > > * H. Peter Anvin <hpa@zytor.com> wrote:
> > >=20
> > >> What?  What is wrong with static variables in functions?  It really =
doesn't seem=20
> > >> to be a good idea to make them file-scope if they don't need to be.
> > >=20
> > > They are very easy to overlook and mix up with regular stack variable=
s and i've seen=20
> > > (and introduced myself) a number of bugs due to them.
> > >=20
> > > They also often are used in buggy ways (with SMP not taken into consi=
deration), so=20
> > > overlooking them during review compounds their negative effects. Putt=
ing them in=20
> > > front of the function isnt a big deal in exchange.
> > >=20
> > > There are people who never overlook them (like yourself), but my brai=
n is wired up=20
> > > differently.
> > >=20
> >=20
> > However, I have to vehemently object to putting them in a wider scope
> > than is otherwise necessary.  I agree that static variables should be
> > used sparsely if at all (there really are vary few uses of them that ar=
e
> > valid), but putting them in a larger scope screams "I'm used in more
> > than one function", and that is *not* a good thing.
>=20
> That's why we sometimes use the (imperfect) compromise to put them in fro=
nt of that=20
> function, not at the top of the file.
>=20
> Look at the general balance of hardship: very little harm is done (it's n=
ot a big=20
> deal if a variable is only used in a single function) but having it with =
local=20
> variables can be _really_ harmful - for example i overlooked them when i =
reviewed=20
> this patch. I dont like important details obscured - i like them to be ap=
parent.=20
> Again, this is something that some people can parse immediately on the vi=
sual level=20
> - me and many others cannot.

What about:

int foo(void)
{
	static int bar;

	struct thing_struct *thing;
	int other_var;
	char *p;

	...
}

I think the visual wrongness of that formatting would be enough for me
to stop and look twice. Though I guess it doesn't work if you have few,
or no other variables other than the statics to declare.

cheers


--=-TDsR970TqK/BnEdaUhgh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzlB7MACgkQdSjSd0sB4dLRiwCePlCH9Mp4T5KVXKQ+4CLamUJ1
PvEAoMnzw47YZ3Vo7s0qkh2QRNOZyGgQ
=L99G
-----END PGP SIGNATURE-----

--=-TDsR970TqK/BnEdaUhgh--

