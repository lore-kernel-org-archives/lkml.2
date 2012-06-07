Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab2FGIV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:21:57 -0400
Received: from www84.your-server.de ([213.133.104.84]:39306 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab2FGIU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:29 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 08/13] add fsync function
Date: Thu,  7 Jun 2012 10:20:38 +0200
Message-Id: <1339057243-10029-9-git-send-email-stefani@seibold.net>
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
 drivers/usb/usb-skeleton.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index dc95129..61f4ac8 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -133,7 +133,7 @@ static void skel_draw_down(struct usb_skel *dev)
 	usb_kill_urb(dev->bulk_in_urb);
 }
 
-static int skel_flush(struct file *file, fl_owner_t id)
+static int skel_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct usb_skel *dev = file->private_data;
 	int retval;
@@ -157,6 +157,11 @@ exit:
 	return retval;
 }
 
+static int skel_flush(struct file *file, fl_owner_t id)
+{
+	return skel_fsync(file, 0, LLONG_MAX, 0);
+}
+
 static void skel_read_bulk_callback(struct urb *urb)
 {
 	struct usb_skel *dev;
@@ -470,6 +475,7 @@ static const struct file_operations skel_fops = {
 	.write =	skel_write,
 	.open =		skel_open,
 	.release =	skel_release,
+	.fsync =	skel_fsync,
 	.flush =	skel_flush,
 	.llseek =	noop_llseek,
 };
-- 
1.7.8.6

