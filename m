Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0GLUvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:51:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1760 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab0GLUu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:56 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Subject: [PATCH 21/36] drivers/usb: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:13 -0700
Message-Id: <b7b64f6d1d8b19cab0d73960fe9f72b2c40bdc62.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/usb-skeleton.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index d110588..552679b 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -142,7 +142,7 @@ static int skel_release(struct inode *inode, struct file *file)
 {
 	struct usb_skel *dev;
 
-	dev = (struct usb_skel *)file->private_data;
+	dev = file->private_data;
 	if (dev == NULL)
 		return -ENODEV;
 
@@ -162,7 +162,7 @@ static int skel_flush(struct file *file, fl_owner_t id)
 	struct usb_skel *dev;
 	int res;
 
-	dev = (struct usb_skel *)file->private_data;
+	dev = file->private_data;
 	if (dev == NULL)
 		return -ENODEV;
 
@@ -246,7 +246,7 @@ static ssize_t skel_read(struct file *file, char *buffer, size_t count,
 	int rv;
 	bool ongoing_io;
 
-	dev = (struct usb_skel *)file->private_data;
+	dev = file->private_data;
 
 	/* if we cannot read at all, return EOF */
 	if (!dev->bulk_in_urb || !count)
@@ -401,7 +401,7 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 	char *buf = NULL;
 	size_t writesize = min(count, (size_t)MAX_TRANSFER);
 
-	dev = (struct usb_skel *)file->private_data;
+	dev = file->private_data;
 
 	/* verify that we actually have some data to write */
 	if (count == 0)
-- 
1.7.1.337.g6068.dirty

