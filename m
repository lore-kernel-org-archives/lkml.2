Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0JXGQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 02:16:36 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:48408 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab0JXGQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 02:16:34 -0400
Date: Sat, 23 Oct 2010 23:16:25 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 2.6.37
Message-ID: <20101024061625.GA23715@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804140448.GA4042@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 2.6.37:

* cryptd now supports AEAD.
* OMAP2/3 AES support.
* Mark Steffen Klassert as maintainer for padata/pcrypt.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Adrian Hoban (1):
      crypto: cryptd - Adding the AEAD interface type support to cryptd

Chuck Ebbert (1):
      crypto: fips - FIPS requires algorithm self-tests

David S. Miller (1):
      crypto: n2_crypto - Niagara2 driver needs to depend upon CRYPTO_DES

Dmitry Kasatkin (2):
      crypto: updates to enable omap aes
      crypto: omap-aes - OMAP2/3 AES hw accelerator driver

Justin P. Mattock (1):
      crypto: Kconfig - update broken web addresses

Kim Phillips (3):
      crypto: talitos - fix warning: 'alg' may be used uninitialized in this function
      crypto: talitos - fix checkpatch warning
      crypto: talitos - sparse check endian fixes

Namhyung Kim (1):
      padata: add missing __percpu markup in include/linux/padata.h

Samu Onkalo (1):
      crypto: omap-sham - Adjust DMA parameters

Steffen Klassert (1):
      MAINTAINERS: Add maintainer entries for padata/pcrypt

Tejun Heo (1):
      crypto: hifn_795x - use cancel_delayed_work_sync()

Tracey Dent (1):
      crypto: Makefile - replace the use of <module>-objs with <module>-y

 MAINTAINERS                          |   16 +
 arch/arm/mach-omap2/clock2420_data.c |    2 +-
 arch/arm/mach-omap2/clock2430_data.c |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c |    2 +-
 arch/arm/mach-omap2/devices.c        |   71 +++
 crypto/Kconfig                       |   21 +-
 crypto/cryptd.c                      |  206 ++++++++-
 drivers/crypto/Kconfig               |    9 +
 drivers/crypto/Makefile              |    3 +-
 drivers/crypto/amcc/Makefile         |    2 +-
 drivers/crypto/hifn_795x.c           |    3 +-
 drivers/crypto/omap-aes.c            |  948 ++++++++++++++++++++++++++++++++++
 drivers/crypto/omap-sham.c           |    6 +-
 drivers/crypto/talitos.c             |   29 +-
 include/crypto/cryptd.h              |   24 +
 include/linux/padata.h               |    4 +-
 16 files changed, 1310 insertions(+), 38 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
