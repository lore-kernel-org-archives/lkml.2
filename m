Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2FSGNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:13:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:62481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab2FSGNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="159348657"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/4] mei: check for error codes that mei_flow_ctrl_creds  retuns
Date: Tue, 19 Jun 2012 09:13:34 +0300
Message-Id: <1340086417-23090-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we cannot use if(!mei_flow_ctrl_creds()) logic as
mei_flow_ctrl_creds also negative error codes

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 23f5463..86380fd 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -1326,7 +1326,7 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			continue;
 
 		if (cl != &dev->iamthif_cl) {
-			if (!mei_flow_ctrl_creds(dev, cl)) {
+			if (mei_flow_ctrl_creds(dev, cl) <= 0) {
 				dev_dbg(&dev->pdev->dev,
 					"No flow control"
 				    " credentials for client"
@@ -1343,7 +1343,7 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 		} else if (cl == &dev->iamthif_cl) {
 			/* IAMTHIF IOCTL */
 			dev_dbg(&dev->pdev->dev, "complete amthi write cb.\n");
-			if (!mei_flow_ctrl_creds(dev, cl)) {
+			if (mei_flow_ctrl_creds(dev, cl) <= 0) {
 				dev_dbg(&dev->pdev->dev,
 					"No flow control"
 				    " credentials for amthi"
-- 
1.7.4.4

