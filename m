Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2BXBjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:39:33 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60391 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2BXBj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.106.17 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH 2/9] mei: factor some bits of code outside if blocks
Date: Thu, 23 Feb 2012 20:38:49 -0500
Message-Id: <1330047536-3827-3-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/interrupt.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 4914589..d1291ae 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -1336,9 +1336,6 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			}
 			ret = _mei_irq_thread_cmpl(dev, slots, pos, cl,
 					cmpl_list);
-			if (ret)
-				return ret;
-
 		} else if (cl == &dev->iamthif_cl) {
 			/* IAMTHIF IOCTL */
 			dev_dbg(&dev->pdev->dev, "complete amthi write cb.\n");
@@ -1352,11 +1349,9 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			}
 			ret = _mei_irq_thread_cmpl_iamthif(dev, slots, pos, cl,
 						cmpl_list);
-			if (ret)
-				return ret;
-
 		}
-
+		if (ret)
+			return ret;
 	}
 	return 0;
 }
@@ -1523,13 +1518,11 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 			 * start sending messages.
 			 */
 			mei_host_start_message(dev);
-			mutex_unlock(&dev->device_lock);
-			return IRQ_HANDLED;
 		} else {
 			dev_dbg(&dev->pdev->dev, "FW not ready.\n");
-			mutex_unlock(&dev->device_lock);
-			return IRQ_HANDLED;
 		}
+		mutex_unlock(&dev->device_lock);
+		return IRQ_HANDLED;
 	}
 	/* check slots avalable for reading */
 	slots = mei_count_full_read_slots(dev);
-- 
1.7.9.2

