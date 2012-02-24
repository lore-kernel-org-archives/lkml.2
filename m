Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2BXHsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:48:39 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38172 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2BXHra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:47:30 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/11] PCI: Use class for quirk for netmos class fixup
Date: Thu, 23 Feb 2012 23:46:56 -0800
Message-Id: <1330069619-14446-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
References: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F474091.006E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index a860812..03e455a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1878,8 +1878,7 @@ static void __devinit quirk_netmos(struct pci_dev *dev)
 	case PCI_DEVICE_ID_NETMOS_9745:
 	case PCI_DEVICE_ID_NETMOS_9845:
 	case PCI_DEVICE_ID_NETMOS_9855:
-		if ((dev->class >> 8) == PCI_CLASS_COMMUNICATION_SERIAL &&
-		    num_parallel) {
+		if (num_parallel) {
 			dev_info(&dev->dev, "Netmos %04x (%u parallel, "
 				"%u serial); changing class SERIAL to OTHER "
 				"(use parport_serial)\n",
@@ -1889,7 +1888,8 @@ static void __devinit quirk_netmos(struct pci_dev *dev)
 		}
 	}
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NETMOS, PCI_ANY_ID, quirk_netmos);
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_NETMOS, PCI_ANY_ID,
+			 PCI_CLASS_COMMUNICATION_SERIAL, 8, quirk_netmos);
 
 static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
 {
-- 
1.7.7

