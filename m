Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0LQPeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:34:37 -0500
Received: from www.tglx.de ([62.245.132.106]:60723 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318Ab0LQPef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:34:35 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org, dirk.brandewie@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 06/15] x86/dtb: add support hpet
Date: Fri, 17 Dec 2010 16:33:44 +0100
Message-Id: <1292600033-12271-7-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set hpet_address based on information provied form DTB

Cc: devicetree-discuss@lists.ozlabs.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/prom.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index 9cbb52b..40ad8c0 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -10,6 +10,7 @@
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
+#include <asm/hpet.h>
 #include <asm/irq_controller.h>
 #include <asm/io_apic.h>
 
@@ -101,6 +102,23 @@ void __init add_dtb(u64 data)
 	initial_dtb = data + offsetof(struct setup_data, data);
 }
 
+static void __init dtb_setup_hpet(void)
+{
+	struct device_node *dn;
+	struct resource r;
+	int ret;
+
+	dn = of_find_compatible_node(NULL, NULL, "intel,hpet");
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
@@ -212,5 +230,6 @@ void __init x86_dtb_get_config(unsigned int unused)
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 
 	unflatten_device_tree();
+	dtb_setup_hpet();
 	dtb_apic_setup();
 }
-- 
1.7.3.2

