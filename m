Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1AFACH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:02:07 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:40611 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1AFACF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:02:05 -0500
Date: Thu, 6 Jan 2011 11:01:57 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 2.6.38
Message-ID: <20110106000157.GA16089@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101024061625.GA23715@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 2.6.38:

* Crypto API interface for user-space (hash + skcipher)
* Fixes for new OMAP driver.
* 32-bit support in aesni-intel.
* GCM support in aesni-intel.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Adrian Hoban (1):
      crypto: rfc4106 - Extending the RC4106 AES-GCM test vectors

Adrian-Ken Rueegsegger (1):
      crypto: ripemd - Set module author and update email address

Dmitry Kasatkin (15):
      crypto: omap-sham - uses digest buffer in request context
      crypto: omap-sham - DMA initialization fixes for off mode
      crypto: omap-sham - error handling improved
      crypto: omap-sham - removed redundunt locking
      crypto: omap-sham - crypto_ahash_final() now not need to be called.
      crypto: omap-sham - hash-in-progress is stored in hw format
      crypto: omap-sham - FLAGS_FIRST is redundant and removed
      crypto: omap-sham - zero-copy scatterlist handling
      crypto: omap-aes - DMA initialization fixes for OMAP off mode
      crypto: omap-aes - redundant locking is removed
      crypto: omap-aes - error handling implementation improved
      crypto: omap-aes - unnecessary code removed
      crypto: omap-aes - initialize aes module once per request
      crypto: omap-aes - checkpatch --file warning fixes
      crypto: omap-sham - backlog handling fix

Herbert Xu (10):
      crypto: hash - Fix async import on shash algorithm
      net - Add AF_ALG macros
      crypto: af_alg - User-space interface for Crypto API
      crypto: algif_hash - User-space interface for hash operations
      crypto: algif_skcipher - User-space interface for skcipher operations
      crypto: algif_skcipher - Pass on error from af_alg_make_sg
      crypto: af_alg - Add dependency on NET
      crypto: algif_skcipher - Fixed overflow when sndbuf is page aligned
      crypto: algif_skcipher - Handle unaligned receive buffer
      crypto: gf128mul - Remove experimental tag

Joe Perches (1):
      crypto: Use vzalloc

Mathias Krause (2):
      crypto: aesni-intel - Ported implementation to x86-32
      crypto: aesni-intel - Fixed build error on x86-32

Miloslav Trmač (3):
      include: Install linux/if_alg.h for user-space crypto API
      net: Add missing lockdep class names for af_alg
      crypto: af_alg - Make sure sk_security is initialized on accept()ed sockets

Nicolas Kaiser (1):
      crypto: cast5 - simplify if-statements

Randy Dunlap (1):
      crypto: af_alg - fix af_alg memory_allocated data type

Roel Kluin (1):
      crypto: mv_cesa - dont return PTR_ERR() of wrong pointer

Steffen Klassert (2):
      crypto: scatterwalk - Add scatterwalk_crypto_chain helper
      crypto: Use scatterwalk_crypto_chain

Tadeusz Struk (2):
      crypto: aesni-intel - RFC4106 AES-GCM Driver Using Intel New Instructions
      crypto: aesni-intel - Fixed build with binutils 2.16

Tejun Heo (1):
      crypto: mark crypto workqueues CPU_INTENSIVE

Tracey Dent (1):
      crypto: Makefile clean up

 arch/x86/crypto/aesni-intel_asm.S  | 1832 +++++++++++++++++++++++++++++++++++-
 arch/x86/crypto/aesni-intel_glue.c |  540 +++++++++++-
 crypto/Kconfig                     |   34 +-
 crypto/Makefile                    |   17 +-
 crypto/af_alg.c                    |  483 ++++++++++
 crypto/algif_hash.c                |  319 +++++++
 crypto/algif_skcipher.c            |  632 +++++++++++++
 crypto/authenc.c                   |   22 +-
 crypto/cast5.c                     |   74 +-
 crypto/crypto_wq.c                 |    3 +-
 crypto/deflate.c                   |    3 +-
 crypto/eseqiv.c                    |   18 +-
 crypto/gcm.c                       |   19 +-
 crypto/pcrypt.c                    |    3 +-
 crypto/rmd128.c                    |    3 +-
 crypto/rmd160.c                    |    3 +-
 crypto/rmd256.c                    |    3 +-
 crypto/rmd320.c                    |    3 +-
 crypto/shash.c                     |    8 +-
 crypto/tcrypt.c                    |   11 +
 crypto/testmgr.c                   |   24 +
 crypto/testmgr.h                   |  361 +++++++
 crypto/zlib.c                      |    3 +-
 drivers/crypto/mv_cesa.c           |    2 +-
 drivers/crypto/omap-aes.c          |  260 +++---
 drivers/crypto/omap-sham.c         |  374 +++++----
 include/crypto/if_alg.h            |   92 ++
 include/crypto/scatterwalk.h       |   15 +
 include/linux/Kbuild               |    1 +
 include/linux/if_alg.h             |   40 +
 include/linux/socket.h             |    5 +-
 net/core/sock.c                    |    6 +-
 32 files changed, 4763 insertions(+), 450 deletions(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
