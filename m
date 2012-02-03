Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2BCJb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:31:28 -0500
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1229 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab2BCJ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:29:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/6] vivi: let vb2_poll handle events.
Date: Fri,  3 Feb 2012 10:28:45 +0100
Message-Id: <095585387c5248fec3291daef9f9a32eaf4a6f14.1328260650.git.hans.verkuil@cisco.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
References: <1328261325-8452-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0a2613f950f1865c6c2675c27186e73a8c3dfe94.1328260650.git.hans.verkuil@cisco.com>
References: <0a2613f950f1865c6c2675c27186e73a8c3dfe94.1328260650.git.hans.verkuil@cisco.com>
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
index 84ea88d..3983680 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1058,17 +1058,10 @@ static unsigned int
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
1.7.8.3

