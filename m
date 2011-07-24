Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1GXSDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:03:06 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:35807 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1GXSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:02:51 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
        Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH v2 0/2] crypto, x86: assembler implementation of SHA1
Date: Sun, 24 Jul 2011 19:53:12 +0200
Message-Id: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds an assembler implementation for the SHA1 hash algorithm
for the x86-64 architecture. Its raw hash performance can be more than 2 times
faster than the generic C implementation. This gives a real world benefit for
IPsec with an throughput increase of up to +35%. For concrete numbers have a
look at the second patch.

This implementation is currently x86-64 only but might be ported to 32 bit with
some effort in a follow up patch. (I had no time to do this yet.)

Note: The SSSE3 is no typo, it's "Supplemental SSE3".

v2 changes:
- fixed typo in Makefile making AVX version unusable
- whitespace fixes for the .S file

Regards,
Mathias

Mathias Krause (2):
  crypto, sha1: export sha1_update for reuse
  crypto, x86: SSSE3 based SHA1 implementation for x86-64

 arch/x86/crypto/Makefile          |    8 +
 arch/x86/crypto/sha1_ssse3_asm.S  |  558 +++++++++++++++++++++++++++++++++++++
 arch/x86/crypto/sha1_ssse3_glue.c |  240 ++++++++++++++++
 arch/x86/include/asm/cpufeature.h |    3 +
 crypto/Kconfig                    |   10 +
 crypto/sha1_generic.c             |    9 +-
 include/crypto/sha.h              |    5 +
 7 files changed, 829 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/crypto/sha1_ssse3_asm.S
 create mode 100644 arch/x86/crypto/sha1_ssse3_glue.c

