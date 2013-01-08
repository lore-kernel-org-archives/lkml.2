Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3AHVIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab3AHVI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605178"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 21/21] mei: move work initialization to mei_device_init
Date: Tue,  8 Jan 2013 23:07:32 +0200
Message-Id: <1357679252-12958-22-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let mei_device_init initialize all the software constructs.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c |    4 ++++
 drivers/misc/mei/main.c |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 98a7fc1..5d08db5 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -76,6 +76,10 @@ struct mei_device *mei_device_init(struct pci_dev *pdev)
 	mei_io_list_init(&dev->ctrl_rd_list);
 	mei_io_list_init(&dev->amthif_cmd_list);
 	mei_io_list_init(&dev->amthif_rd_complete_list);
+
+	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
+	INIT_WORK(&dev->init_work, mei_host_client_init);
+
 	dev->pdev = pdev;
 	return dev;
 }
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index f72bb77..123c663 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -889,8 +889,6 @@ static int mei_probe(struct pci_dev *pdev,
 		       pdev->irq);
 		goto disable_msi;
 	}
-	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
-	INIT_WORK(&dev->init_work, mei_host_client_init);
 
 	if (mei_hw_init(dev)) {
 		dev_err(&pdev->dev, "init hw failure.\n");
-- 
1.7.4.4

