Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2DNWnW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 18:43:22 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:48782 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab2DNWnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 18:43:21 -0400
Message-ID: <4F89FD7C.2060707@freemail.hu>
Date: Sun, 15 Apr 2012 00:43:08 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 apic: only compile local function if used
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 85.238.81.86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The local function io_apic_level_ack_pending() is only called from
io_apic_level_ack_pending(). The later function is only compiled
if CONFIG_GENERIC_PENDING_IRQ is defined. Use this define around
io_apic_level_ack_pending() function as well.

This will remove the following warning message during compiling
without CONFIG_GENERIC_PENDING_IRQ defined:
 * arch/x86/kernel/apic/io_apic.c:382: warning: ‘io_apic_level_ack_pending’ defined but not used

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..9b85009 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -379,6 +379,7 @@ static void __io_apic_modify(unsigned int apic, unsigned int reg, unsigned int v
 	writel(value, &io_apic->data);
 }

+#ifdef CONFIG_GENERIC_PENDING_IRQ
 static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
@@ -401,6 +402,7 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)

 	return false;
 }
+#endif

 union entry_union {
 	struct { u32 w1, w2; };

