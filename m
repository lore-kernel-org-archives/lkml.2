Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2IDJtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:49:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:37415 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641Ab2IDJtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:49:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,366,1344236400"; 
   d="asc'?scan'208";a="188518787"
Message-ID: <1346752453.12610.39.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/4] drivers/mtd/nand/mpc5121_nfc.c: some devm_ cleanups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2012 12:54:13 +0300
In-Reply-To: <alpine.DEB.2.02.1209041142130.2759@hadrien>
References: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>
	  <1346517191-8794-4-git-send-email-Julia.Lawall@lip6.fr>
	 <1346748171.12610.22.camel@sauron.fi.intel.com>
	 <5045C19A.7000705@metafoo.de> <alpine.DEB.2.02.1209041142130.2759@hadrien>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3Ye0yocplzrUbaRQorON"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3Ye0yocplzrUbaRQorON
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-04 at 11:44 +0200, Julia Lawall wrote:
> > I've been bitten by the same issue recently, also cause by one of these
> > cocci devm patches. devm_clk_get is only available if the generic
> > clk_get/clk_put implementation is used. Not all architectures do this a=
nd
> > some implement their own clk_get/clk_put, etc functions. Since devm_clk=
_get
> > is merely a wrapper around clk_get/clk_put there is no reason why it sh=
ould
> > depend CLKDEV_LOOKUP. I've prepared a patch which makes them genericall=
y
> > available if the clk_get/clk_put are implemented (i.e. if HAVE_CLK is s=
et),
> > but it is on a different machine right now, will try to submit it later=
 today.
>=20
> Sorry about this.  I wasn't aware that devm_clk_get wasn't supported by
> all architectures, and I have no way of compiling code for these
> architectures...  But I wonder why it is not, since devm-ness doesn't see=
m
> to have anything to do with architecture-specific details?  It would be
> really nice to have it for all architectures, because the clock functions
> are just as (or at least almost as) common as kzalloc, ioremap, etc.

It looks like Lars is going to fix this.

I am personally fine if you send patches without build-testing them.
Your patches are generally of good quality and you send many of them, so
build-testing each would be too much for you. And at least for MTD, I
can build-test myself.


--=20
Best Regards,
Artem Bityutskiy

--=-3Ye0yocplzrUbaRQorON
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQRc/FAAoJECmIfjd9wqK0S2UP/18PHE4X8JsTDbjI2C+6EnRl
isPmlGzlXQo8XKauDw23/5bCVfXgYS7mGKEPDzdw5uShuxWa9VrxUNAFLGA2AlFS
4Xt5wZhcKKlhUfQ+t7KxKql+EeB0jkjBK94g1mRWTM7q9e9XwGrDQ6XAxB0DX7pW
ScHM+pBcxIvZ5OSKmJYB9GT34W0XyY8IrEGWY2FT8teCG6bTtnBFHMxNCjovoYIo
G/vqs5YPVRqSrFs4yJWMhnvPQs8lZkxXfhljzgzZAGjR/XP3Una+Ss6uVsjt97FL
LGe/Cuqy9Th6G9CSg492/7zlX1n4CfVq5yYAG4ozfJicM1nbIACjYehdD/NksNEl
pyMpmGq1ML4/BOCxZtTqoZqfvCBPWpoxSbdDSFgiTIETWLpcGK9DqpvFj83oqpZ9
F6dG8Vt4beBaWCRHrg0XGH7ED6eVwOikDMkbN8vKpbPFsR8lBAI5/OqW7FLngoVU
91J2BqxC09+P3JFsYFNPC9EwkGO37XxOHxjgICdXK9hkCD1k8tVSBPzqt245U9iq
GjV/rmt6+TbjAlpO+ly5MNzLknHV8r+dnJ8Ac1WO5VTZL+AVlR9BJn6lnVxW16pq
aqXlPiJAorYaVIsGs+0Ory//7bhevqRz3hahEfv7UdxBAkMj51Yr5+pJSj1kwAui
ybJ/mIG9Gtehvl0hHKLX
=3bM8
-----END PGP SIGNATURE-----

--=-3Ye0yocplzrUbaRQorON--

