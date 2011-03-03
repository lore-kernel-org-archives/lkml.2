Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab1CCUFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:05:55 -0500
Received: from server103.greatnet.de ([83.133.97.6]:55220 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab1CCUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:05:13 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 4/7] x86: remove enable_NMI_through_LVT0() entirely
Date: Thu,  3 Mar 2011 21:04:58 +0100
Message-Id: <1299182701-8591-4-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is not used anywhere in the tree,
since commit 072b198a4ad48bd722ec6d203d65422a4698eae7
so it can be removed.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/apic.h |    1 -
 arch/x86/kernel/apic/apic.c |   17 -----------------
 2 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 6d74dd37..f17d7c5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -238,7 +238,6 @@ void register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
-extern void enable_NMI_through_LVT0(void);
 extern int apic_force_enable(unsigned long addr) __init;
 
 /*
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 5177aaa..a0e9c1f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -292,23 +292,6 @@ u64 native_apic_icr_read(void)
 	return icr1 | ((u64)icr2 << 32);
 }
 
-/**
- * enable_NMI_through_LVT0 - enable NMI through local vector table 0
- */
-void __cpuinit enable_NMI_through_LVT0(void)
-{
-	unsigned int v;
-
-	/* unmask and set to NMI */
-	v = APIC_DM_NMI;
-
-	/* Level triggered for 82489DX (32bit mode) */
-	if (!lapic_is_integrated())
-		v |= APIC_LVT_LEVEL_TRIGGER;
-
-	apic_write(APIC_LVT0, v);
-}
-
 #ifdef CONFIG_X86_32
 /**
  * get_physical_broadcast - Get number of physical broadcast IDs
-- 
1.7.2.3

