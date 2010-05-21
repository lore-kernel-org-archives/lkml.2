Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab0EUKoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:44:20 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:51001 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753136Ab0EUKoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:44:17 -0400
Date: Fri, 21 May 2010 20:44:05 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.35
Message-ID: <20100521104404.GA29530@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519020603.GA19654@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Here is a revised crypto update for 2.6.35:

* Hardware hash support in mv_cesa.
* Hardware hash support in omap.
* Hardware hash support in talitos.
* Hardware hash/cipher support for Niagara2.
* Hardware support for CTR mode in aesni.
* VMAC now works on big-endian.
* Updates to padata.
* Misc fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Chihau Chau (1):
      crypto: geode-aes - Fix some code style issues

Dan Carpenter (2):
      crypto: pcrypt - Handle crypto_get_attr_type errors
      crypto: algapi - Remove unneeded null check

David S. Miller (6):
      crypto: hifn_795x - Rename ablkcipher_walk to hifn_cipher_walk
      crypto: scatterwalk - Fix scatterwalk_done() test
      crypto: tcrypt - Add speed tests for async hashing
      crypto: testmgr - Add testing for async hashing and update/final
      crypto: skcipher - Add ablkcipher_walk interfaces
      crypto: n2 - Add Niagara2 crypto driver

Dmitry Kasatkin (3):
      crypto: omap - Updates omap sham device related platform code
      crypto: omap - sha1 & md5 driver
      crypto: omap - OMAP macros corrected

Henrik Kretzschmar (1):
      padata: Section cleanup

Herbert Xu (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
      crypto: shash - Remove usage of CRYPTO_MINALIGN

Huang Ying (4):
      crypto: aesni-intel - Add AES-NI accelerated CTR mode
      crypto: tcrypt - Speed testing support for ghash
      crypto: aesni-intel - Fix CTR optimization build failure with gas 2.16.1
      crypto: aesni-intel - Fix another CTR build failure with gas 2.16.1

Kim Phillips (1):
      crypto: talitos - add support for sha224

Lee Nipper (3):
      crypto: talitos - prepare for adding ahash algorithms
      crypto: talitos - second prepare step for adding ahash algorithms
      crypto: talitos - add hash algorithms

Matt Mackall (1):
      random: simplify fips mode

Richard Hartmann (1):
      crypto: internal - Fix checkpatch errors

Shane Wang (1):
      crypto: vmac - Fix big-endian support

Shikhar Khattar (1):
      crypto: authenc - Fix cryptlen calculation

Steffen Klassert (9):
      padata: Dont scale the parallel objects with the cpus
      padata: cpu hotplug code should depend on CONFIG_HOTPLUG_CPU
      padata: Remove superfluous might_sleep
      padata: Initialize the padata queues only for the used cpus
      padata: Use get_online_cpus/put_online_cpus
      padata: Use a timer to handle remaining objects in the reorder queues
      padata: Flush the padata queues actively
      padata: Add some code comments
      padata: Use get_online_cpus/put_online_cpus in padata_free

Tobias Klauser (1):
      crypto: mv_cesa - Use resource_size

Uri Simchoni (10):
      crypto: mv_cesa - Invoke the user callback from a softirq context
      crypto: mv_cesa - Remove compiler warning in mv_cesa driver
      crypto: mv_cesa - Fix situation where the dest sglist is organized differently than the source sglist
      crypto: mv_cesa - Fix situations where the src sglist spans more data than the request asks for
      crypto: mv_cesa - Enqueue generic async requests
      crypto: mv_cesa - Rename a variable to a more suitable name
      crypto: mv_cesa - Execute some code via function pointers rathr than direct calls
      crypto: mv_cesa - Make the copy-back of data optional
      crypto: mv_cesa - Support processing of data from previous requests
      crypto: mv_cesa - Add sha1 and hmac(sha1) async hash drivers

 arch/arm/mach-omap2/clock2420_data.c       |    2 +-
 arch/arm/mach-omap2/clock2430_data.c       |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c       |    2 +-
 arch/arm/mach-omap2/devices.c              |   58 +-
 arch/arm/plat-omap/include/plat/omap34xx.h |    5 +
 arch/x86/crypto/aesni-intel_asm.S          |  115 ++
 arch/x86/crypto/aesni-intel_glue.c         |  130 ++-
 arch/x86/include/asm/inst.h                |   96 ++-
 crypto/ablkcipher.c                        |  277 ++++
 crypto/algapi.c                            |    2 +-
 crypto/authenc.c                           |    8 +-
 crypto/internal.h                          |    2 +-
 crypto/pcrypt.c                            |   11 +-
 crypto/scatterwalk.c                       |    2 +-
 crypto/shash.c                             |    2 +-
 crypto/tcrypt.c                            |  343 +++++-
 crypto/tcrypt.h                            |   29 +
 crypto/testmgr.c                           |   66 +-
 crypto/testmgr.h                           |   64 +-
 crypto/vmac.c                              |   75 +-
 drivers/char/random.c                      |   10 +-
 drivers/crypto/Kconfig                     |   21 +
 drivers/crypto/Makefile                    |    4 +
 drivers/crypto/geode-aes.c                 |   36 +-
 drivers/crypto/hifn_795x.c                 |   18 +-
 drivers/crypto/mv_cesa.c                   |  692 +++++++++-
 drivers/crypto/mv_cesa.h                   |   40 +-
 drivers/crypto/n2_asm.S                    |   95 ++
 drivers/crypto/n2_core.c                   | 2083 ++++++++++++++++++++++++++++
 drivers/crypto/n2_core.h                   |  231 +++
 drivers/crypto/omap-sham.c                 | 1259 +++++++++++++++++
 drivers/crypto/talitos.c                   |  699 +++++++++-
 drivers/crypto/talitos.h                   |   12 +-
 include/crypto/algapi.h                    |   40 +
 include/linux/padata.h                     |   55 +
 kernel/padata.c                            |  185 ++-
 36 files changed, 6456 insertions(+), 315 deletions(-)
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
