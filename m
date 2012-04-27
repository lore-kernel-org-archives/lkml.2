Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2D0PVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:21:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2D0PVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:21:49 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 12/19] PCI: clean up all resources in error handling path in zt5550_hc_init_one()
Date: Fri, 27 Apr 2012 23:16:53 +0800
Message-Id: <1335539820-11232-13-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Clean up all resources in error handling path in function zt5550_hc_init_one().

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/cpcihp_zt5550.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
index 6bf8d2a..8a6f968 100644
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -257,11 +257,13 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	if(status != 0) {
 		err("could not started cPCI hotplug system");
 		cpci_hp_unregister_bus(bus0);
-		goto init_register_error;
+		goto init_start_error;
 	}
 	dbg("started cpci hp system");
 
 	return 0;
+init_start_error:
+	cpci_hp_unregister_bus(bus0);
 init_register_error:
 	cpci_hp_unregister_controller(&zt5550_hpc);
 init_hc_error:
-- 
1.7.5.4

