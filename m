Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1KADso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 23:48:44 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:39000 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab1KADsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 23:48:41 -0400
Date: Tue, 1 Nov 2011 14:48:32 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 3.2
Message-ID: <20111101034832.GA6993@gondor.apana.org.au>
References: <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <20110315145940.GA15373@gondor.apana.org.au> <20110520235409.GA1722@gondor.apana.org.au> <20110724011752.GA14373@gondor.apana.org.au> <20111031040952.GA19659@gondor.apana.org.au> <4EAED00C.3010908@xenotime.net> <CA+55aFw=quU1bVR_AZ0OBW4DkPWMfxvWu7smx9VcDe81vaGu9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFw=quU1bVR_AZ0OBW4DkPWMfxvWu7smx9VcDe81vaGu9Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Mon, Oct 31, 2011 at 10:16:55AM -0700, Linus Torvalds wrote:
> On Mon, Oct 31, 2011 at 9:42 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> >
> > Actually adds "select NET", a reverse dependency.  :(
> >
> > Linus was quite vocal about not allowing MD to select BLOCK.
> > See https://lkml.org/lkml/2011/8/10/527
> > and https://lkml.org/lkml/2011/8/10/533
> >
> > To me this is very similar.
> 
> I do agree.

OK, I've turned it into a depends_on.

Here is the crypto update for 3.2:

* User-space interface for algorithm selection/configuration
* SSSE3 implementation of SHA1.
* X86-64 assembly implementation of blowfish.
* X86-64 assembly implementation of twofish.
* Misc fixes.


Please pull from

git://github.com/herbertx/crypto.git


The top commit object is

	commit 5db017aa2809c49ca0a43b0f3ed1267e6be60883
	Author: Herbert Xu <herbert@gondor.apana.org.au>
	Date:   Tue Nov 1 12:12:43 2011 +1100

	    crypto: user - Depend on NET instead of selecting it

Alexey Dobriyan (1):
      crypto: whirlpool - count rounds from 0

H Hartley Sweeten (1):
      crypto: aes-x86 - quiet sparse noise about symbol not declared

Herbert Xu (5):
      crypto: sha - Fix build error due to crypto_sha1_update
      crypto: cryptd - Use subsys_initcall to prevent races with aesni
      crypto: user - Initialise match in crypto_alg_match
      crypto: user - Add dependency on NET
      crypto: user - Depend on NET instead of selecting it

Jamie Iles (5):
      crypto: picoxcell - convert to platform ID table
      crypto: picoxcell - add connection ID to the clock name
      crypto: picoxcell - support for device tree matching
      crypto: picoxcell - fix possible invalid pointer dereference
      crypto: picoxcell - add dependency on HAVE_CLK

Jonathan Nieder (1):
      crypto: padlock-aes - Make module loading even quieter when hardware is missing

Jussi Kivilinna (13):
      crypto: blowfish - split generic and common c code
      crypto: blowfish - rename C-version to blowfish_generic
      crypto: tcrypt - add ctr(blowfish) speed test
      crypto: blowfish - add x86_64 assembly implementation
      crypto: blowfish-x86_64 - improve x86_64 blowfish 4-way performance
      crypto: blowfish-x86_64 - add credits
      crypto: tcrypt - add ctr(twofish) speed test
      crypto: twofish-x86-asm - make assembler functions use twofish_ctx instead of crypto_tfm
      crypto: twofish - add 3-way parallel x86_64 assembler implemention
      crypto: blowfish-x86_64 - fix ctr blocksize to 1
      crypto: twofish-x86_64-3way - fix ctr blocksize to 1
      crypto: testmgr - add blowfish test-vectors
      crypto: testmgr - add twofish tests

Kim Phillips (1):
      crypto: talitos - handle descriptor not found in error path

Mathias Krause (2):
      crypto: sha1 - export sha1_update for reuse
      crypto: sha1 - SSSE3 based SHA1 implementation for x86-64

Richard Weinberger (1):
      crypto: Make hifn_795x build depend on !ARCH_DMA_ADDR_T_64BIT

Steffen Klassert (17):
      crypto: Add a flag to identify crypto instances
      crypto: Export crypto_remove_spawns
      crypto: Export crypto_remove_final
      crypto: Add userspace configuration API
      crypto: Add a report function pointer to crypto_type
      crypto: Add userspace report for larval type algorithms
      crypto: Add userspace report for shash type algorithms
      crypto: Add userspace report for ahash type algorithms
      crypto: Add userspace report for blkcipher type algorithms
      crypto: Add userspace report for ablkcipher type algorithms
      crypto: Add userspace report for givcipher type algorithms
      crypto: Add userspace report for aead type algorithms
      crypto: Add userspace report for nivaead type algorithms
      crypto: Add userspace report for pcompress type algorithms
      crypto: Add userspace report for rng type algorithms
      crypto: Add userspace report for cipher type algorithms
      crypto: Add userspace report for compress type algorithms

Thomas Meyer (1):
      crypto: n2 - Fix a get/put_cpu() imbalance

 .../devicetree/bindings/crypto/picochip-spacc.txt  |   23 +
 arch/x86/crypto/Makefile                           |   12 +
 arch/x86/crypto/aes_glue.c                         |    1 +
 arch/x86/crypto/blowfish-x86_64-asm_64.S           |  390 ++++++++++++++
 arch/x86/crypto/blowfish_glue.c                    |  492 +++++++++++++++++
 arch/x86/crypto/sha1_ssse3_asm.S                   |  558 ++++++++++++++++++++
 arch/x86/crypto/sha1_ssse3_glue.c                  |  240 +++++++++
 arch/x86/crypto/twofish-i586-asm_32.S              |   10 +-
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S       |  316 +++++++++++
 arch/x86/crypto/twofish-x86_64-asm_64.S            |    6 +-
 arch/x86/crypto/twofish_glue.c                     |   12 +-
 arch/x86/crypto/twofish_glue_3way.c                |  472 +++++++++++++++++
 arch/x86/include/asm/cpufeature.h                  |    3 +
 crypto/Kconfig                                     |   63 +++
 crypto/Makefile                                    |    4 +-
 crypto/ablkcipher.c                                |   48 ++
 crypto/aead.c                                      |   48 ++
 crypto/ahash.c                                     |   21 +
 crypto/algapi.c                                    |   12 +-
 crypto/blkcipher.c                                 |   25 +
 crypto/{blowfish.c => blowfish_common.c}           |   98 +----
 crypto/blowfish_generic.c                          |  142 +++++
 crypto/cryptd.c                                    |    2 +-
 crypto/crypto_user.c                               |  438 +++++++++++++++
 crypto/internal.h                                  |    3 +
 crypto/pcompress.c                                 |   18 +
 crypto/rng.c                                       |   20 +
 crypto/sha1_generic.c                              |    9 +-
 crypto/shash.c                                     |   21 +
 crypto/tcrypt.c                                    |   10 +
 crypto/testmgr.c                                   |   30 +
 crypto/testmgr.h                                   |  398 ++++++++++++++-
 crypto/wp512.c                                     |   18 +-
 drivers/crypto/Kconfig                             |    3 +-
 drivers/crypto/hifn_795x.c                         |    6 +-
 drivers/crypto/n2_core.c                           |    4 +-
 drivers/crypto/padlock-aes.c                       |    4 +-
 drivers/crypto/picoxcell_crypto.c                  |  121 ++---
 drivers/crypto/talitos.c                           |   18 +-
 include/crypto/algapi.h                            |    2 +
 include/crypto/blowfish.h                          |   23 +
 include/crypto/sha.h                               |    5 +
 include/linux/crypto.h                             |    5 +
 include/linux/cryptouser.h                         |  102 ++++
 include/linux/netlink.h                            |    1 +
 45 files changed, 4049 insertions(+), 208 deletions(-)

Thanks,
- - -- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUBTq9r9McnHQpJsYunAQIJ2xAAmIfhscY9FfQFRQhmQnXWE8fmNTBQZ2cJ
Kzo2FNdF7oxeIX2IsYFCVUWEWMFb/8Q48jMVitMTlPGrbqZ6MS6PzzguYxGVjuPA
lUO1vzpBKjGhqV4w8VLXmcaNxcuO24xb0Pg7WxfTe36IYf1ROA7m3s2VUag4yDhD
zV66lfeTbnZuDd9qPFmyZWDZt5fGe7t52FYqG5OeM+4sxWpHnDLbAPKguMKzRi6j
bezYRYVQaEuNxSNtPjh+XtaSWmWGlTLhKaCrX84aUg1qQ8lEW7mvsP02VZfFiSHY
rvToupuh4A8+y9Wt50pPlrGppc9IekIpfd7kAAsqzXhJiskf6z9mo+n6BsQODK5q
3cDNwc4EIpI/scKbEilznf8jcx5d3B3qyTmTzzYx1sK0NjiEubmE+jVJYC785s5v
C8Fw3RNQtUXnb13ci810mE9pLMrG8c9J2rRRH1d4Sqr9XKpMcUCBFZ3kRPkO3dix
qkh+5Axt88EvgXrIJrlIFozwJpZKwcs4vOBH4uV1y2zwShaemp0sjJDuZxAJGCSJ
8sv2YF0M7mfwul2vzTLQ8vVbcSjrGefk209bJ7JDGnK3NMf5BFsiTjNv2hEZU54t
15JrgQ444s+yC8dTEezmrsE4QaSdTmCwXQzUNuXDDnVT6xq226b0aGT+Mmak7xM3
tOuM1V3qczs=
=GwqI
-----END PGP SIGNATURE-----
