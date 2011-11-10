Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1KJAI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:08:27 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43450
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756848Ab1KJAIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:08:25 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Shaohui Xie <b21989@freescale.com>, Liu Gang <Gang.Liu@freescale.com>
Subject: [RFC PATCH 03/17] fsl_rio: Remove FreeScale e500 conditionals
Date: Wed,  9 Nov 2011 19:07:01 -0500
Message-Id: <1320883635-17194-4-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "CONFIG_E500" conditional should be unnecessary.  The fsl_rio
hardware is only present on MPC85xx (e500/e500mc) anyways, although it
should build everywhere for better compile-test coverage.

The conditionally-defined fsl_rio_mcheck_exception() function lost its
two e500-specific constants in commit 82a9a4809f:
  powerpc/e500: fix breakage with fsl_rio_mcheck_exception

Specifically, the references to SPRN_MCSR and MCSR_BUS_RBERR were moved
to an e500-specific file.

This patch just removes the unnecessary #ifdef, as the entire file is
effectively dead code on non-e500 platforms anyways.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index de170fd..783e25c 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -281,7 +281,6 @@ struct rio_priv {
 
 static void __iomem *rio_regs_win;
 
-#ifdef CONFIG_E500
 int fsl_rio_mcheck_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *entry;
@@ -308,7 +307,6 @@ int fsl_rio_mcheck_exception(struct pt_regs *regs)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fsl_rio_mcheck_exception);
-#endif
 
 /**
  * fsl_rio_doorbell_send - Send a MPC85xx doorbell message
-- 
1.7.2.5

