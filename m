Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1IPGRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48589 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1IPGRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:41 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 17/44] Staging: cx25821: Change indent with spaces to tabs 13
Date: Fri, 16 Sep 2011 14:14:50 +0800
Message-Id: <1316153717-7272-18-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   60 +++++++++++++++---------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 3af5f2b..958940f 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -882,41 +882,41 @@ static ssize_t video_read(struct file *file, char __user * data, size_t count,
 static unsigned int video_poll(struct file *file,
 			      struct poll_table_struct *wait)
 {
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
+	struct cx25821_fh *fh = file->private_data;
+	struct cx25821_buffer *buf;
 
-       if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
-	       /* streaming capture */
-	       if (list_empty(&fh->vidq.stream))
-		       return POLLERR;
-	       buf = list_entry(fh->vidq.stream.next,
+	if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
+		/* streaming capture */
+		if (list_empty(&fh->vidq.stream))
+			return POLLERR;
+		buf = list_entry(fh->vidq.stream.next,
 				struct cx25821_buffer, vb.stream);
-       } else {
-	       /* read() capture */
-	       buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-	       if (NULL == buf)
-		       return POLLERR;
-       }
+	} else {
+		/* read() capture */
+		buf = (struct cx25821_buffer *)fh->vidq.read_buf;
+		if (NULL == buf)
+			return POLLERR;
+	}
 
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-	       if (buf->vb.state == VIDEOBUF_DONE) {
-		       struct cx25821_dev *dev = fh->dev;
+	poll_wait(file, &buf->vb.done, wait);
+	if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
+		if (buf->vb.state == VIDEOBUF_DONE) {
+			struct cx25821_dev *dev = fh->dev;
 
-		       if (dev && dev->channels[fh->channel_id]
-					       .use_cif_resolution) {
-			       u8 cam_id = *((char *)buf->vb.baddr + 3);
-			       memcpy((char *)buf->vb.baddr,
+			if (dev && dev->channels[fh->channel_id]
+					.use_cif_resolution) {
+				u8 cam_id = *((char *)buf->vb.baddr + 3);
+				memcpy((char *)buf->vb.baddr,
 				      (char *)buf->vb.baddr + (fh->width * 2),
 				      (fh->width * 2));
-			       *((char *)buf->vb.baddr + 3) = cam_id;
-		       }
-	       }
+				*((char *)buf->vb.baddr + 3) = cam_id;
+			}
+		}
 
-	       return POLLIN | POLLRDNORM;
-       }
+		return POLLIN | POLLRDNORM;
+	}
 
-       return 0;
+	return 0;
 }
 
 static int video_release(struct file *file)
-- 
1.7.0.4

