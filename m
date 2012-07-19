Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab2GSTUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:20:05 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:5866 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2GSTUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:20:02 -0400
From: Lance Ortiz <lance.ortiz@hp.com>
To: bhelgaas@google.com, ying.huang@intel.com, jbarnes@virtuousgeek.org,
        rusty@rustcorp.com.au, mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        lance.ortiz@hp.com
Subject: [PATCH] aerdrv: Enable AER completion notice
Date: Thu, 19 Jul 2012 13:19:12 -0600
Message-Id: <1342725552-14407-1-git-send-email-lance.ortiz@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an AER event occurs not all of the print notifications are at the
same log level.  This can cause an incomplete AER log from the users
point of view when monitoring the console output.

The completion message in do_recovery() is currently set to KERN_DEBUG
(log level 7) while the starting message in aer_port_info() uses
KERN_INFO(log level 6). The completion message should be set to
KERN_INFO so it is consistent with the starting message in the log.

The message has also been re-worded to make it more clear.  This patch 
will enable the AER log on the console output to be book-ended by a
clear and consistent starting and completion message.

Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
---
 drivers/pci/pcie/aer/aerdrv_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 0ca0535..164bab5 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -540,14 +540,14 @@ static void do_recovery(struct pci_dev *dev, int severity)
 				"resume",
 				report_resume);
 
-	dev_printk(KERN_DEBUG, &dev->dev,
-		"AER driver successfully recovered\n");
+	dev_printk(KERN_INFO, &dev->dev,
+		"AER: Device recovery successful\n");
 	return;
 
 failed:
 	/* TODO: Should kernel panic here? */
-	dev_printk(KERN_DEBUG, &dev->dev,
-		"AER driver didn't recover\n");
+	dev_printk(KERN_INFO, &dev->dev,
+		"AER: Device recovery failed\n");
 }
 
 /**
-- 
1.7.7.6

