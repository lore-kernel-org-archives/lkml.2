Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946623Ab2ERXGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:06:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38665 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946588Ab2ERXFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:54 -0400
Message-Id: <20120518212650.214630292@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 11/47] media: s5p-fimc: Fix locking in subdev set_crop op
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit e985dbf7d93e2a3e114b4525413e50f83613e0cb upstream.

When setting TRY crop on the sub-device the mutex was erroneously acquired
rather than released on exit path. This bug is present in kernels starting
from v3.2.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1316,7 +1316,7 @@ static int fimc_subdev_set_crop(struct v
 	fimc_capture_try_crop(ctx, r, crop->pad);
 
 	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mutex_lock(&fimc->lock);
+		mutex_unlock(&fimc->lock);
 		*v4l2_subdev_get_try_crop(fh, crop->pad) = *r;
 		return 0;
 	}


