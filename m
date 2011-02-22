Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1BVUJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:09:31 -0500
Received: from www.tglx.de ([62.245.132.106]:38546 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab1BVUIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:08:23 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 06/11] x86/dtb: add support hpet
Date: Tue, 22 Feb 2011 21:07:41 +0100
Message-Id: <1298405266-1624-7-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set hpet_address based on information provied form DTB

Cc: devicetree-discuss@lists.ozlabs.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/devicetree.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 72cc3e2..8d7a2eb 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -11,6 +11,7 @@
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
+#include <asm/hpet.h>
 #include <asm/irq_controller.h>
 #include <asm/apic.h>
 
@@ -99,6 +100,23 @@ void __init add_dtb(u64 data)
 	initial_dtb = data + offsetof(struct setup_data, data);
 }
 
+static void __init dtb_setup_hpet(void)
+{
+	struct device_node *dn;
+	struct resource r;
+	int ret;
+
+	dn = of_find_compatible_node(NULL, NULL, "intel,ce4100-hpet");
+	if (!dn)
+		return;
+	ret = of_address_to_resource(dn, 0, &r);
+	if (ret) {
+		WARN_ON(1);
+		return;
+	}
+	hpet_address = r.start;
+}
+
 static void __init dtb_lapic_setup(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -199,5 +217,6 @@ void __init x86_dtb_get_config(unsigned int unused)
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 
 	unflatten_device_tree();
+	dtb_setup_hpet();
 	dtb_apic_setup();
 }
-- 
1.7.4

