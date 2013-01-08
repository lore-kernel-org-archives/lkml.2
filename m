Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3AHVIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:63355 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab3AHVIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243604914"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 05/21] mei: move watchdog prototypes to mei_dev.h from interface.h
Date: Tue,  8 Jan 2013 23:07:16 +0200
Message-Id: <1357679252-12958-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interface.h contains lower layer functionality

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interface.h |   20 --------------------
 drivers/misc/mei/mei_dev.h   |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
index 01d1ef5..73bef54 100644
--- a/drivers/misc/mei/interface.h
+++ b/drivers/misc/mei/interface.h
@@ -49,24 +49,4 @@ static inline unsigned char mei_data2slots(size_t length)
 
 int mei_count_full_read_slots(struct mei_device *dev);
 
-
-
-
-
-int mei_wd_send(struct mei_device *dev);
-int mei_wd_stop(struct mei_device *dev);
-int mei_wd_host_init(struct mei_device *dev);
-/*
- * mei_watchdog_register  - Registering watchdog interface
- *   once we got connection to the WD Client
- * @dev - mei device
- */
-void mei_watchdog_register(struct mei_device *dev);
-/*
- * mei_watchdog_unregister  - Unregistering watchdog interface
- * @dev - mei device
- */
-void mei_watchdog_unregister(struct mei_device *dev);
-
-
 #endif /* _MEI_INTERFACE_H_ */
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index f3da153..d41177b 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -371,6 +371,23 @@ int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
 		struct mei_device *dev, struct mei_msg_hdr *mei_hdr);
 int mei_amthif_irq_read(struct mei_device *dev, s32 *slots);
 
+
+int mei_wd_send(struct mei_device *dev);
+int mei_wd_stop(struct mei_device *dev);
+int mei_wd_host_init(struct mei_device *dev);
+/*
+ * mei_watchdog_register  - Registering watchdog interface
+ *   once we got connection to the WD Client
+ * @dev - mei device
+ */
+void mei_watchdog_register(struct mei_device *dev);
+/*
+ * mei_watchdog_unregister  - Unregistering watchdog interface
+ * @dev - mei device
+ */
+void mei_watchdog_unregister(struct mei_device *dev);
+
+
 /*
  * Register Access Function
  */
-- 
1.7.4.4

