Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1BDKWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:22:13 -0500
Received: from www.tglx.de ([62.245.132.106]:60140 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab1BDKWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:22:08 -0500
Date: Fri, 4 Feb 2011 11:21:52 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH v2 TIP 09/14] x86/dtb: Add generic bus probe
Message-ID: <20110204102152.GA7231@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-10-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1295843342-1122-10-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now we probe these busses and we change is to board dependent probes
once we have to.

Cc: devicetree-discuss@lists.ozlabs.org
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---

 renamed -immr to -cp

 arch/x86/kernel/prom.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index 8525ca0..3eaab43 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -102,6 +102,25 @@ void __init add_dtb(u64 data)
 	initial_dtb = data + offsetof(struct setup_data, data);
 }
 
+/*
+ * CE4100 ids. Will be moved to machine_device_initcall() once we have it.
+ */
+static struct of_device_id __initdata ce4100_ids[] = {
+	{ .compatible = "intel,ce4100-cp", },
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
 #ifdef CONFIG_PCI
 static int x86_of_pci_irq_enable(struct pci_dev *dev)
 {
-- 
1.7.3.2

