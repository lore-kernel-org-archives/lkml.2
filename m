Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965850Ab2EOCTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:19:05 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53431 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184Ab2EOCR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 107/179] v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner
Date: Mon, 14 May 2012 22:13:23 -0400
Message-ID: <1337048075-6132-108-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 227690df75382e46a4f6ea1bbc5df855a674b47f upstream.

The subdevs are supposed to receive a valid tuner type for the g_frequency
and g/s_tuner subdev ops. Some drivers do this, others don't. So prefill
this in v4l2-ioctl.c based on whether the device node from which this is
called is a radio node or not.

The spec does not require applications to fill in the type, and if they
leave it at 0 then the 'check_mode' call in tuner-core.c will return
an error and the ioctl does nothing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/video/v4l2-ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 7d59c10..e3de802 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1633,6 +1633,8 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_g_tuner)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_tuner(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, type=%d, "
@@ -1651,6 +1653,8 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_tuner)
 			break;
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd, "index=%d, name=%s, type=%d, "
 				"capability=0x%x, rangelow=%d, "
 				"rangehigh=%d, signal=%d, afc=%d, "
@@ -1669,6 +1673,8 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_g_frequency)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_frequency(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
-- 
1.7.9.6

