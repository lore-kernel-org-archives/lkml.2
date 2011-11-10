Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380Ab1KJAIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:08:36 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43473
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933338Ab1KJAIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:08:34 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Michael Neuling <mikey@neuling.org>
Subject: [RFC PATCH 05/17] powerpc/e500: Remove unused "default e500" from CPU table
Date: Wed,  9 Nov 2011 19:07:03 -0500
Message-Id: <1320883635-17194-6-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the 3 "e500" variants are generally incompatible with each other,
(32bit-spe, 32bit-classic-fpu, 64bit-classic-fpu), there is no such
thing as a "default e500" processor.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/kernel/cputable.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index edae5bb..e35f4fb 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -1992,22 +1992,6 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.machine_check		= machine_check_e500mc,
 		.platform		= "ppce5500",
 	},
-#ifdef CONFIG_PPC32
-	{	/* default match */
-		.pvr_mask		= 0x00000000,
-		.pvr_value		= 0x00000000,
-		.cpu_name		= "(generic E500 PPC)",
-		.cpu_features		= CPU_FTRS_E500,
-		.cpu_user_features	= COMMON_USER_BOOKE |
-			PPC_FEATURE_HAS_SPE_COMP |
-			PPC_FEATURE_HAS_EFP_SINGLE_COMP,
-		.mmu_features		= MMU_FTR_TYPE_FSL_E,
-		.icache_bsize		= 32,
-		.dcache_bsize		= 32,
-		.machine_check		= machine_check_e500,
-		.platform		= "powerpc",
-	}
-#endif /* CONFIG_PPC32 */
 #endif /* CONFIG_E500 */
 
 #ifdef CONFIG_PPC_A2
-- 
1.7.2.5

