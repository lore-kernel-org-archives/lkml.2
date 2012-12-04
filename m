Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2LDOHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:07:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:14163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab2LDOFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975357"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 06/15] mei: kill not used BAR0 length and base variables
Date: Tue,  4 Dec 2012 16:04:35 +0200
Message-Id: <1354629884-3202-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. mem_base and mem_lenght are not used so we can delete
them
2. add kdoc for mem_addr member of mei_device

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index ddc23f5..92a5d9a 100644
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

