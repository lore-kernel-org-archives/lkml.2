Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1FZQKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1FZQHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:50 -0400
Date: Sun, 26 Jun 2011 13:06:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/14] [media] v4l2-ioctl: Add a default value for kernel
 version
Message-ID: <20110626130604.6317c2a6@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most drivers don't increase kernel versions as newer features are added or
bug fixes are solved. So, vidioc_querycap returned value for cap->version is
meaningless. Instead of keeping this situation forever, let's add a default
value matching the current Linux version.

Drivers that want to keep their own version control can still do it, as they
can override the default value for cap->version.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index ebdf762..a0a2466 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/version.h>
 
 #include <linux/videodev2.h>
 
@@ -605,6 +606,7 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_querycap)
 			break;
 
+		cap->version = LINUX_VERSION_CODE;
 		ret = ops->vidioc_querycap(file, fh, cap);
 		if (!ret)
 			dbgarg(cmd, "driver=%s, card=%s, bus=%s, "
-- 
1.7.1


