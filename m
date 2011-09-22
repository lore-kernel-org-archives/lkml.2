Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab1IVPvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:51:24 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:38228
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754Ab1IVPvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:51:22 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRXLA7-02-GC2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] PCI: Export ATS functions to modules
Date: Thu, 22 Sep 2011 17:49:09 +0200
Message-ID: <1316706551-16138-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com>
References: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the ATS function usable for modules. This
will be used by a modules implementing some advanced
AMD IOMMU features.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/ats.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index ae4bf87..5ceff3e 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -90,6 +90,7 @@ int pci_enable_ats(struct pci_dev *dev, int ps)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(pci_enable_ats);
 
 /**
  * pci_disable_ats - disable the ATS capability
@@ -120,6 +121,7 @@ void pci_disable_ats(struct pci_dev *dev)
 	if (!dev->is_physfn)
 		ats_free_one(dev);
 }
+EXPORT_SYMBOL_GPL(pci_disable_ats);
 
 /**
  * pci_ats_queue_depth - query the ATS Invalidate Queue Depth
@@ -153,3 +155,4 @@ int pci_ats_queue_depth(struct pci_dev *dev)
 	return PCI_ATS_CAP_QDEP(cap) ? PCI_ATS_CAP_QDEP(cap) :
 				       PCI_ATS_MAX_QDEP;
 }
+EXPORT_SYMBOL_GPL(pci_ats_queue_depth);
-- 
1.7.4.1


