Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab1CDL7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:59:08 -0500
Received: from server103.greatnet.de ([83.133.97.6]:34018 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498Ab1CDL64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:58:56 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, gorcunov@gmail.com,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCHv2 3/7] x86: make apic_disable() static and init
Date: Fri,  4 Mar 2011 12:58:39 +0100
Message-Id: <1299239923-7092-3-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299239923-7092-1-git-send-email-henne@nachtwindheim.de>
References: <1299239923-7092-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic_disable() is only used in apic.c, so it does not
need the prototype which was introduced in
commit 08306ce61d6848e6fbf74fa4cc693c3fb29e943f .
Therefore we remove it from the header and make it static.

It is also called only from init code, so we mark it as such.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/apic.h |    2 --
 arch/x86/kernel/apic/apic.c |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index dbd558c..b3f444d 100644
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
index b62723c..4a65366 100644
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

