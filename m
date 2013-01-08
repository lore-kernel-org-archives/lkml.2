Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab3AHVMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:12:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab3AHVIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605059"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 12/21] mei: move MEI_IAMTHIF_IDLE to amthif host init function
Date: Tue,  8 Jan 2013 23:07:23 +0200
Message-Id: <1357679252-12958-13-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the amthif state is not examined until amthif is connected
we can safely move it to the amthif host init function

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c |    2 ++
 drivers/misc/mei/init.c   |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 88e6aa0..7199e83 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -71,6 +71,8 @@ int mei_amthif_host_init(struct mei_device *dev)
 	unsigned char *msg_buf;
 	int ret, i;
 
+	dev->iamthif_state = MEI_IAMTHIF_IDLE;
+
 	mei_cl_init(cl, dev);
 
 	i = mei_me_cl_by_uuid(dev, &mei_amthif_guid);
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 9e4011e..70fad4e 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -68,7 +68,6 @@ struct mei_device *mei_device_init(struct pci_dev *pdev)
 	init_waitqueue_head(&dev->wait_recvd_msg);
 	init_waitqueue_head(&dev->wait_stop_wd);
 	dev->dev_state = MEI_DEV_INITIALIZING;
-	dev->iamthif_state = MEI_IAMTHIF_IDLE;
 
 	mei_io_list_init(&dev->read_list);
 	mei_io_list_init(&dev->write_list);
-- 
1.7.4.4

