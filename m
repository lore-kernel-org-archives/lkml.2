Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2CTD1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:27:49 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:38669 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757998Ab2CTD1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:27:44 -0400
Date: Tue, 20 Mar 2012 14:27:36 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 3.3
Message-ID: <20120320032736.GA21367@gondor.apana.org.au>
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

Here is the crypto update for 3.4:

* sha512 bug fixes (already in your tree).
* SHA224/SHA384 AEAD support in caam.
* X86-64 optimised version of Camellia.
* Tegra AES support.
* Bulk algorithm registration interface to make driver registration easier.
* padata race fixes.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alexey Dobriyan (4):
      crypto: sha512 - make it work, undo percpu message schedule
      crypto: sha512 - reduce stack usage to safe number
      crypto: sha512 - use standard ror64()
      crypto: sha512 - use standard ror64()

Hemant Agrawal (1):
      crypto: caam - add sha224 and sha384 variants to existing AEAD algorithms

Henning Heinold (1):
      arm: tegra: export tegra_chip_uid

Herbert Xu (3):
      crypto: sha512 - Use binary and instead of modulus
      crypto: sha512 - Avoid stack bloat on i386
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

Jesper Juhl (3):
      crypto: In crypto_add_alg(), 'exact' wants to be initialized to 0
      crypto: twofish-x86 - Remove dead code from twofish_glue_3way.c::init()
      crypto: serpent-sse2 - remove dead code from serpent_sse2_glue.c::serpent_sse2_init()

Julia Lawall (2):
      hwrng: tx4939 - use devm_request_and_ioremap
      crypto: ixp4xx - convert GFP_KERNEL to GFP_ATOMIC

Jussi Kivilinna (16):
      crypto: twofish-x86_64-3way - blacklist pentium4 and atom
      crypto: blowfish-x86_64 - blacklist Pentium 4
      crypto: serpent-sse2 - change transpose_4x4 to only use integer instructions
      crypto: serpent-sse2 - use crypto_[un]register_algs
      crypto: twofish-x86_64-3way - use crypto_[un]register_algs
      crypto: blowfish-x86_64 - use crypto_[un]register_algs
      crypto: serpent-sse2 - combine ablk_*_init functions
      crypto: blowfish-x86_64 - set alignmask to zero
      crypto: twofish-x86_64/i586 - set alignmask to zero
      crypto: camellia - simplify key setup and CAMELLIA_ROUNDSM macro
      crypto: testmgr - add more camellia test vectors
      crypto: tcrypt - add more camellia tests
      crypto: camellia - rename camellia module to camellia_generic
      crypto: camellia - fix checkpatch warnings
      crypto: camellia - rename camellia.c to camellia_generic.c
      crypto: camellia - add assembler implementation for x86_64

Kim Phillips (2):
      crypto: caam - be less noisy on startup
      crypto: caam - fix gcc 4.6 warning

Mark Brown (1):
      crypto: Add bulk algorithm registration interface

Nikos Mavrogiannopoulos (1):
      crypto: Add CRYPTO_ALG_KERN_DRIVER_ONLY flag

Steffen Klassert (2):
      padata: Fix race in the serialization path
      padata: Fix race on sequence number wrap

Varun Wadekar (1):
      crypto: driver for Tegra AES hardware

 arch/arm/mach-tegra/fuse.c                   |    2 +
 arch/x86/crypto/Makefile                     |    2 +
 arch/x86/crypto/blowfish_glue.c              |  191 ++--
 arch/x86/crypto/camellia-x86_64-asm_64.S     |  520 +++++++
 arch/x86/crypto/camellia_glue.c              | 1952 ++++++++++++++++++++++++++
 arch/x86/crypto/serpent-sse2-i586-asm_32.S   |   29 +-
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S |   29 +-
 arch/x86/crypto/serpent_sse2_glue.c          |  394 ++----
 arch/x86/crypto/twofish_glue.c               |    2 +-
 arch/x86/crypto/twofish_glue_3way.c          |  265 ++--
 crypto/Kconfig                               |   18 +
 crypto/Makefile                              |    2 +-
 crypto/algapi.c                              |   35 +
 crypto/camellia.c                            | 1116 ---------------
 crypto/camellia_generic.c                    | 1102 +++++++++++++++
 crypto/crypto_user.c                         |    2 +-
 crypto/sha512_generic.c                      |   59 +-
 crypto/tcrypt.c                              |   12 +
 crypto/testmgr.c                             |   45 +
 crypto/testmgr.h                             | 1383 ++++++++++++++++++-
 drivers/char/hw_random/tx4939-rng.c          |    5 +-
 drivers/crypto/Kconfig                       |   11 +
 drivers/crypto/Makefile                      |    1 +
 drivers/crypto/caam/caamalg.c                |  126 ++-
 drivers/crypto/caam/ctrl.c                   |    2 +-
 drivers/crypto/geode-aes.c                   |    6 +-
 drivers/crypto/hifn_795x.c                   |    3 +-
 drivers/crypto/ixp4xx_crypto.c               |    4 +-
 drivers/crypto/mv_cesa.c                     |   12 +-
 drivers/crypto/n2_core.c                     |    7 +-
 drivers/crypto/omap-aes.c                    |    8 +-
 drivers/crypto/omap-sham.c                   |    4 +
 drivers/crypto/picoxcell_crypto.c            |   46 +-
 drivers/crypto/s5p-sss.c                     |    6 +-
 drivers/crypto/talitos.c                     |    1 +
 drivers/crypto/tegra-aes.c                   | 1096 +++++++++++++++
 drivers/crypto/tegra-aes.h                   |  103 ++
 include/linux/bitops.h                       |   20 +
 include/linux/crypto.h                       |    7 +
 include/linux/padata.h                       |    6 +-
 kernel/padata.c                              |   44 +-
 41 files changed, 6936 insertions(+), 1742 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
