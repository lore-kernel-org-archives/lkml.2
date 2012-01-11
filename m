Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab2AKWTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:19:33 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38021 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab2AKWTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:19:30 -0500
Date: Thu, 12 Jan 2012 09:19:21 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 3.3
Message-ID: <20120111221921.GA22514@gondor.apana.org.au>
References: <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <20110315145940.GA15373@gondor.apana.org.au> <20110520235409.GA1722@gondor.apana.org.au> <20110724011752.GA14373@gondor.apana.org.au> <20111031040952.GA19659@gondor.apana.org.au> <20120106041250.GA7759@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106041250.GA7759@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This is a resend of the crypto update for 3.3:

* New test vectors (serpent, xts-twofish).
* Speed test for asynchronous ciphers.
* SSE2 assembly implementation of serpent.
* Support for LRW and XTS in X86-64 assembly implementation of twofish.
* More MD5 combos for caam.
* Channel remap on talitos for better affinity.
* Direct support for HMAC on talitos.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Axel Lin (2):
      char: hw_random: convert drivers/char/hw_random/* to use module_platform_driver()
      crypto: convert drivers/crypto/* to use module_platform_driver()

Jamie Iles (1):
      crypto: picoxcell - fix boolean and / or confusion

Jarod Wilson (1):
      crypto: ansi_cprng - enforce key != seed in fips mode

Jussi Kivilinna (36):
      crypto: testmgr - add new serpent test vectors
      crypto: tcrypt - add test_acipher_speed
      crypto: tcrypt - add serpent speed tests
      crypto: serpent - export common functions for x86_64/i386-sse2 assembler implementations
      crypto: serpent - rename module from serpent to serpent_generic
      crypto: lrw - fix memleak
      crypto: lrw - use blocksize constant
      crypto: lrw - split gf128mul table initialization from setkey
      crypto: lrw - add interface for parallelized cipher implementions
      crypto: testmgr - add lrw(serpent) test vectors
      crypto: tcrypt - add lrw(serpent) tests
      crypto: testmgr - add lrw(twofish) test vectors
      crypto: tcrypt - add lrw(twofish) tests
      crypto: twofish-x86_64-3way - add lrw support
      crypto: xts - use blocksize constant
      crypto: xts: add interface for parallelized cipher implementations
      crypto: testmgr - add xts(serpent) test vectors
      crypto: tcrypt - add xts(serpent) tests
      crypto: testmgr - add xts(twofish) test vectors
      crypto: tcrypt - add xts(twofish) tests
      crypto: twofish-x86_64-3way - add xts support
      crypto: serpent - add 8-way parallel x86_64/SSE2 assembler implementation
      crypto: serpent - add 4-way parallel i586/SSE2 assembler implementation
      crypto: serpent-sse2 - add lrw support
      crypto: serpent-sse2 - add xts support
      crypto: serpent-sse2 - clear CRYPTO_TFM_REQ_MAY_SLEEP in lrw and xts modes
      crypto: serpent - cleanup checkpatch errors and warnings
      crypto: serpent - rename serpent.c to serpent_generic.c
      crypto: serpent-sse2 - should select CRYPTO_CRYPTD
      crypto: lrw - remove dependency on EXPERIMENTAL
      crypto: xts - remove dependency on EXPERIMENTAL
      crypto: twofish-x86_64-3way - select LRW and XTS
      crypto: twofish-x86_64-3way - remove unneeded LRW/XTS #ifdefs
      crypto: serpent-sse2 - select LRW and XTS
      crypto: serpent-sse2 - remove unneeded LRW/XTS #ifdefs
      crypto: gf128mul - remove leftover "(EXPERIMENTAL)" in Kconfig

Kim Phillips (11):
      crypto: talitos - be less noisy on startup
      crypto: talitos - prepare driver for channel remap support
      crypto: talitos - support for channel remap and 2nd IRQ
      crypto: caam - add support for MD5 algorithm variants
      crypto: talitos - fix bad kfree
      crypto: talitos - remove NO_IRQ references
      crypto: talitos - convert talitos_error to struct device
      crypto: caam - desc.h - convert spaces to tabs
      crypto: caam - more desc.h cleanups
      crypto: caam - fix polarity of "propagate error" logic
      crypto: caam - remove DECO access initialization code

Lee Nipper (1):
      crypto: talitos - add hmac algorithms

Steffen Klassert (1):
      crypto: Unlink and free instances when deleted

Valdis.Kletnieks@vt.edu (1):
      crypto: fix typo in crypto/Kconfig

 arch/x86/crypto/Makefile                     |    4 +
 arch/x86/crypto/serpent-sse2-i586-asm_32.S   |  638 ++++++
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S |  761 +++++++
 arch/x86/crypto/serpent_sse2_glue.c          | 1070 ++++++++++
 arch/x86/crypto/twofish_glue_3way.c          |  218 ++
 arch/x86/include/asm/serpent.h               |   63 +
 crypto/Kconfig                               |   52 +-
 crypto/Makefile                              |    2 +-
 crypto/algapi.c                              |   29 +
 crypto/ansi_cprng.c                          |    8 +
 crypto/crypto_user.c                         |    2 +-
 crypto/lrw.c                                 |  156 ++-
 crypto/serpent.c                             |  587 ------
 crypto/serpent_generic.c                     |  684 +++++++
 crypto/tcrypt.c                              |  310 +++
 crypto/tcrypt.h                              |    2 +
 crypto/testmgr.c                             |  150 ++
 crypto/testmgr.h                             | 2759 +++++++++++++++++++++++++-
 crypto/twofish_common.c                      |   13 +-
 crypto/xts.c                                 |   79 +-
 drivers/char/hw_random/atmel-rng.c           |   12 +-
 drivers/char/hw_random/n2-drv.c              |   13 +-
 drivers/char/hw_random/octeon-rng.c          |   13 +-
 drivers/char/hw_random/pasemi-rng.c          |   12 +-
 drivers/char/hw_random/picoxcell-rng.c       |   12 +-
 drivers/char/hw_random/ppc4xx-rng.c          |   12 +-
 drivers/char/hw_random/timeriomem-rng.c      |   13 +-
 drivers/crypto/amcc/crypto4xx_core.c         |   13 +-
 drivers/crypto/caam/caamalg.c                |   67 +-
 drivers/crypto/caam/compat.h                 |    1 +
 drivers/crypto/caam/ctrl.c                   |   26 +-
 drivers/crypto/caam/desc.h                   | 2265 +++++++++++-----------
 drivers/crypto/caam/desc_constr.h            |    7 +-
 drivers/crypto/caam/regs.h                   |    1 -
 drivers/crypto/mv_cesa.c                     |   12 +-
 drivers/crypto/picoxcell_crypto.c            |   16 +-
 drivers/crypto/s5p-sss.c                     |   13 +-
 drivers/crypto/talitos.c                     |  493 ++++-
 drivers/crypto/talitos.h                     |   45 +-
 include/crypto/algapi.h                      |    1 +
 include/crypto/lrw.h                         |   43 +
 include/crypto/serpent.h                     |   27 +
 include/crypto/twofish.h                     |    2 +
 include/crypto/xts.h                         |   27 +
 44 files changed, 8684 insertions(+), 2049 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
