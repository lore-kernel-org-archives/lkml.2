Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2BXBlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:41:15 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60391 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab2BXBja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.136.200 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH 4/9] mei: return values are -Exxx, not ~Exxx!
Date: Thu, 23 Feb 2012 20:38:51 -0500
Message-Id: <1330047536-3827-5-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

There's no way this is what was intended! :)

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/interrupt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 0601789..b024270 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -1273,7 +1273,7 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 		}
 	}
 	if (dev->stop)
-		return ~ENODEV;
+		return -ENODEV;
 
 	/* complete control write list CB */
 	dev_dbg(&dev->pdev->dev, "complete control write list cb.\n");
-- 
1.7.9.2

