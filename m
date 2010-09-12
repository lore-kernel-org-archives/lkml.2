Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0ILFLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:11:11 -0400
Received: from mail.perches.com ([173.55.12.10]:1747 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab0ILFLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:11:06 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] arch/mips: Remove pr_<level> uses of KERN_<level>
Date: Sat, 11 Sep 2010 22:10:52 -0700
Message-Id: <c3b4d799ec7338f31638d90bef10d3d89208ae89.1284267142.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mips/kernel/irq-gic.c  |    2 +-
 arch/mips/pci/pci-rc32434.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index b181f2f..8d8a6ba 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -131,7 +131,7 @@ static int gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	int		i;
 
 	irq -= _irqbase;
-	pr_debug(KERN_DEBUG "%s(%d) called\n", __func__, irq);
+	pr_debug("%s(%d) called\n", __func__, irq);
 	cpumask_and(&tmp, cpumask, cpu_online_mask);
 	if (cpus_empty(tmp))
 		return -1;
diff --git a/arch/mips/pci/pci-rc32434.c b/arch/mips/pci/pci-rc32434.c
index 71f7d27..f31218e 100644
--- a/arch/mips/pci/pci-rc32434.c
+++ b/arch/mips/pci/pci-rc32434.c
@@ -118,7 +118,7 @@ static int __init rc32434_pcibridge_init(void)
 	if (!((pcicvalue == PCIM_H_EA) ||
 	      (pcicvalue == PCIM_H_IA_FIX) ||
 	      (pcicvalue == PCIM_H_IA_RR))) {
-		pr_err(KERN_ERR "PCI init error!!!\n");
+		pr_err("PCI init error!!!\n");
 		/* Not in Host Mode, return ERROR */
 		return -1;
 	}
-- 
1.7.3.rc1

