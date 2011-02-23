Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab1BWVwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:52:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:57107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab1BWVwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:52:11 -0500
Date: Wed, 23 Feb 2011 21:51:55 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1298405266-1624-9-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-9-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: dtb: Add generic bus probe
Message-ID: <tip-9079b35364e75ce6b968a179f861d2f819f33e61@git.kernel.org>
Git-Commit-ID: 9079b35364e75ce6b968a179f861d2f819f33e61
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 21:51:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9079b35364e75ce6b968a179f861d2f819f33e61
Gitweb:     http://git.kernel.org/tip/9079b35364e75ce6b968a179f861d2f819f33e61
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 22 Feb 2011 21:07:43 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Feb 2011 22:27:54 +0100

x86: dtb: Add generic bus probe

For now we probe these busses and we change this to board dependent
probes once we have to.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: sodaville@linutronix.de
Cc: devicetree-discuss@lists.ozlabs.org
LKML-Reference: <1298405266-1624-9-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/devicetree.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 7b57422..0bc83bf 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -103,6 +103,25 @@ void __init add_dtb(u64 data)
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
