Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182Ab2FGIWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:22:00 -0400
Received: from www84.your-server.de ([213.133.104.84]:39297 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325Ab2FGIU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:28 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 05/13] remove pr_err() noise in skel_open
Date: Thu,  7 Jun 2012 10:20:35 +0200
Message-Id: <1339057243-10029-6-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 7fc9621..2ca2530 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -82,17 +82,11 @@ static int skel_open(struct inode *inode, struct file *file)
 {
 	struct usb_skel *dev;
 	struct usb_interface *interface;
-	int subminor;
-	int retval = 0;
-
-	subminor = iminor(inode);
+	int retval;
 
-	interface = usb_find_interface(&skel_driver, subminor);
-	if (!interface) {
-		pr_err("%s - error, can't find device for minor %d\n",
-			__func__, subminor);
+	interface = usb_find_interface(&skel_driver, iminor(inode));
+	if (!interface)
 		return -ENODEV;
-	}
 
 	dev = usb_get_intfdata(interface);
 	if (!dev)
-- 
1.7.8.6

