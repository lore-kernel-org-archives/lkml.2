Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2CKRxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:53:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55385 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab2CKRxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:53:25 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Ashok Raj <ashok.raj@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenkeping@huawei.com
Subject: [PATCH 3/5] Fix an access-after-free issue in function pci_stop_and_remove_bus()
Date: Mon, 12 Mar 2012 01:48:27 +0800
Message-Id: <1331488109-13466-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
References: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pci_stop_and_remove_bus() is called to remove a pci root bus,
the host_bridge structure may have already been freed after returning
from pci_remove_bus(), so don't access the structure any more.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/remove.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 75b0092..25f368e 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -194,9 +194,6 @@ void pci_stop_and_remove_bus(struct pci_bus *bus)
 
 	pci_remove_bus(bus);
 
-	if (host_bridge)
-		host_bridge->bus = NULL;
-
 	if (pci_bridge)
 		pci_bridge->subordinate = NULL;
 }
-- 
1.7.5.4

