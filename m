Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1I0N7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:59:23 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:41026
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469Ab1I0N7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:59:20 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LS6PFH-02-EBH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/4] PCI: Export ATS functions to modules
Date: Tue, 27 Sep 2011 15:57:14 +0200
Message-ID: <1317131836-11822-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
References: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the ATS functions usable for modules.
They will be used by a module implementing some advanced
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


