Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2JDJyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:54:10 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:41469 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756Ab2JDJyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:54:05 -0400
Date: Thu, 4 Oct 2012 17:53:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.7
Message-ID: <20121004095357.GA11777@gondor.apana.org.au>
References: <20100519020603.GA19654@gondor.apana.org.au>
 <20100521104404.GA29530@gondor.apana.org.au>
 <20100804140448.GA4042@gondor.apana.org.au>
 <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106041250.GA7759@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.7:

* Optimised AES/SHA1 for ARM.
* IPsec ESN support in talitos and caam.
* x86_64/avx implementation of cast5/cast6.
* Add/use multi-algorithm registration helpers where possible.
* Added IBM Power7+ in-Nest support.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


David McCullough (1):
      arm/crypto: Add optimized AES and SHA1 routines

Devendra Naga (1):
      crypto: ux500/hash - remove unneeded return at ux500_hash_mod_fini

Fabio Estevam (2):
      hwrng: mxc-rnga - Adapt clocks to new i.mx clock framework
      hwrng: mxc-rnga - Access data via structure

Horia Geanta (7):
      crypto: talitos - fix icv management on outbound direction
      crypto: talitos - prune unneeded descriptor allocation param
      crypto: talitos - change type and name for [src|dst]_is_chained
      crypto: talitos - support for assoc data provided as scatterlist
      crypto: talitos - add IPsec ESN support
      crypto: caam - add IPsec ESN support
      crypto: caam - fix error IDs for SEC v5.x RNG4

Johannes Goetzfried (6):
      crypto: cast5 - prepare generic module for optimized implementations
      crypto: testmgr - add larger cast5 testvectors
      crypto: cast5 - add x86_64/avx assembler implementation
      crypto: cast6 - prepare generic module for optimized implementations
      crypto: testmgr - add larger cast6 testvectors
      crypto: cast6 - add x86_64/avx assembler implementation

Julia Lawall (1):
      drivers/char/hw_random/octeon-rng.c: drop frees of devm allocated data

Jussi Kivilinna (32):
      crypto: tea - use crypto_[un]register_algs
      crypto: crypto_null - use crypto_[un]register_algs
      crypto: des - use crypto_[un]register_algs
      crypto: serpent - use crypto_[un]register_algs
      crypto: ansi_cprng - use crypto_[un]register_algs
      crypto: add crypto_[un]register_shashes for [un]registering multiple shash entries at once
      crypto: tiger - use crypto_[un]register_shashes
      crypto: sha256 - use crypto_[un]register_shashes
      crypto: sha512 - use crypto_[un]register_shashes
      crypto: whirlpool - use crypto_[un]register_shashes
      crypto: cleanup - remove unneeded crypto_alg.cra_list initializations
      crypto: arch/x86 - cleanup - remove unneeded crypto_alg.cra_list initializations
      crypto: drivers - remove cra_list initialization
      crypto: arch/s390 - cleanup - remove unneeded cra_list initialization
      crypto: aesni_intel - improve lrw and xts performance by utilizing parallel AES-NI hardware pipelines
      crypto: twofish-avx - tune assembler code for more performance
      crypto: cast5-avx - tune assembler code for more performance
      crypto: cast6-avx - tune assembler code for more performance
      crypto: crypto_user - fix sparse warnings (symbol was not declared, should be static?)
      crypto: camellia-x86_64 - fix sparse warnings (constant is so big)
      crypto: cast5 - fix sparse warnings (symbol was not declared, should be static?)
      crypto: cast6 - fix sparse warnings (symbol was not declared, should be static?)
      Revert "[CRYPTO] cast6: inline bloat--"
      crypto: 842 - remove .cra_list initialization
      crypto: testmgr - allow non-multi page and multi page skcipher tests from same test template
      crypto: testmgr - add test vectors for partial ctr(cast5) and ctr(cast6)
      crypto: testmgr - add test vectors for CTR mode IV increasement
      crypto: testmgr - make test_skcipher also test 'dst != src' code paths
      crypto: testmgr - make test_aead also test 'dst != src' code paths
      crypto: tcrypt - add missing tests for camellia and ghash
      crypto: cast5/avx - fix storing of new IV in CBC encryption
      crypto: x86/glue_helper - fix storing of new IV in CBC encryption

Kent Yoder (1):
      crypto: Add a MAINTAINERS entry for P7+ in-Nest crypto driver

Kim Phillips (6):
      crypto: caam - fix possible deadlock condition
      crypto: caam - set descriptor sharing type to SERIAL
      crypto: talitos - consolidate cra_type assignments
      crypto: talitos - consolidate common cra_* assignments
      crypto: caam - coccicheck fixes
      crypto: caam - increase TRNG clocks per sample

Michael Ellerman (1):
      crypto: nx - Remove virt_to_abs() usage in nx-842.c

Peter Senna Tschudin (4):
      crypto: ux500 - fix error return code
      crypto: hifn_795x - fix error return code
      crypto: crypto4xx - fix error return code
      crypto: tegra-aes - fix error return code

Sachin Kamat (1):
      crypto: geode-aes - Use module_pci_driver

Seth Jennings (4):
      powerpc/crypto: rework Kconfig
      powerpc/crypto: add compression support to arch vec
      powerpc/crypto: add 842 hardware compression driver
      powerpc/crypto: add 842 crypto driver

Shengzhou Liu (1):
      crypto: caam - add backward compatible string sec4.0

Suresh Siddha (1):
      crypto, tcrypt: remove local_bh_disable/enable() around local_irq_disable/enable()

Tushar Behera (1):
      crypto: atmel - Remove possible typo error

Wei Yongjun (1):
      crypto: remove duplicated include

 MAINTAINERS                                        |   12 +
 arch/arm/Makefile                                  |    1 +
 arch/arm/crypto/Makefile                           |    9 +
 arch/arm/crypto/aes-armv4.S                        | 1112 +++++
 arch/arm/crypto/aes_glue.c                         |  108 +
 arch/arm/crypto/sha1-armv4-large.S                 |  503 ++
 arch/arm/crypto/sha1_glue.c                        |  179 +
 arch/powerpc/configs/ppc64_defconfig               |    3 +-
 arch/powerpc/configs/pseries_defconfig             |    3 +-
 arch/powerpc/kernel/prom_init.c                    |    4 +-
 arch/s390/crypto/aes_s390.c                        |    5 -
 arch/s390/crypto/des_s390.c                        |   10 -
 arch/s390/crypto/ghash_s390.c                      |    1 -
 arch/x86/crypto/Makefile                           |    4 +
 arch/x86/crypto/aes_glue.c                         |    1 -
 arch/x86/crypto/aesni-intel_glue.c                 |  258 +-
 arch/x86/crypto/blowfish_glue.c                    |    4 -
 arch/x86/crypto/camellia_glue.c                    | 1382 +++---
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S          |  376 ++
 arch/x86/crypto/cast5_avx_glue.c                   |  530 ++
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          |  383 ++
 .../{serpent_avx_glue.c => cast6_avx_glue.c}       |  380 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |    2 -
 arch/x86/crypto/glue_helper.c                      |    2 +-
 arch/x86/crypto/salsa20_glue.c                     |    1 -
 arch/x86/crypto/serpent_avx_glue.c                 |   10 -
 arch/x86/crypto/serpent_sse2_glue.c                |   10 -
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |  227 +-
 arch/x86/crypto/twofish_avx_glue.c                 |   10 -
 arch/x86/crypto/twofish_glue.c                     |    1 -
 arch/x86/crypto/twofish_glue_3way.c                |    5 -
 crypto/842.c                                       |  182 +
 crypto/Kconfig                                     |   75 +
 crypto/Makefile                                    |    5 +-
 crypto/aes_generic.c                               |    1 -
 crypto/ansi_cprng.c                                |   63 +-
 crypto/anubis.c                                    |    1 -
 crypto/blowfish_generic.c                          |    1 -
 crypto/camellia_generic.c                          |    1 -
 crypto/{cast5.c => cast5_generic.c}                |   80 +-
 crypto/{cast6.c => cast6_generic.c}                |   73 +-
 crypto/crypto_null.c                               |   57 +-
 crypto/crypto_user.c                               |    2 +-
 crypto/deflate.c                                   |    1 -
 crypto/des_generic.c                               |   25 +-
 crypto/fcrypt.c                                    |    1 -
 crypto/ghash-generic.c                             |    1 -
 crypto/khazad.c                                    |    1 -
 crypto/krng.c                                      |    1 -
 crypto/lzo.c                                       |    1 -
 crypto/salsa20_generic.c                           |    1 -
 crypto/seed.c                                      |    1 -
 crypto/serpent_generic.c                           |   53 +-
 crypto/sha256_generic.c                            |   25 +-
 crypto/sha512_generic.c                            |   20 +-
 crypto/shash.c                                     |   36 +
 crypto/tcrypt.c                                    |   95 +-
 crypto/tcrypt.h                                    |    1 +
 crypto/tea.c                                       |   41 +-
 crypto/testmgr.c                                   |  472 ++-
 crypto/testmgr.h                                   | 5169 ++++++++++++++++----
 crypto/tgr192.c                                    |   38 +-
 crypto/twofish_generic.c                           |    1 -
 crypto/vmac.c                                      |   10 +-
 crypto/wp512.c                                     |   39 +-
 drivers/char/hw_random/mxc-rnga.c                  |  108 +-
 drivers/char/hw_random/octeon-rng.c                |   17 +-
 drivers/crypto/Kconfig                             |   22 +-
 drivers/crypto/amcc/crypto4xx_core.c               |    1 +
 drivers/crypto/atmel-aes.c                         |    7 -
 drivers/crypto/atmel-sha.c                         |    5 -
 drivers/crypto/atmel-tdes.c                        |    6 -
 drivers/crypto/caam/caamalg.c                      |   51 +-
 drivers/crypto/caam/caamhash.c                     |   22 +-
 drivers/crypto/caam/caamrng.c                      |    9 +-
 drivers/crypto/caam/compat.h                       |    1 +
 drivers/crypto/caam/ctrl.c                         |    6 +-
 drivers/crypto/caam/error.c                        |    2 -
 drivers/crypto/caam/jr.c                           |   10 +-
 drivers/crypto/caam/key_gen.c                      |    4 +
 drivers/crypto/geode-aes.c                         |   18 +-
 drivers/crypto/hifn_795x.c                         |    5 +-
 drivers/crypto/nx/Kconfig                          |   26 +
 drivers/crypto/nx/Makefile                         |    5 +-
 drivers/crypto/nx/nx-842.c                         | 1617 ++++++
 drivers/crypto/nx/nx-aes-cbc.c                     |    1 -
 drivers/crypto/nx/nx-aes-ccm.c                     |    2 -
 drivers/crypto/nx/nx-aes-ctr.c                     |    2 -
 drivers/crypto/nx/nx-aes-ecb.c                     |    1 -
 drivers/crypto/nx/nx-aes-gcm.c                     |    2 -
 drivers/crypto/omap-aes.c                          |    1 -
 drivers/crypto/padlock-aes.c                       |    3 -
 drivers/crypto/s5p-sss.c                           |    1 -
 drivers/crypto/talitos.c                           |  442 +-
 drivers/crypto/tegra-aes.c                         |    3 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    1 +
 drivers/crypto/ux500/hash/hash_core.c              |    1 -
 include/crypto/cast5.h                             |   27 +
 include/crypto/cast6.h                             |   28 +
 include/crypto/internal/hash.h                     |    2 +
 include/linux/nx842.h                              |   11 +
 101 files changed, 11832 insertions(+), 2748 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
