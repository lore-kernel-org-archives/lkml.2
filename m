Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab0KDObo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:31:44 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:45710 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0KDObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:31:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/1] PCI: xen-pcifront, fix PCI reference leak
Date: Thu,  4 Nov 2010 15:31:30 +0100
Message-Id: <1288881090-27335-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that when pdev is found and has no driver a reference is
leaked in pcifront_common_process. So add pci_dev_put there. For the
pdev == NULL case, pci_dev_put(NULL) is fine.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/xen-pcifront.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index a87c498..f9ffc05 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -578,6 +578,7 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 	if (!pcidev || !pcidev->driver) {
 		dev_err(&pcidev->dev,
 			"device or driver is NULL\n");
+		pci_dev_put(pcidev);
 		return result;
 	}
 	pdrv = pcidev->driver;
-- 
1.7.3.1


