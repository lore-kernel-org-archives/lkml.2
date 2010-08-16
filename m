Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0HPIcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:32:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57857 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0HPIcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:32:04 -0400
From: Michal Simek <monstr@monstr.eu>
To: glikely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] microblaze: Fix of: eliminate of_device->node and dev_archdata->{of,prom}_node
Date: Mon, 16 Aug 2010 10:31:54 +0200
Message-Id: <1281947514-25319-3-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1281947514-25319-2-git-send-email-monstr@monstr.eu>
References: <1281947514-25319-1-git-send-email-monstr@monstr.eu>
 <1281947514-25319-2-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 58f9b0b02414062eaff46716bc04b47d7e79add5 should
contain this fix too.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/pci/pci-common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 62f403b..466d410 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1062,7 +1062,7 @@ void __devinit pcibios_setup_bus_devices(struct pci_bus *bus)
 		struct dev_archdata *sd = &dev->dev.archdata;
 
 		/* Setup OF node pointer in archdata */
-		sd->of_node = pci_device_to_OF_node(dev);
+		dev->dev.of_node = pci_device_to_OF_node(dev);
 
 		/* Fixup NUMA node as it may not be setup yet by the generic
 		 * code and is needed by the DMA init
-- 
1.5.5.6

