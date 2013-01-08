Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3AHVKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:10:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab3AHVIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605088"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 14/21] mei: remove write only need_reset member of struct mei_device
Date: Tue,  8 Jan 2013 23:07:25 +0200
Message-Id: <1357679252-12958-15-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need_reset is not used anymore

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c    |    6 +-----
 drivers/misc/mei/mei_dev.h |    1 -
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 70fad4e..2391832 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -199,10 +199,8 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	struct mei_cl_cb *cb_next = NULL;
 	bool unexpected;
 
-	if (dev->dev_state == MEI_DEV_RECOVERING_FROM_RESET) {
-		dev->need_reset = true;
+	if (dev->dev_state == MEI_DEV_RECOVERING_FROM_RESET)
 		return;
-	}
 
 	unexpected = (dev->dev_state != MEI_DEV_INITIALIZING &&
 			dev->dev_state != MEI_DEV_DISABLED &&
@@ -224,8 +222,6 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	dev_dbg(&dev->pdev->dev, "currently saved host_hw_state = 0x%08x.\n",
 	    dev->host_hw_state);
 
-	dev->need_reset = false;
-
 	if (dev->dev_state != MEI_DEV_INITIALIZING) {
 		if (dev->dev_state != MEI_DEV_DISABLED &&
 		    dev->dev_state != MEI_DEV_POWER_DOWN)
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index dcd7a44..e42db31 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -260,7 +260,6 @@ struct mei_device {
 	enum mei_dev_state dev_state;
 	enum mei_init_clients_states init_clients_state;
 	u16 init_clients_timer;
-	bool need_reset;
 
 	unsigned char rd_msg_buf[MEI_RD_MSG_BUF_SIZE];	/* control messages */
 	u32 rd_msg_hdr;
-- 
1.7.4.4

