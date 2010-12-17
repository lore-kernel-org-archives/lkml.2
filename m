Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0LQPeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:34:46 -0500
Received: from www.tglx.de ([62.245.132.106]:60800 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab0LQPen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:34:43 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org, dirk.brandewie@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 09/15] x86/dtb: Add generic bus probe
Date: Fri, 17 Dec 2010 16:33:47 +0100
Message-Id: <1292600033-12271-10-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now we probe these busses and we change is to board dependent probes
once we have to.

Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/kernel/prom.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index a449dc6..6eddafd 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -105,6 +105,25 @@ void __init add_dtb(u64 data)
 	initial_dtb = data + offsetof(struct setup_data, data);
 }
 
+/*
+ * CE4100 ids. Will be moved to machine_device_initcall() once we have it.
+ */
+static struct of_device_id __initdata ce4100_ids[] = {
+	{ .type = "soc", },
+	{ .compatible = "isa", },
+	{ .compatible = "pci", },
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
 static int x86_of_pci_irq_enable(struct pci_dev *dev)
 {
 	struct of_irq oirq;
-- 
1.7.3.2

