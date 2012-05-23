Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab2EWBfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:35:37 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:43511 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751661Ab2EWBff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:35:35 -0400
Date: Wed, 23 May 2012 11:35:28 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 3.5
Message-ID: <20120523013528.GA20781@gondor.apana.org.au>
References: <20100521104404.GA29530@gondor.apana.org.au>
 <20100804140448.GA4042@gondor.apana.org.au>
 <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au>
 <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20120320032736.GA21367@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320032736.GA21367@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 3.5:

* New cipher/hash driver for ARM ux500.
* Code clean-up for aesni-intel.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Andreas Westin (5):
      crypto: ux500 - Add driver for CRYP hardware
      crypto: ux500 - Add driver for HASH hardware
      mach-ux500: crypto - core support for CRYP/HASH module.
      crypto: ux500 - Update DMA handling for 3.4
      crypto: ux500 - Cleanup hardware identification

Borislav Petkov (1):
      crypto, xor: Sanitize checksumming function selection output

Julia Lawall (2):
      crypto: crypto4xx - move up err_request_irq label
      hwrng: omap - use devm_request_and_ioremap

Jussi Kivilinna (2):
      crypto: aesni-intel - use crypto_[un]register_algs
      crypto: aesni-intel - move more common code to ablk_init_common

Nicolas Ferre (1):
      hwrng: Kconfig - modify default state for atmel-rng driver

Shengzhou Liu (1):
      crypto: caam - add backward compatible string sec4.0

 arch/arm/mach-ux500/board-mop500.c              |   48 
 arch/arm/mach-ux500/clock.c                     |   18 
 arch/arm/mach-ux500/devices-common.h            |   54 
 arch/arm/mach-ux500/devices-db8500.c            |    3 
 arch/arm/mach-ux500/devices-db8500.h            |    4 
 arch/arm/mach-ux500/include/mach/crypto-ux500.h |   22 
 arch/arm/mach-ux500/include/mach/devices.h      |    3 
 arch/arm/mach-ux500/include/mach/hardware.h     |    3 
 arch/x86/crypto/aesni-intel_glue.c              |  827 +++------
 crypto/xor.c                                    |    5 
 drivers/char/hw_random/Kconfig                  |    2 
 drivers/char/hw_random/omap-rng.c               |   22 
 drivers/crypto/Kconfig                          |   11 
 drivers/crypto/Makefile                         |    1 
 drivers/crypto/amcc/crypto4xx_core.c            |    2 
 drivers/crypto/caam/caamalg.c                   |   14 
 drivers/crypto/caam/ctrl.c                      |   16 
 drivers/crypto/ux500/Kconfig                    |   30 
 drivers/crypto/ux500/Makefile                   |    8 
 drivers/crypto/ux500/cryp/Makefile              |   13 
 drivers/crypto/ux500/cryp/cryp.c                |  401 ++++
 drivers/crypto/ux500/cryp/cryp.h                |  308 +++
 drivers/crypto/ux500/cryp/cryp_core.c           | 1790 +++++++++++++++++++++
 drivers/crypto/ux500/cryp/cryp_irq.c            |   45 
 drivers/crypto/ux500/cryp/cryp_irq.h            |   31 
 drivers/crypto/ux500/cryp/cryp_irqp.h           |  125 +
 drivers/crypto/ux500/cryp/cryp_p.h              |  125 +
 drivers/crypto/ux500/hash/Makefile              |   11 
 drivers/crypto/ux500/hash/hash_alg.h            |  395 ++++
 drivers/crypto/ux500/hash/hash_core.c           | 2031 +++++++++++++++++++++++-
 30 files changed, 5819 insertions(+), 549 deletions(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
