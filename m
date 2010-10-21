Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab0JUWYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:24:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37037 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0JUWYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:24:08 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
Date: Thu, 21 Oct 2010 18:23:37 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; ; )
Cc: Luca Barbieri <luca@luca-barbieri.com>, linux-kernel@vger.kernel.org
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org> <20101021150250.f6499506.akpm@linux-foundation.org>
In-Reply-To: <20101021150250.f6499506.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart21465947.xavF07kZvE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201010211823.38287.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart21465947.xavF07kZvE
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday, October 21, 2010 18:02:50 Andrew Morton wrote:
> On Sat, 16 Oct 2010 13:27:15 -0400 Mike Frysinger wrote:
> > If the arch doesn't provide atomic64 functionality (there are quite a
> > few), then don't bother trying to build this test.
>=20
> I don't get it.  If the arch doesn't implement atomic64 then this file
> will get zillions of build errors, won't it?

=2E.. which is why i added the ifdef protection

> > diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
> > index 250ed11..0ac1a66 100644
> > --- a/lib/atomic64_test.c
> > +++ b/lib/atomic64_test.c
> > @@ -12,6 +12,8 @@
> >=20
> >  #include <linux/kernel.h>
> >  #include <asm/atomic.h>
> >=20
> > +#ifdef ATOMIC64_INIT
>=20
> hm, that's a bit lazy.  It should really use a CONFIG_HAVE_ thing.  What
> a pita.

ATOMIC64_INIT is required for atomic64 headers to provide, and having a=20
Kconfig knob doesnt gain anything else
=2Dmike

--nextPart21465947.xavF07kZvE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJMwL1qAAoJEEFjO5/oN/WBMKIP/RbfPkKSME287+ugQ7x6ROfW
7tt3EUOIRe62b4zPpOU58fZu6ywlHK4sBqn9cbwKkFfTlImtixtW8lO1VQEyJMdz
m8TPFSQojGzdGO2mIKiZqlOJSGjb/N+dvUhU89zGc6DNpT6FgFJJuTi6D8ocf32F
DwPPxDaJQN46PthRC4IQ1TebevpYE6Bzvvk9UoW8gsffkeIYM0RMe9Eu1mtasdYN
wzKsgp9iKqiUM5tDuzJ+Rw9D54rhKp6hQjLBW8aMXbjFuG6H/Ly7FYdoWlMWONSv
/xwEmGS5D767clD38dbD2/KzFUyykL66Nwv6iGaEKMwWnIhqzW3523nj2nsgogzy
rY7cY5vm5kFW6SIYGCZbPvHLCXtmJ+zDzThncyjKyAWCos9dhGHQs2UjZjc9CviX
Vn8cGa5CN7cWqqqjPPrAZPAVC9k8Dj5m4u/ILKp/RUskXYFaZpDoB5nv2IvsoEDq
SDodYF3oYNanHhQd0HmWnWfhQA4hI/6J/NRl09nZhEakgvc976pCdQMqXSg2adyY
/4yusG62g2I6N1wcQqwACJ2ibSAeuOFxnSlZRPJKVOUOnWhZUoXpUkmGcJOtz+8R
Q6v0mJ8zNS5jjle4sK6ksG7LMbpzn9WywSN4B4QZO5N0kmURcbbbSKgZ2907q21E
Spmu2xI4IR2nCW0Vb1wj
=Vl6Q
-----END PGP SIGNATURE-----

--nextPart21465947.xavF07kZvE--
