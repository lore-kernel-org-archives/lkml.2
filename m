Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab2FGIWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:22:14 -0400
Received: from www84.your-server.de ([213.133.104.84]:39292 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab2FGIU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:27 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 03/13] remove dead code
Date: Thu,  7 Jun 2012 10:20:33 +0200
Message-Id: <1339057243-10029-4-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

All code which use processed_urb can be eliminated.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 7385aa8..92cdfca 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -59,7 +59,6 @@ struct usb_skel {
 	__u8			bulk_out_endpointAddr;	/* the address of the bulk out endpoint */
 	int			errors;			/* the last request tanked */
 	bool			ongoing_read;		/* a read is going on */
-	bool			processed_urb;		/* indicates we haven't processed the urb */
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
@@ -256,17 +255,6 @@ retry:
 		 * we must finish now
 		 */
 		dev->bulk_in_copied = 0;
-		dev->processed_urb = true;
-	}
-
-	if (!dev->processed_urb) {
-		/*
-		 * the URB hasn't been processed
-		 * do it now
-		 */
-		wait_for_completion(&dev->bulk_in_completion);
-		dev->bulk_in_copied = 0;
-		dev->processed_urb = true;
 	}
 
 	/* errors must be reported */
-- 
1.7.8.6

