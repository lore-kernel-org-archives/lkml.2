Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2LYRIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 12:08:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:16881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab2LYRGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 12:06:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,353,1355126400"; 
   d="scan'208";a="184664390"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 06/14] mei: kill not used BAR0 length and base variables
Date: Tue, 25 Dec 2012 19:06:04 +0200
Message-Id: <1356455172-31959-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1356455172-31959-1-git-send-email-tomas.winkler@intel.com>
References: <1356455172-31959-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. mem_base and mem_length are not used so we can delete
them
2. add kdoc for mem_addr member of mei_device

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index f0b02ba..6ea430e 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -201,6 +201,7 @@ struct mei_cl {
 
 /**
  * struct mei_device -  MEI private device struct
+ * @mem_addr - mem mapped base register address
  * @hbuf_depth - depth of host(write) buffer
  * @wr_ext_msg - buffer for hbm control responses (set in read cycle)
  */
@@ -221,11 +222,7 @@ struct mei_device {
 	 */
 	struct list_head file_list;
 	long open_handle_count;
-	/*
-	 * memory of device
-	 */
-	unsigned int mem_base;
-	unsigned int mem_length;
+
 	void __iomem *mem_addr;
 	/*
 	 * lock for the device
-- 
1.7.4.4

