Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab1CCUFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:05:14 -0500
Received: from server103.greatnet.de ([83.133.97.6]:55210 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab1CCUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:05:12 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 3/7] x86: make apic_disable() static and init
Date: Thu,  3 Mar 2011 21:04:57 +0100
Message-Id: <1299182701-8591-3-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic_disable() is only used in apic.c, so it does not
need the prototype which was introduced inc commit
08306ce61d6848e6fbf74fa4cc693c3fb29e943f .
Therefore we remove it from the header and make it static.

It is also called only from init code, so we mark it as such.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/apic.h |    2 --
 arch/x86/kernel/apic/apic.c |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index afe69e1..6d74dd37 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -220,7 +220,6 @@ extern void enable_IR_x2apic(void);
 
 extern int get_physical_broadcast(void);
 
-extern void apic_disable(void);
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
 extern void connect_bsp_APIC(void);
@@ -261,7 +260,6 @@ static inline void lapic_shutdown(void) { }
 #define local_apic_timer_c2_ok		1
 static inline void init_apic_mappings(void) { }
 static inline void disable_local_APIC(void) { }
-static inline void apic_disable(void) { }
 # define setup_boot_APIC_clock x86_init_noop
 # define setup_secondary_APIC_clock x86_init_noop
 #endif /* !CONFIG_X86_LOCAL_APIC */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 022afb9..5177aaa 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -248,7 +248,7 @@ static int modern_apic(void)
  * right after this call apic become NOOP driven
  * so apic->write/read doesn't do anything
  */
-void apic_disable(void)
+static void __init apic_disable(void)
 {
 	pr_info("APIC: switched to apic NOOP\n");
 	apic = &apic_noop;
-- 
1.7.2.3

