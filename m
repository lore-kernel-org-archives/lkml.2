Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab0HDOFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:05:00 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:57154 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab0HDOEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:04:55 -0400
Date: Wed, 4 Aug 2010 22:04:48 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Update for 2.6.36
Message-ID: <20100804140448.GA4042@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521104404.GA29530@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is the crypto update for 2.6.36:

* HMAC support for Niagara2.
* Talitos ahash bug fix.
* Adds sysfs interface to padata/pcrypt.
* Fixes/clean-ups for padata/pcrypt.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alexander Shishkin (1):
      crypto: testmgr - add an option to disable cryptoalgos' self-tests

Andrea Gelmini (1):
      crypto: des_s390 - Checkpatch cleanup

Dan Carpenter (2):
      crypto: mv_cesa - fixup error handling in mv_probe()
      padata: add parenthesis in MAX_SEQ_NR macro

Dan Kruchinin (3):
      padata: Make two separate cpumasks
      padata: Added sysfs primitives to padata subsystem
      pcrypt: Added sysfs interface to pcrypt

David S. Miller (4):
      n2_crypto: Kill n2_base_ctx and helpers.
      n2_crypto: Log algorithm success/failure in kernel log.
      n2_crypto: Make ahash parameterization explicit.
      n2_crypto: Add HMAC support.

Herbert Xu (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/crypto-2.6
      crypto: pcomp - Fix illegal Kconfig configuration

Huang Weiyi (1):
      crypto: omap - remove unused #include <linux/version.h>

Jan Glauber (2):
      crypto: des_s390: remove des3_ede128 mode
      crypto: des_s390: use generic weak key check

Joachim Fritschi (1):
      crypto: twofish: Rename twofish to twofish_generic and add an alias

Julia Lawall (1):
      crypto: Use ERR_CAST

Justin P. Mattock (1):
      crypto: hifn_795x - Remove unused ctx variable

Kulikov Vasiliy (1):
      hwrng: n2-drv - remove casts from void*

Lee Nipper (1):
      crypto: talitos - fix ahash for multiple of blocksize

Peter Huewe (1):
      crypto: geode_aes - Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)

Richard Kennedy (1):
      random: Reorder struct entropy_store to remove padding on 64bits

Steffen Klassert (17):
      padata: Check for valid padata instance on start
      padata: Block until the instance is unused on stop
      padata: Handle empty padata cpumasks
      padata: make padata_do_parallel to return zero on success
      padata: simplify serialization mechanism
      padata: update documentation
      padata: Fix cpu index counting
      padata: Allocate cpumask dependend recources in any case
      padata: Check for valid cpumasks
      crypto: pcrypt - Dont calulate a callback cpu on empty callback cpumask
      padata: Rename padata_alloc functions
      padata: Rearrange set_cpumask functions
      padata: Pass the padata cpumasks to the cpumask_change_notifier chain
      crypto: pcrypt - Rename pcrypt_instance
      crypto: pcrypt - Update pcrypt cpumask according to the padata cpumask notifier
      padata: Remove padata_get_cpumask
      padata: update API documentation

 Documentation/padata.txt                |   97 +++-
 arch/s390/crypto/Makefile               |    2 +-
 arch/s390/crypto/crypto_des.h           |    2 +-
 arch/s390/crypto/des_s390.c             |  238 +---------
 crypto/Kconfig                          |   15 +-
 crypto/Makefile                         |    4 +-
 crypto/algboss.c                        |    4 +
 crypto/authenc.c                        |    2 +-
 crypto/ctr.c                            |    2 +-
 crypto/pcrypt.c                         |  241 ++++++++---
 crypto/testmgr.c                        |   14 +
 crypto/{twofish.c => twofish_generic.c} |    1 +
 crypto/xts.c                            |    2 +-
 drivers/char/hw_random/n2-drv.c         |    2 +-
 drivers/char/random.c                   |    2 +-
 drivers/crypto/geode-aes.c              |    2 +-
 drivers/crypto/hifn_795x.c              |    4 -
 drivers/crypto/mv_cesa.c                |   10 +-
 drivers/crypto/n2_core.c                |  417 ++++++++++++-----
 drivers/crypto/omap-sham.c              |    1 -
 drivers/crypto/talitos.c                |   77 ++--
 include/linux/padata.h                  |  121 ++++--
 kernel/padata.c                         |  755 +++++++++++++++++++++++--------
 23 files changed, 1307 insertions(+), 708 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
