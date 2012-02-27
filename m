Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2B0RjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:39:12 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51457 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab2B0RjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:39:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.52.68.241 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH] mei: fix typo in error code return
Date: Mon, 27 Feb 2012 12:38:12 -0500
Message-Id: <1330364292-10516-1-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

~ENODEV is a different number than -ENODEV

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/interrupt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 5c9170f..c2800ba 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -1243,7 +1243,7 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 		}
 	}
 	if (dev->stop)
-		return ~ENODEV;
+		return -ENODEV;
 
 	/* complete control write list CB */
 	dev_dbg(&dev->pdev->dev, "complete control write list cb.\n");
-- 
1.7.9.2

