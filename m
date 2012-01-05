Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab2AEAsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:48:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59504 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab2AEAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:48:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/5] xen/pciback: Expand the warning message to include domain id.
Date: Wed,  4 Jan 2012 19:46:42 -0500
Message-Id: <1325724403-29642-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F04F353.001A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a PCI device is transferred to another domain and it is still
in usage (from the internal perspective), mention which other
domain is using it to aid in debugging.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/xenbus.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 474d52e..fa130bd 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -243,8 +243,10 @@ static int xen_pcibk_export_device(struct xen_pcibk_device *pdev,
 	dev_dbg(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
 	if (xen_register_device_domain_owner(dev,
 					     pdev->xdev->otherend_id) != 0) {
-		dev_err(&dev->dev, "device has been assigned to another " \
-			"domain! Over-writting the ownership, but beware.\n");
+		int other_domain = xen_find_device_domain_owner(dev);
+		dev_err(&dev->dev, "device has been assigned to %d " \
+			"domain! Over-writting the ownership, but beware.\n",
+			other_domain);
 		xen_unregister_device_domain_owner(dev);
 		xen_register_device_domain_owner(dev, pdev->xdev->otherend_id);
 	}
-- 
1.7.7.4

