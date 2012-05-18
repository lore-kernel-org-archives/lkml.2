Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031074Ab2ERDGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:06:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40466 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762578Ab2ERCwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:33 -0400
Message-Id: <20120518023258.178779105@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 28/53] [media] s5p-fimc: Fix locking in subdev set_crop op
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit e985dbf7d93e2a3e114b4525413e50f83613e0cb upstream.

When setting TRY crop on the sub-device the mutex was erroneously acquired
rather than released on exit path. This bug is present in kernels starting
from v3.2.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index b06efd2..fcf3a14 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1383,7 +1383,7 @@ static int fimc_subdev_set_crop(struct v4l2_subdev *sd,
 	fimc_capture_try_crop(ctx, r, crop->pad);
 
 	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mutex_lock(&fimc->lock);
+		mutex_unlock(&fimc->lock);
 		*v4l2_subdev_get_try_crop(fh, crop->pad) = *r;
 		return 0;
 	}
-- 
1.7.10



