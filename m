Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1I2TxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:53:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36350 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab1I2TxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:53:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/9] xen/pciback: Do not dereference psdev during printk when it is NULL.
Date: Thu, 29 Sep 2011 15:52:43 -0400
Message-Id: <1317325971-21603-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090206.4E84CC9D.00C4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. instead use printk(.. facility.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index aec214a..32d6891 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -514,9 +514,11 @@ static void kill_domain_by_device(struct pcistub_device *psdev)
 	int err;
 	char nodename[PCI_NODENAME_MAX];
 
-	if (!psdev)
-		dev_err(&psdev->dev->dev,
-			"device is NULL when do AER recovery/kill_domain\n");
+	if (!psdev) {
+		printk(KERN_ERR DRV_NAME
+			":device is NULL when do AER recovery/kill_domain\n");
+		return;
+	}
 	snprintf(nodename, PCI_NODENAME_MAX, "/local/domain/0/backend/pci/%d/0",
 		psdev->pdev->xdev->otherend_id);
 	nodename[strlen(nodename)] = '\0';
-- 
1.7.4.1

