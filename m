Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0KYCjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 21:39:25 -0500
Received: from ozlabs.org ([203.10.76.45]:49109 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686Ab0KYCjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 21:39:24 -0500
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
 label key entries
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, linux-kernel@vger.kernel.org
In-Reply-To: <1290613997.30543.529.camel@gandalf.stny.rr.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
	 <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com>
	 <1290611478.2072.482.camel@laptop> <20101124151936.GB2815@redhat.com>
	 <1290612245.2072.486.camel@laptop>  <20101124154200.GD2815@redhat.com>
	 <1290613997.30543.529.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-59KmcWMqFJUlOFs4/H2l"
Date: Thu, 25 Nov 2010 13:39:22 +1100
Message-ID: <1290652762.18088.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-59KmcWMqFJUlOFs4/H2l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-24 at 10:53 -0500, Steven Rostedt wrote:
> On Wed, 2010-11-24 at 10:42 -0500, Jason Baron wrote:
>=20
> > > And I think the only arch where you can do text pokes without cross-c=
pu
> > > synchronization is one that doesn't have SMP support.
> > >=20
> > >=20
> >=20
> > is this really true?
> >=20
> > The powerpc implementation uses patch_instruction():
> >=20
> >=20
> > arch/powerpc/lib/code-patching.c:
> >=20
> > void patch_instruction(unsigned int *addr, unsigned int instr)
> > {
> >         *addr =3D instr;
> >         asm ("dcbst 0, %0; sync; icbi 0,%0; sync; isync" : : "r"
> > (addr));
> > }
>=20
> Is this ever called outside of boot up? After SMP is enabled? (besides
> for creating trampolines, before they are used).

It is now :)

AFAIK it works fine, the icbi invalidates across all processors. The
only issue is that it's not precise, ie. another CPU might not see the
update immediately, but as soon as it takes an interrupt or something it
will.

What would suit us would be to have an arch callback that is called
after all the transforms for a particular jump label key have been made.
That way we could optimise the individual patches, and do a sync step at
the end, ie. when we want the effect of the patching to be globally
visible.

cheers



--=-59KmcWMqFJUlOFs4/H2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkztzFcACgkQdSjSd0sB4dL2JgCgtIA/d3vWKNTYOu/C8VG8z2HV
5SQAoMAqdfV6gDRb1evbUZMgvwPCuGGY
=bimi
-----END PGP SIGNATURE-----

--=-59KmcWMqFJUlOFs4/H2l--

