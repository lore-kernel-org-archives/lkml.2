Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0HVHdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 03:33:15 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:10878 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab0HVHdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 03:33:13 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <1282460275.11348.865.camel@localhost.localdomain>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	 <1282391770.29609.1223.camel@localhost.localdomain>
	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	 <1282460275.11348.865.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KuyM1442DnPTbvU7MFge"
Date: Sun, 22 Aug 2010 08:33:06 +0100
Message-ID: <1282462386.11348.871.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC] mlock/stack guard interaction fixup
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=4QByPj+6Iq2k/6L54d+eVKTdgQxdscpRskJJReCfdXo= c=1 sm=0 a=zI1UDiXOKOEA:10 a=AZfGcq7nAAAA:8 a=tKiBhGKe5aNQgzrFFswA:9 a=7Hm9BcdWHtC3l7y71wJTwQ_0FqwA:4 a=wPNLvfGTeEIA:10 a=X4IATRswnmP5DeIo1voA:9 a=2cAGClRep4Viyl-ngvenyUC9RLQA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KuyM1442DnPTbvU7MFge
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-08-22 at 07:57 +0100, Ian Campbell wrote:
> On Sat, 2010-08-21 at 08:48 -0700, Linus Torvalds wrote:
> > On Sat, Aug 21, 2010 at 4:56 AM, Ian Campbell <ijc@hellion.org.uk> wrot=
e:
> > >
> > > I don't know that they are particularly good tests for this change bu=
t I
> > > also ran allmodconfig kernel build and ltp on 2.6.35.3+fixes without
> > > issue. Are there any good mlock heavy workloads?
> >=20
> > mlock itself isn't very interesting, I think more interesting is
> > testing that the doubly linked list handles all the cases correctly.
> > Something that splits mappings, unmaps partial ones etc etc. Running
> > something like Electric Fence is probably a good idea.
>=20
> EF_DISABLE_BANNER=3D1 EF_ALLOW_MALLOC_0=3D1 LD_PRELOAD=3Dlibefence.so.0.0=
 make
>=20
> craps out pretty quickly with:
>=20
>           CC      init/main.o
>        =20
>         ElectricFence Exiting: mprotect() failed: Cannot allocate memory
>         make[1]: *** [init/main.o] Error 255
>         make: *** [init] Error 2
>=20
> but it does that with 2.6.35.3, 2.6.35.2, 2.6.35.1 and 2.6.35 too so it
> doesn't seem to be breakage relating to any of the stack guard stuff

I increased the vm.max_map_count sysctl and now things are rolling
along. Will let you know how I get on.

--=20
Ian Campbell

Arithmetic:
	An obscure art no longer practiced in the world's developed countries.

--=-KuyM1442DnPTbvU7MFge
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxw0rIACgkQM0+0qS9rzVnjnwCg5Y++SrwxhiRRkuPRbJuyGNNC
3nUAoI7+vaym4gJFO8E3d5XVPUPvgRCf
=5S8g
-----END PGP SIGNATURE-----

--=-KuyM1442DnPTbvU7MFge--

