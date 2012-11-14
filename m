Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab2KNBUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:20:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59168 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932152Ab2KNBUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:20:16 -0500
Date: Wed, 14 Nov 2012 10:20:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Move chip reset to before register patch
Message-ID: <20121114012007.GD4415@opensource.wolfsonmicro.com>
References: <20121112175648.GA29044@opensource.wolfsonmicro.com>
 <20121113055618.GC18224@opensource.wolfsonmicro.com>
 <20121113131219.GA29198@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
In-Reply-To: <20121113131219.GA29198@opensource.wolfsonmicro.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 01:12:19PM +0000, Charles Keepax wrote:
> On Tue, Nov 13, 2012 at 02:56:20PM +0900, Mark Brown wrote:

> > No, we should never write to the chip until we have successfully
> > identified it.  Do a sync or similar instead (we should be triggering
> > this very soon afterwards via runtime PM anyway).

> In that case I would be inclined to seperate out the chip
> identification and the register patch doing the reset in between.
> Is this something that would sound reasonable or would you rather
> just add a sync after the reset?

Just do a sync, make sure that we mark the map as dirty when we do the
reset via register write and it'll not have any effect anyway.  We
should also check if we've got the LDO and use that for reset too
actually...

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQovAMAAoJELSic+t+oim9ZTcQAICl/qNfjRw0UUFiA6BqkgUA
y17Jt24moAJiejG9RLphvY+xe8VEsuKYYl4GXZw+jgcAm53oh5Zxv/zGtbEiPgnM
H8AfSfjF9x/UNt4IQGRmt9wnuG7qSJkTAStIcVeznchduszlV3klGl4dwWF8rtv9
kpTrfHCDdOgZBAar+wtuZ7Rk0Dn8s2nS/rAkSY9n3d27vB5yrtQMl1CgSx8aEiiV
VHecJS/UW8Z0zDIbkw02/xWlmZMR0brYCO6qw4InODHuy+JcCdHw+tiGrrT4DSZI
FzMTE3PYVLEX7kbbjDxiEDBCvxR4ICDC7EaJ/MOPTutYQtdREoji+/z+nOSmmKAA
QOd5OOKNTIYW6t0rc6bCid+TVykcEWK6ONonPU2gba2woxuqrE0/wbdOkZRjmSS4
ujKnEakiiNIGGio+zgIvr5+XaTQJssEFH6aTYA3StTX/PzT0CJEbhfZ8YB37IX1N
qBue8Ym8iRrk12u0PW562Pikol3y8bh3wkjFOmxicnZ4BGO9uYZtySQhsAAm9K6d
tt5KUf+1nVfgTuqPiuP1ORwhGPTgpC8SF5AnXZd8/iC7blBGrnlkiFATBueXAQtt
sGzB6jHhvvFBSocGYe7TJM3qO31LNpg6/BlS/+BIdOk3O82BgjmVMaMZQuW2SgjQ
NkSVBqmmtx14QUKE0DYC
=MmVM
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
