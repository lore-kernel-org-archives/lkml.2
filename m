Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab0KRTWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:22:42 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49840 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab0KRTWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:22:39 -0500
X-Sieve: CMU Sieve 2.3
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479
X-Spam-TokenSummary: Bayes not run.
X-Spam-Relay-Country: 
From: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Sonny Rao <sonnyrao@linux.vnet.ibm.com>, Milton Miller <miltonm@bga.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: minor cleanups for machdep.h
Date: Thu, 18 Nov 2010 04:39:23 -0600
Message-Id: <1290076764-3280-1-git-send-email-sonnyrao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
X-Xagent-From: sonnyrao@linux.vnet.ibm.com
X-Xagent-To: sonnyrao@linux.vnet.ibm.com
X-Xagent-Gateway: bldgate.vnet.ibm.com (XAGENTU3 at BLDGATE)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove stale declaration of setup_pci_ptrs, aparently from ppc before 2.4.0

remove #ifdef around struct existance delcaration

fix spelling of linear

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/machdep.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index d045b01..8433d36 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -27,9 +27,7 @@ struct iommu_table;
 struct rtc_time;
 struct file;
 struct pci_controller;
-#ifdef CONFIG_KEXEC
 struct kimage;
-#endif

 #ifdef CONFIG_SMP
 struct smp_ops_t {
@@ -72,7 +70,7 @@ struct machdep_calls {
 					     int psize, int ssize);
 	void		(*flush_hash_range)(unsigned long number, int local);

-	/* special for kexec, to be called in real mode, linar mapping is
+	/* special for kexec, to be called in real mode, linear mapping is
 	 * destroyed as well */
 	void		(*hpte_clear_all)(void);

@@ -324,8 +322,6 @@ extern sys_ctrler_t sys_ctrler;

 #endif /* CONFIG_PPC_PMAC */

-extern void setup_pci_ptrs(void);
-
 #ifdef CONFIG_SMP
 /* Poor default implementations */
 extern void __devinit smp_generic_give_timebase(void);
-- 
1.5.6.5

