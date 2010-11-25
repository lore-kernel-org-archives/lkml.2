Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0KYRoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:44:06 -0500
Received: from www.tglx.de ([62.245.132.106]:50939 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab0KYRoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:44:01 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 08/11] x86/dtb: Add generic bus probe
Date: Thu, 25 Nov 2010 18:39:58 +0100
Message-Id: <1290706801-7323-9-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now we probe these busses and we change is to board dependent probes
once we have to.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/kernel/prom.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index c02777d..bbd6064 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -102,6 +102,25 @@ void __init add_dtb(u64 data)
 				offsetof(struct setup_data, data));
 }
 
+/*
+ * CE4100 ids. Will be moved to machine_device_initcall() once we have it.
+ */
+static struct of_device_id __initdata ce4100_ids[] = {
+	{ .type = "soc", },
+	{ .compatible = "soc", },
+	{ .compatible = "simple-bus", },
+	{},
+};
+
+static int __init add_bus_probe(void)
+{
+	if (!initial_boot_params)
+		return 0;
+
+	return of_platform_bus_probe(NULL, ce4100_ids, NULL);
+}
+module_init(add_bus_probe);
+
 static int of_irq_map_pci(struct pci_dev *dev, struct of_irq *oirq)
 {
 	struct device_node *node;
-- 
1.7.3.2

