Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2IJVn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:43:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:52047 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab2IJVn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:43:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,400,1344236400"; 
   d="scan'208";a="191072262"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: add error messages for open count errors
Date: Tue, 11 Sep 2012 00:43:20 +0300
Message-Id: <1347313402-24606-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index ae2cd0d..e8b0858 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -239,12 +239,18 @@ static int mei_open(struct inode *inode, struct file *file)
 		goto out_unlock;
 	}
 	err = -EMFILE;
-	if (dev->open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT)
+	if (dev->open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT) {
+		dev_err(&dev->pdev->dev, "open_handle_count exceded %d",
+			MEI_MAX_OPEN_HANDLE_COUNT);
 		goto out_unlock;
+	}
 
 	cl_id = find_first_zero_bit(dev->host_clients_map, MEI_CLIENTS_MAX);
-	if (cl_id >= MEI_CLIENTS_MAX)
+	if (cl_id >= MEI_CLIENTS_MAX) {
+		dev_err(&dev->pdev->dev, "client_id exceded %d",
+				MEI_CLIENTS_MAX) ;
 		goto out_unlock;
+	}
 
 	cl->host_client_id  = cl_id;
 
-- 
1.7.4.4

