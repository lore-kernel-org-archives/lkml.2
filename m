Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab1KJXAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 18:00:24 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38618 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1KJXAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 18:00:22 -0500
Date: Fri, 11 Nov 2011 07:00:14 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 3.2
Message-ID: <20111110230014.GA4470@gondor.apana.org.au>
References: <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au> <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au> <20111021082259.GA13530@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021082259.GA13530@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus:

This push fixes a build problem with NET disabled and potential
lock mismatch in the new configuration interface.

Please pull from

git://github.com/herbertx/crypto.git


The top commit object is

commit 3acc84739dd5d746840f881ad4d60bd2a428f1dd
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Nov 3 23:46:07 2011 +1100

    crypto: algapi - Fix build problem with NET disabled
    
    The report functions use NLA_PUT so we need to ensure that NET
    is enabled.
    
    Reported-by: Luis Henriques <henrix@camandro.org>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>


Herbert Xu (1):
      crypto: algapi - Fix build problem with NET disabled

Jonathan Corbet (1):
      crypto: user - Fix rwsem leak in crypto_user

 crypto/ablkcipher.c  |   14 ++++++++++++++
 crypto/aead.c        |   14 ++++++++++++++
 crypto/ahash.c       |    7 +++++++
 crypto/blkcipher.c   |    7 +++++++
 crypto/crypto_user.c |    3 ---
 crypto/pcompress.c   |    7 +++++++
 crypto/rng.c         |    7 +++++++
 crypto/shash.c       |    7 +++++++
 8 files changed, 63 insertions(+), 3 deletions(-)

Thanks,
- -- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUBTrxXWscnHQpJsYunAQKBRw/8DRK2CcLasZYAp4OwOaopmTliXYjaoQTB
hqignMgOqhF23ObQjpBqva7bRc+dxWWOZ3kZV4+F+/tm/3dHH7+PzgGkQOHcjYLC
/puEJ299zcsGmu3dJLO5z24f2QU2h4gpADqUBdZQJZY8iDhEYLX3bZsTRIKAVDmW
RF83ksJe8ejsK+C0O2dyH0aJCfXhhsDF7JFgtZyJhfjjzIrPCM6E6mEjsF59s6zr
nOINeH+8ZT8Bx3IXtmSAN6nBDhB+bNrSoAO3siaL67T2nnjUZ0h6Cg/laiDBs7fi
7E9nvF2dknN8h6Z7RdzBbgTofX20BTBJXeY1Gzx07w4yMUgIznjYL6Me9a307cAY
3dDe465sztWXqieLtcjAp+GpwOGzpp6T4lWKXucC6m4I7oNCSS2FGGobdKIilESC
qIdvVDax+j9YhN6zBJrktA2EBu47QEIzs31Ncmyqv6Saxdbu6fFy2nyhX30RZ3D2
VKly6wWUMOkbIfN3iA8GdBSZpm83R3oy9aIMX+JEP0BUwX1JdcDRMlHsvN+pVrqX
1ZlnXMwiZ7i3vxPbnTPdLfDjBY+4cNt7tJejEqOPBSRpEirzsTXTKSL51af9c9gH
Rmt7qaDQcLkGwaZF/AolbvGgVAj99C+f/K+7UspzYBgatyck35UoJAK864zsL8Xt
trAQYv/cHfU=
=MC9A
-----END PGP SIGNATURE-----
