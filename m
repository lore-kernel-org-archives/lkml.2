Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1CCUGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:06:30 -0500
Received: from server103.greatnet.de ([83.133.97.6]:55204 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630Ab1CCUFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:05:11 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 2/7] x86: make some apic symbols init
Date: Thu,  3 Mar 2011 21:04:56 +0100
Message-Id: <1299182701-8591-2-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic_force_enable(), apic_verify() and the variable
force_enable_local_apic are only used by init code
and now get marked as such.

Global __initdata variables may better be initialized,
since they are in the data section and not in the bss.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/apic.h |    2 +-
 arch/x86/kernel/apic/apic.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index dbd558c..afe69e1 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -240,7 +240,7 @@ extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
 extern int APIC_init_uniprocessor(void);
 extern void enable_NMI_through_LVT0(void);
-extern int apic_force_enable(unsigned long addr);
+extern int apic_force_enable(unsigned long addr) __init;
 
 /*
  * On 32bit this is mach-xxx local
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6c464a3..022afb9 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -93,7 +93,7 @@ DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
  *
  * +1=force-enable
  */
-static int force_enable_local_apic;
+static int force_enable_local_apic __initdata = 0;
 /*
  * APIC command line parameters
  */
@@ -1560,7 +1560,7 @@ static int __init detect_init_APIC(void)
 }
 #else
 
-static int apic_verify(void)
+static int __init apic_verify(void)
 {
 	u32 features, h, l;
 
@@ -1585,7 +1585,7 @@ static int apic_verify(void)
 	return 0;
 }
 
-int apic_force_enable(unsigned long addr)
+int __init apic_force_enable(unsigned long addr)
 {
 	u32 h, l;
 
-- 
1.7.2.3

