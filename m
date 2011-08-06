Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab1HFAT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:19:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249Ab1HFALC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:11:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:11 2011
Message-Id: <20110806000411.737803061@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [02/50] [media] v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/v4l2-ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1632,6 +1632,8 @@ static long __video_do_ioctl(struct file
 		if (!ops->vidioc_g_tuner)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_tuner(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, type=%d, "
@@ -1650,6 +1652,8 @@ static long __video_do_ioctl(struct file
 
 		if (!ops->vidioc_s_tuner)
 			break;
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd, "index=%d, name=%s, type=%d, "
 				"capability=0x%x, rangelow=%d, "
 				"rangehigh=%d, signal=%d, afc=%d, "
@@ -1668,6 +1672,8 @@ static long __video_do_ioctl(struct file
 		if (!ops->vidioc_g_frequency)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_frequency(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",


