Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2ILPqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:46:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39087 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab2ILPqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:46:15 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Stephen Warren <swarren@nvidia.com>,
        David Howells <dhowells@redhat.com>, Nicolas Pitre <nico@linaro.org>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH] ARM: fix warning on uninitialized offset.un
Date: Wed, 12 Sep 2012 11:46:04 -0400
Message-ID: <1347464765-24167-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following warning:

arch/arm/mm/alignment.c: In function 'do_alignment':
arch/arm/mm/alignment.c:327:15: warning: 'offset.un' may be used uninitialized in this function [-Wmaybe-uninitialized]
arch/arm/mm/alignment.c:749:21: note: 'offset.un' was declared here

The fix is to promote the initialization of offset into do_alignment().

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mm/alignment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 9107231..d15877c 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -699,7 +699,6 @@ do_alignment_t32_to_handler(unsigned long *pinstr, struct pt_regs *regs,
 	unsigned long instr = *pinstr;
 	u16 tinst1 = (instr >> 16) & 0xffff;
 	u16 tinst2 = instr & 0xffff;
-	poffset->un = 0;
 
 	switch (tinst1 & 0xffe0) {
 	/* A6.3.5 Load/Store multiple */
@@ -795,6 +794,7 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
  fixup:
 
 	regs->ARM_pc += isize;
+	offset.un = 0;
 
 	switch (CODING_BITS(instr)) {
 	case 0x00000000:	/* 3.13.4 load/store instruction extensions */
-- 
1.7.9.5

