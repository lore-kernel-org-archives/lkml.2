Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1HLCbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:31:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:55284 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1HLCbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:31:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,360,1309762800"; 
   d="asc'?scan'208";a="37684427"
Subject: Re: linux-next: build failure after merge of the net tree
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Aug 2011 19:31:35 -0700
In-Reply-To: <20110812120248.a23ecc95e9c1111da3a8ef30@canb.auug.org.au>
References: <20110812120248.a23ecc95e9c1111da3a8ef30@canb.auug.org.au>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-L1PAMMkqYFRbGe2Ao24X"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1313116296.2057.30.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L1PAMMkqYFRbGe2Ao24X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-08-11 at 19:02 -0700, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the net tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> Assembler messages:
> Fatal error: can't create drivers/net/ethernet/sun/.tmp_sungem_phy.o: No =
such file or directory
>=20
> Presumably caused by commit e689cf4a0427 ("cassini/niu/sun*: Move the Sun
> drivers") theough I don't know why.  I tried throwing away my object
> directory, but that didn't help.
>=20
> Ah, ha!  This looks suspicious (change to drivers/net/Makefile):
>=20
> +obj-$(CONFIG_SPIDER_NET) +=3D spidernet.o ethernet/sun/sungem_phy.o
>=20
> I have used the net tree from next-20110811 for today.

I am curious, can you compile the Sun GEM support driver?  and if so,
does the Spider Net driver compile?

I know I did not have the PPC hardware to test the compilation of the
Spider Net driver, but I was basing the Makefile changes on similar
changes that the Broadcom driver required, which I did compile test.

I want to resolve this before continuing on with the next set of
patches.



--=-L1PAMMkqYFRbGe2Ao24X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJORJCHAAoJECTsCADr/EWUnpkIAILvMD+I8W516JsOSSCxV2WW
PaST8wJQx0+nqD0TTaOM3n2Gw6hwSbz9wJGXCMv6U+xreJCGv4tr09AvGHOQC/8L
sJRQ+CJ4NUfsZ5y7gCqbBcsJSDr3MKr0o/L3aETNVaRTJph8/W4xFhiYBPVKRLL9
81y0TtcHiQNc/53M7Q4vTqGI1Ju/JDotQBjYMPQZk+fUcfYMiHEvn9oD0rSKK2Fz
E1nQhsIGFbavhNi0eXLnO4FVymQCi6Ggf5r5A8tQGulBR+5/9+I0VthW9nMPYQhz
QpGo2Eg9T8E/sBQNEWgG8UouHQZfqcxnVnqIjHwKDU+e2nxQRGx5OCXkBlLHkdE=
=Ml6H
-----END PGP SIGNATURE-----

--=-L1PAMMkqYFRbGe2Ao24X--

