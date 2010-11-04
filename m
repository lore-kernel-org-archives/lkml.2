Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0KDSqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:46:05 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:53177 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab0KDSqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:46:02 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Milton Miller <miltonm@bga.com>
Subject: [PATCH 1/1] PCI: xen-pcifront, fix potential NULL dereference
Date: Thu,  4 Nov 2010 19:45:53 +0100
Message-Id: <1288896353-32620-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milton spotted that we dereference NULL in one fail path in
pcifront_common_process. Fix that by using different device to print
out an error.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Milton Miller <miltonm@bga.com>
---
 drivers/pci/xen-pcifront.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index f9ffc05..1a56067 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -576,8 +576,7 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 
 	pcidev = pci_get_bus_and_slot(bus, devfn);
 	if (!pcidev || !pcidev->driver) {
-		dev_err(&pcidev->dev,
-			"device or driver is NULL\n");
+		dev_err(&pdev->xdev->dev, "AER device or driver is NULL\n");
 		pci_dev_put(pcidev);
 		return result;
 	}
-- 
1.7.3.1


