Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2GESoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:44:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2GESoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:44:00 -0400
Date: Thu, 5 Jul 2012 20:43:58 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: twofish-avx - remove useless instruction
Message-ID: <20120705184358.GE2091@kronos.redsun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:hFhhfbld1dFuIxEt2YJp0lvqch1P5LybvQ27oSBfBWo
 SgvsrO5hWWWXCiFGqvd7aaOk9no84SpC3I1XRJBklT/P1aG5By
 STyx9p59vcvkMmDl4SfPpK1ejVzq/OwHQFHIrYuQYPD4+5gUIY
 CHmmM5ZOnlXxxH8B4g2pAvcJqS3lreNDbYny48z6S+0gNCkpQk
 cODczI84kb6DNenUgDaAK2FQf8Rsqvodd1P3lf5H5sZXGfYI0U
 1Nw9FmY0fr/EqH5/89c57NqX/onj3UBYZO7nA/Y17m172u7aB8
 TMHPjJpuXJrWmqccR+fuyuFOWb+R+s7yFUwvPHao/91NPjtubi
 vWU2Yek1bR+VmGW/vxxU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register %rdx is written, but never read till the end of the encryption
routine. Therefore let's delete the useless instruction.

Signed-off-by: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index fc31b89..35f4557 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -243,7 +243,6 @@ __twofish_enc_blk_8way:
 	popq %rbx;
 
 	leaq (4*4*4)(%rsi), %rax;
-	leaq (4*4*4)(%rax), %rdx;
 
 	testb %cl, %cl;
 	jnz __enc_xor8;
-- 
1.7.2.5

