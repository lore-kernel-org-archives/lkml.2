Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2LNKcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:32:08 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:35684 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752769Ab2LNKcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:32:04 -0500
Date: Fri, 14 Dec 2012 18:31:56 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.8
Message-ID: <20121214103156.GA5840@gondor.apana.org.au>
References: <20100521104404.GA29530@gondor.apana.org.au>
 <20100804140448.GA4042@gondor.apana.org.au>
 <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004095357.GA11777@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.8:

* Added aesni/avx/x86_64 implementations for camellia.
* Optimised AVX code for cast5/serpent/twofish/cast6.
* Fixed vmac bug with unaligned input.
* Allow compression algorithms in FIPS mode.
* Optimised crc32c implementation for Intel.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Axel Lin (1):
      crypto: picoxcell - Add terminating entry for platform_device_id table

Jussi Kivilinna (18):
      crypto: testmgr - expand camellia test vectors
      crypto: testmgr - expand blowfish test vectors
      crypto: testmgr - expand serpent test vectors
      crypto: testmgr - add new larger AES testvectors
      crypto: testmgr - add new larger DES testvectors
      crypto: testmgr - add new larger DES3_EDE testvectors
      crypto: x86/glue_helper - use le128 instead of u128 for CTR mode
      crypto: cast6/avx - avoid using temporary stack buffers
      crypto: twofish/avx - avoid using temporary stack buffers
      crypto: serpent/avx - avoid using temporary stack buffers
      crypto: cast5/avx - avoid using temporary stack buffers
      crypto: tcrypt - add async speed test for camellia cipher
      crypto: camellia-x86_64 - share common functions and move structures and function definitions to header file
      crypto: camellia - add AES-NI/AVX/x86_64 assembler implementation of camellia cipher
      crypto: cast5/cast6 - move lookup tables to shared module
      crypto: testmgr - remove fips_allowed flag from camellia-aesni null-tests
      crypto: testmgr - clean alg_test_null entries in alg_test_descs[]
      crypto: testmgr - add larger crc32c test vector to test FPU path in crc32c_intel

Mathias Krause (1):
      crypto: testmgr - remove superfluous initializers for xts(aes)

Milan Broz (1):
      crypto: testmgr - allow compression algs in fips mode

Sachin Kamat (1):
      crypto: s5p-sss - Fix compilation error

Salman Qazi (1):
      crypto: vmac - Make VMAC work when blocks aren't aligned

Sebastian Andrzej Siewior (1):
      crypto: omap-aes - select BLKCIPHER2

Shan Wei (1):
      padata: use __this_cpu_read per-cpu helper

Tim Chen (3):
      crypto: crc32c - Rename crc32c-intel.c to crc32c-intel_glue.c
      crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction
      crypto: tcrypt - Added speed test in tcrypt for crc32c

Vakul Garg (1):
      crypto: caam - Updated SEC-4.0 device tree binding for ERA information.

Wei Yongjun (3):
      crypto: talitos - convert to use be16_add_cpu()
      crypto: tegra - fix missing unlock on error case
      crypto: tegra-aes - fix error-valued pointer dereference

 .../devicetree/bindings/crypto/fsl-sec4.txt        |    5 +-
 arch/x86/crypto/Makefile                           |    5 +
 arch/x86/crypto/camellia-aesni-avx-asm_64.S        | 1102 ++++
 arch/x86/crypto/camellia_aesni_avx_glue.c          |  558 ++
 arch/x86/crypto/camellia_glue.c                    |   92 +-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S          |  348 +-
 arch/x86/crypto/cast5_avx_glue.c                   |   79 +-
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S          |  206 +-
 arch/x86/crypto/cast6_avx_glue.c                   |   77 +-
 .../crypto/{crc32c-intel.c => crc32c-intel_glue.c} |   81 +
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |  460 ++
 arch/x86/crypto/glue_helper-asm-avx.S              |   91 +
 arch/x86/crypto/glue_helper.c                      |   12 +-
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S        |  166 +-
 arch/x86/crypto/serpent_avx_glue.c                 |   49 +-
 arch/x86/crypto/serpent_sse2_glue.c                |   12 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S        |  208 +-
 arch/x86/crypto/twofish_avx_glue.c                 |   73 +-
 arch/x86/crypto/twofish_glue_3way.c                |   20 +-
 arch/x86/include/asm/crypto/camellia.h             |   82 +
 arch/x86/include/asm/crypto/glue_helper.h          |   28 +-
 arch/x86/include/asm/crypto/serpent-avx.h          |   27 +-
 arch/x86/include/asm/crypto/twofish.h              |    4 +-
 crypto/Kconfig                                     |   42 +
 crypto/Makefile                                    |    1 +
 crypto/cast5_generic.c                             |  277 +-
 crypto/cast6_generic.c                             |  280 +-
 crypto/cast_common.c                               |  290 +
 crypto/tcrypt.c                                    |   29 +
 crypto/testmgr.c                                   |  369 +--
 crypto/testmgr.h                                   | 5912 +++++++++++++++++++-
 crypto/vmac.c                                      |   47 +-
 drivers/crypto/Kconfig                             |    1 +
 drivers/crypto/picoxcell_crypto.c                  |    1 +
 drivers/crypto/s5p-sss.c                           |    2 +-
 drivers/crypto/talitos.c                           |    3 +-
 drivers/crypto/tegra-aes.c                         |   10 +-
 include/crypto/cast5.h                             |    6 +-
 include/crypto/cast6.h                             |    6 +-
 include/crypto/cast_common.h                       |    9 +
 include/crypto/vmac.h                              |    2 +
 kernel/padata.c                                    |    5 +-
 42 files changed, 9391 insertions(+), 1686 deletions(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
