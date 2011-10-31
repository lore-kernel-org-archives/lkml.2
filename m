Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481Ab1JaNo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:44:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38836 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932687Ab1JaNoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:44:54 -0400
Message-ID: <1320068657.6759.107.camel@deadeye>
Subject: Re: [PATCH 2/2] module: Re-enable dynamic debugging for
 GPL-compatible OOT modules
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>, Jason Baron <jbaron@redhat.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Dave Jones <davej@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Mon, 31 Oct 2011 13:44:17 +0000
In-Reply-To: <87obwxq5tz.fsf@rustcorp.com.au>
References: <1319773094.6759.32.camel@deadeye>
	 <87obwxq5tz.fsf@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SS/GDoq/RvMdYxoHgopc"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SS/GDoq/RvMdYxoHgopc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-10-31 at 12:29 +1030, Rusty Russell wrote:
> On Fri, 28 Oct 2011 04:38:14 +0100, Ben Hutchings <ben@decadent.org.uk> w=
rote:
> > Dynamic debugging was enabled for GPL-compatible out-of-tree modules
> > until my addition of TAINT_OOT_MODULE.  It should continue to be
> > enabled now.
>=20
> Please just remove the test entirely.
>=20
> AFAICT there's nothing unique to dynamic debug which means it should
> avoid taint.  If it oopses, we'll learn all about tainting in the oops
> message.

It looks like the dynamic debug facility is not meant to be available to
proprietary modules.

Ben.

> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  kernel/module.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/kernel/module.c b/kernel/module.c
> > index dab585e..448fd77 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2881,7 +2881,7 @@ static struct module *load_module(void __user *um=
od,
> >  	}
> > =20
> >  	/* This has to be done once we're sure module name is unique. */
> > -	if (!mod->taints || mod->taints =3D=3D (1U<<TAINT_CRAP))
> > +	if (!(mod->taints & ~(1U << TAINT_CRAP | 1U << TAINT_OOT_MODULE)))
> >  		dynamic_debug_setup(info.debug, info.num_debug);
> > =20
> >  	/* Find duplicate symbols */
> > @@ -2918,7 +2918,7 @@ static struct module *load_module(void __user *um=
od,
> >  	module_bug_cleanup(mod);
> > =20
> >   ddebug:
> > -	if (!mod->taints || mod->taints =3D=3D (1U<<TAINT_CRAP))
> > +	if (!(mod->taints & ~(1U << TAINT_CRAP | 1U << TAINT_OOT_MODULE)))
> >  		dynamic_debug_remove(info.debug);
> >   unlock:
> >  	mutex_unlock(&module_mutex);
> > --=20
> > 1.7.7
> >=20
> >=20
>=20

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-SS/GDoq/RvMdYxoHgopc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATq6mMue/yOyVhhEJAQocXQ//SU6CfEVGAWkLD1SEKoooH2fhUALERwGg
EZudlLWIFg7oOu1vRWLcvWs0Dp2tgfk+/zYS72cme+McGFw8duVIBJcWoRb4agaZ
Psodb980FhqUiDgEnbLVdpxbuGeW05tcELjADumPHdSRSkNpvyuDJMAtSQPLq/AM
TOA3sSk1YFizt13sKZQu4gBpzoeFnE6OywsRj2PkzDDM/KsLPRNDmXfljtIDhdoR
O9B/A8HAuS1b9jnqpg00g/Fj5VKyRar/kL0N2uBRBwr4J5YVtCZ9kmruRkvllVR5
qM0zAGJNevLrEYAlenywYlzkrlnA/4ud0j25Q4C0+ckPmEr2rWFNS+8K7epQ08J5
OMlKl9pZGWml4r0aEFngoqeJE+HBf8bKa/j40Hmb5Q9AC3nUDwb7dFntgBqrG5R7
2SVblCUjf4QKJaPN8nln80UZ6k8tIkXoytVR8q3ISxIjpPinfFfKU7bPSJ2avroL
ImohnVN4URzk0Rr8RVpwNu5yvxf/UGneOuYccLhs7Poji3Xg07MWBKEcAfewqXKX
5N6ml5aV+ToWjjW7rnjruXhyxR3DwZylBlPgDAajFOQVOeeTGBkbTj/t6fRp0KT1
X/30fX6oaktGbxbzxfw6oOOrz0sW4CbcA3q/eu5BlrNQredAFCmODRonKPn4KY+Z
MMMMCzOWtjM=
=y19+
-----END PGP SIGNATURE-----

--=-SS/GDoq/RvMdYxoHgopc--
