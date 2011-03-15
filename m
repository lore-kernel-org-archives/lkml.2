Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab1COO7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:59:51 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:45886 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab1COO7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:59:50 -0400
Date: Tue, 15 Mar 2011 22:59:40 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 2.6.39
Message-ID: <20110315145940.GA15373@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106000157.GA16089@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 2.6.39:

* New picoxcell crypto driver.
* New picoxcell RNG driver.
* Added SHA test vectors to detect bugs such as the recent one on s390.
* Memory leaks fixes on error path in aesni-intel.
* xts(aes) and ghash are now available in FIPS mode.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


David Sterba (1):
      crypto: tcrypt - do not attempt to write to readonly variable

Davidlohr Bueso (1):
      crypto: skcipher - remove redundant NULL check

Herbert Xu (1):
      crypto: sha1 - Add test vector to test partial block processing

Jamie Iles (4):
      hwrng: pixocell - add support for picoxcell TRNG
      crypto: omap-aes - don't treat NULL clk as an error
      crypto: omap-sham - don't treat NULL clk as an error
      crypto: picoxcell - add support for the picoxcell crypto engines

Jarod Wilson (3):
      crypto: testmgr - mark xts(aes) as fips_allowed
      crypto: testmgr - mark ghash as fips_allowed
      random: update interface comments to reflect reality

Jesper Juhl (2):
      crypto: aesni-intel - Don't leak memory in rfc4106_set_hash_subkey
      crypto: aesni-intel - Fix remaining leak in rfc4106_set_hash_key

Julia Lawall (1):
      hwrng: omap - Convert release_resource to release_region/release_mem_region

 arch/x86/crypto/aesni-intel_glue.c     |   24 +-
 crypto/ablkcipher.c                    |    3 +-
 crypto/tcrypt.c                        |    3 +-
 crypto/testmgr.c                       |    2 +
 crypto/testmgr.h                       |   30 +-
 drivers/char/hw_random/Kconfig         |   12 +
 drivers/char/hw_random/Makefile        |    1 +
 drivers/char/hw_random/omap-rng.c      |   14 +-
 drivers/char/hw_random/picoxcell-rng.c |  208 ++++
 drivers/char/random.c                  |   13 +-
 drivers/crypto/Kconfig                 |   17 +
 drivers/crypto/Makefile                |    2 +-
 drivers/crypto/omap-aes.c              |    4 +-
 drivers/crypto/omap-sham.c             |    4 +-
 drivers/crypto/picoxcell_crypto.c      | 1867 ++++++++++++++++++++++++++++++++
 drivers/crypto/picoxcell_crypto_regs.h |  128 +++
 16 files changed, 2299 insertions(+), 33 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
