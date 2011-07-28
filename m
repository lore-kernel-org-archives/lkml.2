Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab1G1Xou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:62194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab1G1Xol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552535"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: hans.verkuil@cisco.com, mchehab@redhat.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [36/50] v4l2-ioctl.c: prefill tuner type for g_frequency and
Message-Id: <20110728234440.E99AF2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hans Verkuil <hans.verkuil@cisco.com>

[ upstream commit 227690df75382e46a4f6ea1bbc5df855a674b47f ]
 g/s_tuner

The subdevs are supposed to receive a valid tuner type for the g_frequency
and g/s_tuner subdev ops. Some drivers do this, others don't. So prefill
this in v4l2-ioctl.c based on whether the device node from which this is
called is a radio node or not.

The spec does not require applications to fill in the type, and if they
leave it at 0 then the 'check_mode' call in tuner-core.c will return
an error and the ioctl does nothing.

Cc: stable@kernel.org
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/media/video/v4l2-ioctl.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/v4l2-ioctl.c
+++ linux-2.6.35.y/drivers/media/video/v4l2-ioctl.c
@@ -1644,6 +1644,8 @@ static long __video_do_ioctl(struct file
 		if (!ops->vidioc_g_tuner)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_tuner(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, type=%d, "
@@ -1662,6 +1664,8 @@ static long __video_do_ioctl(struct file
 
 		if (!ops->vidioc_s_tuner)
 			break;
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd, "index=%d, name=%s, type=%d, "
 				"capability=0x%x, rangelow=%d, "
 				"rangehigh=%d, signal=%d, afc=%d, "
@@ -1680,6 +1684,8 @@ static long __video_do_ioctl(struct file
 		if (!ops->vidioc_g_frequency)
 			break;
 
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_frequency(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
