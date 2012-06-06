Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2FFQ10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:27:26 -0400
Received: from www84.your-server.de ([213.133.104.84]:36702 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab2FFQ1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:24 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 06/11] introduce fsync function
Date: Wed,  6 Jun 2012 18:27:07 +0200
Message-Id: <1339000032-10313-7-git-send-email-stefani@seibold.net>
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
 drivers/usb/usb-skeleton.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index e8d337a..e766696 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -148,7 +148,7 @@ static void skel_draw_down(struct usb_skel *dev)
 	usb_kill_urb(dev->bulk_in_urb);
 }
 
-static int skel_flush(struct file *file, fl_owner_t id)
+static int skel_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct usb_skel *dev = file->private_data;
 	int res;
@@ -168,6 +168,11 @@ static int skel_flush(struct file *file, fl_owner_t id)
 	return res;
 }
 
+static int skel_flush(struct file *file, fl_owner_t id)
+{
+	return skel_fsync(file, 0, LLONG_MAX, 0);
+}
+
 static void skel_read_bulk_callback(struct urb *urb)
 {
 	struct usb_skel *dev;
@@ -482,6 +487,7 @@ static const struct file_operations skel_fops = {
 	.write =	skel_write,
 	.open =		skel_open,
 	.release =	skel_release,
+	.fsync =	skel_fsync,
 	.flush =	skel_flush,
 	.llseek =	noop_llseek,
 };
-- 
1.7.8.6

