Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2FFQ2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:28:10 -0400
Received: from www84.your-server.de ([213.133.104.84]:36710 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab2FFQ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:25 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 07/11] remove pr_err() noise in skel_open
Date: Wed,  6 Jun 2012 18:27:08 +0200
Message-Id: <1339000032-10313-8-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index e766696..cab16e2 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -84,15 +84,11 @@ static int skel_open(struct inode *inode, struct file *file)
 {
 	struct usb_skel *dev;
 	struct usb_interface *interface;
-	int subminor;
-	int retval = 0;
+	int retval;
 
-	subminor = iminor(inode);
 
-	interface = usb_find_interface(&skel_driver, subminor);
+	interface = usb_find_interface(&skel_driver, iminor(inode));
 	if (!interface) {
-		pr_err("%s - error, can't find device for minor %d\n",
-			__func__, subminor);
 		retval = -ENODEV;
 		goto exit;
 	}
-- 
1.7.8.6

