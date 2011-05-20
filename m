Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1ETXyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 19:54:25 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:49589 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1ETXyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 19:54:20 -0400
Date: Sat, 21 May 2011 09:54:09 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 2.6.40
Message-ID: <20110520235409.GA1722@gondor.apana.org.au>
References: <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <20110315145940.GA15373@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315145940.GA15373@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 2.6.40:

* New Freescale SEC4/CAAM driver.
* New S5PV210 advanced crypto engine driver.
* Support for EMU chips on omap.
* SHA-128/256 support for VIA Nano.
* Native XTS/GHASH/CTR support on s390.
* New test vector for AES-OFB.
* Make aesni-intel build on 32-bit again.
* SHA1 fixes for omap.
* Bug fixes for mv_cesa.
* AMD RNG support on Maple PPC boards.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Andy Lutomirski (1):
      crypto: aesni-intel - Merge with fpu.ko

Brilly Wu (1):
      crypto: padlock - Add SHA-1/256 module for VIA Nano

Dan Carpenter (2):
      crypto: caam - dereferencing ERR_PTR on allocation failure
      crypto: caam - ARRAY_SIZE() vs sizeof()

Dmitry Eremin-Solenikov (2):
      hwrng: amd - manage resource allocation
      hwrng: amd - enable AMD hw rnd driver for Maple PPC boards

Dmitry Kasatkin (3):
      crypto: omap-sham - remove debug print
      crypto: omap-sham - enable driver for EMU chips
      crypto: omap-sham - hmac calculation bug fix for sha1 base hash

Gerald Schaefer (3):
      crypto: s390 - add System z hardware support for XTS mode
      crypto: s390 - add System z hardware support for GHASH
      crypto: s390 - add System z hardware support for CTR mode

Jamie Iles (1):
      crypto: picoxcell - fix possible status FIFO overflow

Jan Glauber (4):
      crypto: s390 - extend crypto facility check
      crypto: s390 - cleanup DES code
      crypto: s390 - cleanup s390 Kconfig options
      crypto: tcrypt - CTR mode speed test for AES

Julia Lawall (1):
      crypto: caam - introduce missing kfree

Kim Phillips (13):
      crypto: caam - Add support for the Freescale SEC4/CAAM
      crypto: caam - standardize device tree naming convention to utilize '-vX.Y'
      crypto: caam - de-CHIP-ify device tree compatibles
      crypto: caam - handle interrupt lines shared across rings
      crypto: caam - fix queue interface detection
      crypto: caam - remove WAIT-FOR-COMPLETIONs from givencrypt descriptor
      crypto: caam - remove duplicate dev_err
      crypto: caam - remove unused keylen from session context
      crypto: caam - fix printk recursion for long error texts
      crypto: caam - platform_bus_type migration
      crypto: caam - fix decryption shared vs. non-shared key setting
      crypto: caam - remove unused authkeylen from caam_ctx
      crypto: caam - add support for sha512 variants of existing AEAD algorithms

Markku Kylanpaa (1):
      crypto: omap-sham - fix concurrent sha1 calculations

Phil Sutter (10):
      crypto: mv_cesa - use ablkcipher_request_cast instead of the manual container_of
      crypto: mv_cesa - the descriptor pointer register needs to be set just once
      crypto: mv_cesa - drop this call to mv_hash_final from mv_hash_finup
      crypto: mv_cesa - print a warning when registration of AES algos fail
      crypto: mv_cesa - no need to save digest state after the last chunk
      crypto: mv_cesa - refactor copy_src_to_buf()
      crypto: mv_cesa - fill inner/outer IV fields only in HMAC case
      crypto: mv_cesa - move digest state initialisation to a better place
      crypto: mv_cesa - copy remaining bytes to SRAM only when needed
      crypto: mv_cesa - make count_sgs() null-pointer proof

Puneet Saxena (1):
      crypto: testmgr - add support for aes ofb mode

Randy Dunlap (1):
      crypto: aesni-intel - fix aesni build on i386

Vladimir Zapolskiy (1):
      crypto: s5p-sss - add S5PV210 advanced crypto engine support

 .../devicetree/bindings/crypto/fsl-sec4.txt        |  397 +++++
 arch/powerpc/boot/dts/p4080ds.dts                  |   86 +-
 arch/s390/crypto/Makefile                          |    1 +
 arch/s390/crypto/aes_s390.c                        |  383 +++++-
 arch/s390/crypto/crypt_s390.h                      |  112 ++-
 arch/s390/crypto/des_check_key.c                   |  132 --
 arch/s390/crypto/des_s390.c                        |  370 ++++--
 arch/s390/crypto/ghash_s390.c                      |  162 ++
 arch/s390/crypto/prng.c                            |    2 +-
 arch/s390/crypto/sha1_s390.c                       |    2 +-
 arch/s390/crypto/sha256_s390.c                     |    2 +-
 arch/s390/crypto/sha512_s390.c                     |    2 +-
 arch/x86/crypto/Makefile                           |    4 +-
 arch/x86/crypto/aesni-intel_glue.c                 |    9 +
 arch/x86/crypto/fpu.c                              |   10 +-
 crypto/Kconfig                                     |    6 -
 crypto/tcrypt.c                                    |    4 +
 crypto/testmgr.c                                   |   16 +
 crypto/testmgr.h                                   |   60 +
 drivers/char/hw_random/Kconfig                     |    2 +-
 drivers/char/hw_random/amd-rng.c                   |    9 +
 drivers/crypto/Kconfig                             |   65 +-
 drivers/crypto/Makefile                            |    2 +
 drivers/crypto/caam/Kconfig                        |   72 +
 drivers/crypto/caam/Makefile                       |    8 +
 drivers/crypto/caam/caamalg.c                      | 1268 ++++++++++++++++
 drivers/crypto/caam/compat.h                       |   35 +
 drivers/crypto/caam/ctrl.c                         |  269 ++++
 drivers/crypto/caam/desc.h                         | 1605 ++++++++++++++++++++
 drivers/crypto/caam/desc_constr.h                  |  205 +++
 drivers/crypto/caam/error.c                        |  248 +++
 drivers/crypto/caam/error.h                        |   11 +
 drivers/crypto/caam/intern.h                       |  113 ++
 drivers/crypto/caam/jr.c                           |  517 +++++++
 drivers/crypto/caam/jr.h                           |   21 +
 drivers/crypto/caam/regs.h                         |  663 ++++++++
 drivers/crypto/mv_cesa.c                           |   97 +-
 drivers/crypto/omap-sham.c                         |   78 +-
 drivers/crypto/padlock-sha.c                       |  269 ++++-
 drivers/crypto/picoxcell_crypto.c                  |   64 +-
 drivers/crypto/s5p-sss.c                           |  701 +++++++++
 41 files changed, 7660 insertions(+), 422 deletions(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
