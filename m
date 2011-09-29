Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1I2TxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:53:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36348 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1I2TxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:53:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/9] xen/pciback: Check if the device is found instead of blindly assuming so.
Date: Thu, 29 Sep 2011 15:52:45 -0400
Message-Id: <1317325971-21603-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E84CC9D.00AA:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just in case it is not found, don't try to dereference it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index d985b65..55086e9 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -222,6 +222,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	}
 
 	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	if (!found_psdev)
+		return;
 
 	/*hold this lock for avoiding breaking link between
 	* pcistub and xen_pcibk when AER is in processing
-- 
1.7.4.1

