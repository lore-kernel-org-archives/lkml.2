Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab1KJAJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:09:32 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43642
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933493Ab1KJAJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:09:18 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Subject: [RFC PATCH 17/17] powerpc/e500: Finally remove "CONFIG_E500"
Date: Wed,  9 Nov 2011 19:07:15 -0500
Message-Id: <1320883635-17194-18-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ambiguous config option is now only present as a Kconfig stub.
Remove it and fix up the users.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/platforms/Kconfig.cputype |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 22df19d..d4faa6f 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -32,14 +32,16 @@ config FSL_E200
 config FSL_E500_V1_V2
 	bool "Freescale e500v1/e500v2 (also known as MPC85xx)"
 	select PHYS_64BIT_SUPPORTED
-	select E500
+	select FSL_EMB_PERFMON
+	select PPC_FSL_BOOK3E
 	select PPC_85xx
 
 config FSL_E500MC
 	bool "Freescale e500mc (also e5500 in 32-bit mode)"
 	select PHYS_64BIT_SUPPORTED
 	select PPC_FPU
-	select E500
+	select FSL_EMB_PERFMON
+	select PPC_FSL_BOOK3E
 	select PPC_85xx
 
 config PPC_8xx
@@ -146,12 +148,8 @@ config PPC_85xx
 
 config FSL_E5500
 	bool
-	select E500
-
-config E500
 	select FSL_EMB_PERFMON
 	select PPC_FSL_BOOK3E
-	bool
 
 config PPC_FPU
 	bool
-- 
1.7.2.5

