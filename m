Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab2GYIlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:41:55 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:49718 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932767Ab2GYIlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:41:51 -0400
Date: Wed, 25 Jul 2012 16:41:43 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.6
Message-ID: <20120725084143.GA5192@gondor.apana.org.au>
References: <20100804140448.GA4042@gondor.apana.org.au>
 <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20120320032736.GA21367@gondor.apana.org.au>
 <20120523013528.GA20781@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120523013528.GA20781@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.6:

* Fixed algorithm construction hang when self-test fails.
* Added SHA variants to talitos AEAD list.
* New driver for Exynos random number generator.
* Performance enhancements for arc4.
* Added hwrng support to caam.
* Added ahash support to caam.
* Fixed bad kfree in aesni-intel.
* Allow aesni-intel in FIPS mode.
* Added atmel driver with support for AES/3DES/SHA.
* Bug fixes for mv_cesa.
* CRC hardware driver for BF60x family processors.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alex Porosanu (1):
      crypto: caam - ERA retrieval and printing for SEC device

Benoît Thébaudeau (1):
      hwrng: mxc-rnga - fix data_present API

Bharat Bhushan (1):
      crypto: caam - Using alloc_coherent for caam job rings

Hemant Agrawal (1):
      crypto: caam - add PDB (Protocol Descriptor Block) definitions

Herbert Xu (1):
      crypto: algapi - Move larval completion into algboss

Horia Geanta (4):
      crypto: talitos - move talitos structures to header file
      crypto: talitos - export the talitos_submit function
      crypto: talitos - add sha224, sha384 and sha512 to existing AEAD algorithms
      crypto: testmgr - add aead cbc aes hmac sha1,256,512 test vectors

Johannes Goetzfried (4):
      crypto: twofish - add x86_64/avx assembler implementation
      crypto: testmgr - expand twofish test vectors
      crypto: serpent - add x86_64/avx assembler implementation
      crypto: twofish-avx - remove useless instruction

Jonghwa Lee (1):
      hwrng: exynos - Add support for Exynos random number generator

Jussi Kivilinna (15):
      crypto: testmgr - add ecb(arc4) speed tests
      crypto: arc4 - improve performance by adding ecb(arc4)
      crypto: arc4 - improve performance by using u32 for ctx and variables
      crypto: serpent-sse2/avx - allow both to be built into kernel
      crypto: ablk_helper - move ablk_* functions from serpent-sse2/avx glue code to shared module
      crypto: twofish-avx - change to use shared ablk_* functions
      crypto: aes_ni - change to use shared ablk_* functions
      crypto: serpent-sse2 - prepare serpent-sse2 glue code into generic x86 glue code for 128bit block ciphers
      crypto: serpent-sse2 - split generic glue code to new helper module
      crypto: serpent-avx: remove duplicated glue code and use shared glue code from glue_helper
      crypto: camellia-x86_64 - remove duplicated glue code and use shared glue code from glue_helper
      crypto: twofish-x86_64-3way - remove duplicated glue code and use shared glue code from glue_helper
      crypto: twofish-avx - remove duplicated glue code and use shared glue code from glue_helper
      crypto: move arch/x86/include/asm/serpent-{sse2|avx}.h to arch/x86/include/asm/crypto/
      crypto: move arch/x86/include/asm/aes.h to arch/x86/include/asm/crypto/

Kim Phillips (10):
      crypto: caam - remove line continuations from ablkcipher_append_src_dst
      crypto: caam - fix input job ring element dma mapping size
      crypto: caam - fix descriptor length adjustments for protocol descriptors
      crypto: caam - assign 40-bit masks on SEC v5.0 and above
      crypto: caam - add support for SEC v5.x RNG4
      crypto: caam - disable IRQ coalescing by default
      crypto: caam - use non-irq versions of spinlocks for job rings
      crypto: caam - only query h/w in job ring dequeue path
      crypto: caam - consolidate memory barriers from job ring en/dequeue
      crypto: caam - one tasklet per job ring

Mathias Krause (1):
      crypto: sha1 - use Kbuild supplied flags for AVX test

Milan Broz (2):
      crypto: aesni-intel - fix wrong kfree pointer
      crypto: testmgr - allow aesni-intel and ghash_clmulni-intel in fips mode

Nicolas Royer (5):
      ARM: AT91SAM9G45: add crypto peripherals
      crypto: atmel - add Atmel AES driver
      crypto: atmel - add Atmel DES/TDES driver
      crypto: atmel - add Atmel SHA1/SHA256 driver
      crypto: atmel - add new tests to tcrypt

Paul Bolle (1):
      crypto: s390 - clean up DES code a bit more

Phil Sutter (3):
      crypto: mv_cesa - add an expiry timer in case anything goes wrong
      crypto: mv_cesa - initialise the interrupt status field to zero
      crypto: mv_cesa - fix for hash finalisation with data

Sebastian Andrzej Siewior (1):
      crypto: arc4 - now arc needs blockcipher support

Seth Jennings (2):
      crypto: nx - move nx build to driver/crypto Makefile
      crypto: nx - fix typo in nx driver config option

Sonic Zhang (2):
      crypto: testmgr - Add new test cases for Blackfin CRC crypto driver
      crypto: bfin_crc - CRC hardware driver for BF60x family processors.

Steffen Klassert (1):
      crypto: algapi - Fix hang on crypto allocation

Yashpal Dutta (1):
      crypto: caam - fix start index for Protocol shared descriptors

Yuan Kang (8):
      crypto: caam - support external seq in/out lengths
      crypto: caam - remove jr register/deregister
      crypto: caam - refactor key_gen, sg
      crypto: caam - link_tbl rename
      crypto: caam - ahash hmac support
      crypto: caam - unkeyed ahash support
      crypto: caam - chaining support
      crypto: caam - hwrng support

 arch/arm/mach-at91/at91sam9g45.c                   |   13 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |  128 ++
 arch/arm/mach-at91/include/mach/at91sam9g45.h      |    2 +
 arch/powerpc/Makefile                              |    1 -
 arch/s390/crypto/crypto_des.h                      |   18 -
 arch/x86/crypto/Makefile                           |   14 +-
 arch/x86/crypto/ablk_helper.c                      |  149 ++
 arch/x86/crypto/aes_glue.c                         |    2 +-
 arch/x86/crypto/aesni-intel_glue.c                 |  110 +-
 arch/x86/crypto/camellia_glue.c                    |  355 +---
 arch/x86/crypto/glue_helper.c                      |  307 ++++
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        |  704 ++++++++
 .../{serpent_sse2_glue.c => serpent_avx_glue.c}    |  592 ++-----
 arch/x86/crypto/serpent_sse2_glue.c                |  513 ++-----
 arch/x86/crypto/sha1_ssse3_asm.S                   |    2 +-
 arch/x86/crypto/sha1_ssse3_glue.c                  |    6 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |  300 ++++
 arch/x86/crypto/twofish_avx_glue.c                 |  624 +++++++
 arch/x86/crypto/twofish_glue_3way.c                |  409 ++----
 arch/x86/include/asm/crypto/ablk_helper.h          |   31 +
 arch/x86/include/asm/{ => crypto}/aes.h            |    0
 arch/x86/include/asm/crypto/glue_helper.h          |  115 ++
 arch/x86/include/asm/crypto/serpent-avx.h          |   32 +
 .../asm/{serpent.h => crypto/serpent-sse2.h}       |    4 +-
 arch/x86/include/asm/crypto/twofish.h              |   46 +
 crypto/Kconfig                                     |   67 +-
 crypto/algapi.c                                    |   17 -
 crypto/algboss.c                                   |   17 +-
 crypto/arc4.c                                      |  115 +-
 crypto/internal.h                                  |    1 -
 crypto/tcrypt.c                                    |   86 +-
 crypto/testmgr.c                                   |  203 +++
 crypto/testmgr.h                                   | 1852 +++++++++++++++++++-
 drivers/char/hw_random/Kconfig                     |   12 +
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/exynos-rng.c                |  182 ++
 drivers/char/hw_random/mxc-rnga.c                  |   21 +-
 drivers/crypto/Kconfig                             |   56 +-
 drivers/crypto/Makefile                            |    7 +-
 drivers/crypto/atmel-aes-regs.h                    |   62 +
 drivers/crypto/atmel-aes.c                         | 1206 +++++++++++++
 drivers/crypto/atmel-sha-regs.h                    |   46 +
 drivers/crypto/atmel-sha.c                         | 1112 ++++++++++++
 drivers/crypto/atmel-tdes-regs.h                   |   89 +
 drivers/crypto/atmel-tdes.c                        | 1215 +++++++++++++
 drivers/crypto/bfin_crc.c                          |  780 ++++++++
 drivers/crypto/caam/Kconfig                        |   30 +-
 drivers/crypto/caam/Makefile                       |    4 +-
 drivers/crypto/caam/caamalg.c                      |  572 ++----
 drivers/crypto/caam/caamhash.c                     | 1878 ++++++++++++++++++++
 drivers/crypto/caam/caamrng.c                      |  309 ++++
 drivers/crypto/caam/compat.h                       |    2 +
 drivers/crypto/caam/ctrl.c                         |  179 ++-
 drivers/crypto/caam/ctrl.h                         |   13 +
 drivers/crypto/caam/desc.h                         |   31 +-
 drivers/crypto/caam/desc_constr.h                  |   57 +-
 drivers/crypto/caam/error.c                        |   44 +-
 drivers/crypto/caam/intern.h                       |    6 +-
 drivers/crypto/caam/jr.c                           |  115 +-
 drivers/crypto/caam/key_gen.c                      |  122 ++
 drivers/crypto/caam/key_gen.h                      |   17 +
 drivers/crypto/caam/pdb.h                          |  401 +++++
 drivers/crypto/caam/regs.h                         |   38 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |  156 ++
 drivers/crypto/mv_cesa.c                           |   61 +-
 drivers/crypto/talitos.c                           |  283 ++--
 drivers/crypto/talitos.h                           |  123 ++
 include/linux/platform_data/atmel-aes.h            |   22 +
 68 files changed, 13795 insertions(+), 2292 deletions(-)
  
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
