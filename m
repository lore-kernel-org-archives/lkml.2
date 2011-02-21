Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1BUI7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 03:59:41 -0500
Received: from server103.greatnet.de ([83.133.97.6]:44059 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab1BUI7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 03:59:35 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 4/5] x86: add dummy functions for compiling without IOAPIC
Date: Mon, 21 Feb 2011 09:59:23 +0100
Message-Id: <1298278764-3320-4-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298278764-3320-1-git-send-email-henne@nachtwindheim.de>
References: <1298278764-3320-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds IOAPIC dummy functions for compilation
with local APIC, but without IOAPIC.

The local variable ioapic_entries in enable_IR_x2apic()
does not need initialization anymore, since the dummy
returns NULL.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/io_apic.h |   18 ++++++++++++++++++
 arch/x86/kernel/apic/apic.c    |    2 +-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0be2f27..3140570 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -190,6 +190,24 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr) { return 0; }
+
+static inline struct IO_APIC_route_entry **alloc_ioapic_entries(void)
+{
+	return NULL;
+}
+
+static inline void free_ioapic_entries(struct IO_APIC_route_entry **) { }
+static inline int save_IO_APIC_setup(struct IO_APIC_route_entry **)
+{
+	return -ENOMEM;
+}
+
+static inline void mask_IO_APIC_setup(struct IO_APIC_route_entry **) { }
+static inline int restore_IO_APIC_setup(struct IO_APIC_route_entry **)
+{
+	return -ENOMEM;
+}
+
 static inline void mp_save_irq(struct mpc_intsrc *m) { };
 static inline void disable_ioapic_support(void) { }
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6fd5c33..562a832 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1471,7 +1471,7 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
+	struct IO_APIC_route_entry **ioapic_entries;
 	int ret, x2apic_enabled = 0;
 	int dmar_table_init_ret;
 
-- 
1.7.2.3

