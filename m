Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1GXBSF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 21:18:05 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:36062 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1GXBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 21:18:00 -0400
Date: Sun, 24 Jul 2011 09:17:52 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.1
Message-ID: <20110724011752.GA14373@gondor.apana.org.au>
References: <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <20110315145940.GA15373@gondor.apana.org.au> <20110520235409.GA1722@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520235409.GA1722@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.1:

* Support for AES/DES/3DES in caam.
* Improved AEAD support in caam.
* Added hardware SHA-224 support to s390.
* Added ppc4xx RNG driver.
* Updates to omap-sham driver.
* Updates to talitos driver.
* Added XTS-AES-256 test vectors.
* Misc fixes.
 

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Dmitry Kasatkin (11):
      crypto: omap-sham - remove extra reference
      crypto: omap-sham - remove unused code
      crypto: omap-sham - replace flags bit mask with bit number
      crypto: omap-sham - replace flags operation with atomic bit operations
      crypto: omap-sham - move some flags to device context
      crypto: omap-sham - remove unnecessary local variable
      crypto: omap-sham - remove dedicated queue handling tasklet
      crypto: omap-sham - irq and dma handling changes
      crypto: omap-sham - irq handler must not clear error code
      crypto: omap-sham - clear device flags when finishing request
      crypto: omap-sham - do not schedule tasklet if there is no active requests

Gustavo F. Padovan (1):
      crypto: ghash-intel - Fix set but not used in ghash_async_setkey()

H Hartley Sweeten (1):
      hwrng: timeriomem - use resource_size

Herbert Xu (1):
      crypto: algif_hash - Handle initial af_alg_make_sg error correctly

Jan Glauber (1):
      crypto: s390 - support hardware accelerated SHA-224

Jarod Wilson (1):
      crypto: testmgr - add xts-aes-256 self-test

Josh Boyer (2):
      crypto: crypto4xx - Perform read/modify/write on device control register
      hwrng: ppc4xx - add support for ppc4xx TRNG

Julia Lawall (2):
      hwrng: omap - add missing clk_put
      hwrng: nomadik - add missing clk_put

Kim Phillips (5):
      crypto: caam - fix build warning when DEBUG_FS not configured
      crypto: talitos - ensure request ordering within a single tfm
      crypto: talitos - don't set done notification in hot path
      crypto: talitos - remove unused giv from ablkcipher methods
      crypto: talitos - don't bad_key in ablkcipher setkey

Mandeep Singh Baines (1):
      crypto: sha1_generic - use SHA1_BLOCK_SIZE

Mathias Krause (1):
      crypto: gf128mul - fix call to memset()

Mati Vait (2):
      crypto: crc32c - Fixed coding style issue
      crypto: arc4 - Fixed coding style issues

Richard Weinberger (1):
      crypto: UML build fixes

Yuan Kang (4):
      crypto: caam - shorter names
      crypto: caam - structure renaming
      crypto: caam - faster aead implementation
      crypto: caam - ablkcipher support

 arch/s390/crypto/sha256_s390.c             |   66 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c |    2 +-
 crypto/Kconfig                             |    4 +-
 crypto/algif_hash.c                        |    4 +-
 crypto/arc4.c                              |   15 +-
 crypto/crc32c.c                            |   10 +-
 crypto/gf128mul.c                          |    4 +-
 crypto/sha1_generic.c                      |   11 +-
 crypto/testmgr.h                           |  293 +++++-
 drivers/char/hw_random/Kconfig             |   12 +
 drivers/char/hw_random/Makefile            |    1 +
 drivers/char/hw_random/nomadik-rng.c       |    3 +-
 drivers/char/hw_random/omap-rng.c          |    6 +-
 drivers/char/hw_random/ppc4xx-rng.c        |  156 +++
 drivers/char/hw_random/timeriomem-rng.c    |    3 +-
 drivers/crypto/amcc/crypto4xx_core.c       |    5 +-
 drivers/crypto/caam/caamalg.c              | 1848 +++++++++++++++++++++-------
 drivers/crypto/caam/compat.h               |    1 +
 drivers/crypto/caam/ctrl.c                 |    4 +-
 drivers/crypto/caam/desc_constr.h          |   58 +-
 drivers/crypto/omap-sham.c                 |  180 ++--
 drivers/crypto/talitos.c                   |   47 +-
 22 files changed, 2136 insertions(+), 597 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
