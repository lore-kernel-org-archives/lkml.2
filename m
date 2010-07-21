Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab0GVNIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:08:01 -0400
Received: from mxout1.idt.com ([157.165.5.25]:43495 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0GVNH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:07:57 -0400
X-Greylist: delayed 957 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jul 2010 09:07:57 EDT
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH] RapidIO,powerpc/85xx: remove MCSR_MASK in fsl_rio
Date: Wed, 21 Jul 2010 12:46:50 -0400
Message-Id: <1279730810-24926-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compile problem caused by MCSR_MASK removal from book-E definitions.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Matt Porter <mporter@kernel.crashing.org>
---
 arch/powerpc/sysdev/fsl_rio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 30e1626..c58df58 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -245,7 +245,7 @@ static int (*saved_mcheck_exception)(struct pt_regs *regs);
 static int fsl_rio_mcheck_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *entry = NULL;
-	unsigned long reason = (mfspr(SPRN_MCSR) & MCSR_MASK);
+	unsigned long reason = mfspr(SPRN_MCSR);
 
 	if (reason & MCSR_BUS_RBERR) {
 		reason = in_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR));
-- 
1.7.0.5

