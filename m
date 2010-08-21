Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0HUL4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 07:56:24 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:18116 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab0HUL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 07:56:21 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-M8p+Gm/Ou+HNe5PdgtDa"
Date: Sat, 21 Aug 2010 12:56:10 +0100
Message-ID: <1282391770.29609.1223.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC] mlock/stack guard interaction fixup
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=4QByPj+6Iq2k/6L54d+eVKTdgQxdscpRskJJReCfdXo= c=1 sm=0 a=zI1UDiXOKOEA:10 a=AZfGcq7nAAAA:8 a=jOPR8DCp-ZTAJbmD1Q0A:9 a=GAZ69orE2gvzJ9CLAAvjXLuhzgEA:4 a=wPNLvfGTeEIA:10 a=wfMQlUjaoQZAAJbRpUoA:9 a=b7qTra_XdJGBwjz9uQSDbBob4MEA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M8p+Gm/Ou+HNe5PdgtDa
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-08-20 at 16:59 -0700, Linus Torvalds wrote:
> Ian (and others),
>  here's a three-patch series that uses the doubly linked list to do
> your mlock() case hopefully correctly.

Thanks Linus.

> NOTE! It's untested. The first patch (which is the slightly scary one)
> is tested to some degree, the two other ones I checked that they
> compile, but that's it.

I applied on top of 2.6.35.3 and it fixes the simple test case I posted
yesterday as well as the original issue I was seeing with the Xen
toolstack on 2.6.32.20.

I don't know that they are particularly good tests for this change but I
also ran allmodconfig kernel build and ltp on 2.6.35.3+fixes without
issue. Are there any good mlock heavy workloads?

Out of interest, why is there no guard page for the VM_GROWSUP stack
case? Is it just that the memory layout on PA-RISC makes the stack grows
into the heap scenario impossible?

> I'm not going to apply them to my main tree unless they get testing
> and acks.

Tested-by: Ian Campbell <ijc@hellion.org.uk>

>  And as mentioned, I've not done any of the changes that
> having a vm_prev pointer can allow in other places.
>=20
> Comments? Fixes? Braindamage?
>=20
>                                Linus

--=20
Ian Campbell

Providence, New Jersey, is one of the few cities where Velveeta cheese
appears on the gourmet shelf.

--=-M8p+Gm/Ou+HNe5PdgtDa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxvvtoACgkQM0+0qS9rzVkhxgCgqCVn/8Vzk36woRuKpd9oeky0
7qwAoN2Fw4SxD21NlskSlF5rNZdlYnJs
=SyLg
-----END PGP SIGNATURE-----

--=-M8p+Gm/Ou+HNe5PdgtDa--

