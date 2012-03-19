Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031339Ab2CSFwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:52:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25515 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162025Ab2CSFtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:52 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 16/26] PCI: Use for_each_res pci release release
Date: Sun, 18 Mar 2012 22:48:39 -0700
Message-Id: <1332136129-14010-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F66C8FE.002A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 18efb31..7dfe507 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -6,15 +6,14 @@
 static void pci_free_resources(struct pci_dev *dev)
 {
 	int i;
+	struct resource *res;
 
  	msi_remove_pci_irq_vectors(dev);
 
 	pci_cleanup_rom(dev);
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		struct resource *res = dev->resource + i;
+	for_each_pci_dev_all_resource(dev, res, i)
 		if (res->parent)
 			release_resource(res);
-	}
 }
 
 static void pci_stop_dev(struct pci_dev *dev)
-- 
1.7.7

