Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab2IJVnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:43:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:52047 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788Ab2IJVnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,400,1344236400"; 
   d="scan'208";a="191072301"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3] mei: don't print buffer as a string
Date: Tue, 11 Sep 2012 00:43:22 +0300
Message-Id: <1347313402-24606-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347313402-24606-1-git-send-email-tomas.winkler@intel.com>
References: <1347313402-24606-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

non readable junk was printed to the logs
we will add proper buffer dumping mechanism later if needed

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 0900a71..3533edd 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -221,17 +221,10 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 				cl->status = 0;
 				list_del(&cb_pos->cb_list);
 				dev_dbg(&dev->pdev->dev,
-					"completed read host client = %d,"
-					"ME client = %d, "
-					"data length = %lu\n",
+					"completed read H cl = %d, ME cl = %d, length = %lu\n",
 					cl->host_client_id,
 					cl->me_client_id,
 					cb_pos->information);
-
-				*(cb_pos->response_buffer.data +
-					cb_pos->information) = '\0';
-				dev_dbg(&dev->pdev->dev, "cb_pos->res_buffer - %s\n",
-					cb_pos->response_buffer.data);
 				list_add_tail(&cb_pos->cb_list,
 					&complete_list->mei_cb.cb_list);
 			}
-- 
1.7.4.4

