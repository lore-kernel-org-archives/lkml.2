Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1BWMJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:09:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:56618 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab1BWMJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:09:05 -0500
Date: Wed, 23 Feb 2011 12:08:34 GMT
From: tip-bot for Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
In-Reply-To: <1298385487-4708-4-git-send-email-henne@nachtwindheim.de>
References: <1298385487-4708-4-git-send-email-henne@nachtwindheim.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Add dummy functions for compiling without IOAPIC
Message-ID: <tip-7d0f1926131cf79aa5998d463bf1582156e7b41e@git.kernel.org>
Git-Commit-ID: 7d0f1926131cf79aa5998d463bf1582156e7b41e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:08:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d0f1926131cf79aa5998d463bf1582156e7b41e
Gitweb:     http://git.kernel.org/tip/7d0f1926131cf79aa5998d463bf1582156e7b41e
Author:     Henrik Kretzschmar <henne@nachtwindheim.de>
AuthorDate: Tue, 22 Feb 2011 15:38:06 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:38:46 +0100

x86: Add dummy functions for compiling without IOAPIC

This patch adds IOAPIC dummy functions for compilation
with local APIC, but without IOAPIC.

The local variable ioapic_entries in enable_IR_x2apic()
does not need initialization anymore, since the dummy
returns NULL.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
LKML-Reference: <1298385487-4708-4-git-send-email-henne@nachtwindheim.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io_apic.h |   18 ++++++++++++++++++
 arch/x86/kernel/apic/apic.c    |    2 +-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0be2f27..56dcf08 100644
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
+static inline void free_ioapic_entries(struct IO_APIC_route_entry **ent) { }
+static inline int save_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+{
+	return -ENOMEM;
+}
+
+static inline void mask_IO_APIC_setup(struct IO_APIC_route_entry **ent) { }
+static inline int restore_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+{
+	return -ENOMEM;
+}
+
 static inline void mp_save_irq(struct mpc_intsrc *m) { };
 static inline void disable_ioapic_support(void) { }
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 96e6809..f0e0798 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1449,7 +1449,7 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
+	struct IO_APIC_route_entry **ioapic_entries;
 	int ret, x2apic_enabled = 0;
 	int dmar_table_init_ret;
 
