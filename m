Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab2FFQ3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:29:22 -0400
Received: from www84.your-server.de ([213.133.104.84]:36690 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab2FFQ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:22 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 03/11] remove dead code
Date: Wed,  6 Jun 2012 18:27:04 +0200
Message-Id: <1339000032-10313-4-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

all code which use processed_urb can be eliminated.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 2298ef0..2f17991 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -61,7 +61,6 @@ struct usb_skel {
 	__u8			bulk_out_endpointAddr;	/* the address of the bulk out endpoint */
 	int			errors;			/* the last request tanked */
 	bool			ongoing_read;		/* a read is going on */
-	bool			processed_urb;		/* indicates we haven't processed the urb */
 	spinlock_t		err_lock;		/* lock for errors */
 	struct kref		kref;
 	struct mutex		io_mutex;		/* synchronize I/O with disconnect */
@@ -264,17 +263,6 @@ retry:
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

