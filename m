Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2GKRgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:36:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2GKRgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:36:49 -0400
Date: Wed, 11 Jul 2012 19:36:46 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo Mueller <tilo.mueller@informatik.uni-erlangen.de>
Subject: [PATCH 0/6] crypto: add x86_64/avx assembler implementation of
 cast5 and cast6
Message-ID: <cover.1342027375.git.johannes@goetzfried-amberg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:ZcLRkoL5T6Ql/jHR2Q7ONt7mrwkxtNNC+SnukvH5cZI
 Rv+ca5XKngPVF0sxNKHm7H+AMHeTUs0BN6LAPYIWDjelwEBttU
 AOVrkBkkZrK/G8LUjycMoXbhybMAfrc8zV9SBHIbtNLnR0IAQw
 m3cbooWHs2OfGi5WdBlAhMUFWxGQrC/iGijXaQ7sfO5j0bp648
 m3kgLLG9rYkw/NeRpbCpPzT5qqWvo4+UIRlEkthBqhVAO0NJM7
 X1lncpbCb4I7JBu0IUU4DQ3iBpSXZgkcoAS5IzTNENP4OmlT/a
 cstoYvAC7y4w2Wz+p/ts27gK1QMGvlfUGAM9mS+HHcFXGRBKzy
 rm82zchU+jTl7R4DnMJ0yy0Zq+JjUyE15vszPrZ/z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds x86_64/avx assembler implementations of the Cast5 and the
Cast6 cipher.

Johannes Goetzfried (6):
  crypto: cast5 - prepare generic module for optimized implementations
  crypto: testmgr - add larger cast5 testvectors
  crypto: cast5 - add x86_64/avx assembler implementation
  crypto: cast6 - prepare generic module for optimized implementations
  crypto: testmgr - add larger cast6 testvectors
  crypto: cast6 - add x86_64/avx assembler implementation

 arch/x86/crypto/Makefile                  |    4 +
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S |  323 ++++
 arch/x86/crypto/cast5_avx_glue.c          |  530 ++++++
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S |  336 ++++
 arch/x86/crypto/cast6_avx_glue.c          |  648 ++++++++
 crypto/Kconfig                            |   31 +
 crypto/Makefile                           |    4 +-
 crypto/cast5.c                            |  809 ---------
 crypto/cast5_generic.c                    |  822 ++++++++++
 crypto/cast6.c                            |  547 -------
 crypto/cast6_generic.c                    |  566 +++++++
 crypto/tcrypt.c                           |   82 +
 crypto/tcrypt.h                           |    1 +
 crypto/testmgr.c                          |  210 +++
 crypto/testmgr.h                          | 2538 +++++++++++++++++++++++++++--
 include/crypto/cast5.h                    |   22 +
 include/crypto/cast6.h                    |   23 +
 17 files changed, 5976 insertions(+), 1520 deletions(-)
 create mode 100644 arch/x86/crypto/cast5-avx-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/cast5_avx_glue.c
 create mode 100644 arch/x86/crypto/cast6-avx-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/cast6_avx_glue.c
 delete mode 100644 crypto/cast5.c
 create mode 100644 crypto/cast5_generic.c
 delete mode 100644 crypto/cast6.c
 create mode 100644 crypto/cast6_generic.c
 create mode 100644 include/crypto/cast5.h
 create mode 100644 include/crypto/cast6.h

-- 
1.7.2.5

