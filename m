Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1I2Hpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:45:47 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2388 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1I2HpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:45:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 6/6] vivi: let vb2_poll handle events.
Date: Thu, 29 Sep 2011 09:44:12 +0200
Message-Id: <a0032fee1a51d51f4a43cf2440adc8bc4ea4c8d4.1317281827.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
References: <1317282252-8290-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8488cb7deae3c3da6b079c8ebdcacce1f86dd433.1317281827.git.hans.verkuil@cisco.com>
References: <8488cb7deae3c3da6b079c8ebdcacce1f86dd433.1317281827.git.hans.verkuil@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

The vb2_poll function now tests for events and sets POLLPRI accordingly.
So there it is no longer necessary to test for it in the vivi driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 7cf94c0..c25787d 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1057,17 +1057,10 @@ static unsigned int
 vivi_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct vivi_dev *dev = video_drvdata(file);
-	struct v4l2_fh *fh = file->private_data;
 	struct vb2_queue *q = &dev->vb_vidq;
-	unsigned int res;
 
 	dprintk(dev, 1, "%s\n", __func__);
-	res = vb2_poll(q, file, wait);
-	if (v4l2_event_pending(fh))
-		res |= POLLPRI;
-	else
-		poll_wait(file, &fh->wait, wait);
-	return res;
+	return vb2_poll(q, file, wait);
 }
 
 static int vivi_close(struct file *file)
-- 
1.7.5.4

