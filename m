Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab0KLViS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:38:18 -0500
Received: from mail.perches.com ([173.55.12.10]:4995 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174Ab0KLViL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:11 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] arch/mips: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:37:52 -0800
Message-Id: <a8e243510ee279b590183aa48f61d7b39cafb37d.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mips/txx9/generic/pci.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/mips/txx9/generic/pci.c b/arch/mips/txx9/generic/pci.c
index 9a0be81..c609e7b 100644
--- a/arch/mips/txx9/generic/pci.c
+++ b/arch/mips/txx9/generic/pci.c
@@ -213,11 +213,8 @@ txx9_alloc_pci_controller(struct pci_controller *pcic,
 
 	pcic->mem_offset = 0;	/* busaddr == physaddr */
 
-	printk(KERN_INFO "PCI: IO 0x%08llx-0x%08llx MEM 0x%08llx-0x%08llx\n",
-	       (unsigned long long)pcic->mem_resource[1].start,
-	       (unsigned long long)pcic->mem_resource[1].end,
-	       (unsigned long long)pcic->mem_resource[0].start,
-	       (unsigned long long)pcic->mem_resource[0].end);
+	printk(KERN_INFO "PCI: IO %pR MEM %pR\n",
+	       &pcic->mem_resource[1], &pcic->mem_resource[0]);
 
 	/* register_pci_controller() will request MEM resource */
 	release_resource(&pcic->mem_resource[0]);
-- 
1.7.3.1.g432b3.dirty

