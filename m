Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0HPQZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:25:43 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34721 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990Ab0HPQZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:25:41 -0400
Date: Mon, 16 Aug 2010 18:25:39 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/16] drivers/media/video/zoran: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161825220.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error codes are stored in res, but the return value is always 0.  Return
res instead.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics and has not been tested.

 drivers/media/video/zoran/zoran_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index 6f89d0a..c155ddf 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -3322,7 +3322,7 @@ zoran_mmap (struct file           *file,
 mmap_unlock_and_return:
 	mutex_unlock(&zr->resource_lock);
 
-	return 0;
+	return res;
 }
 
 static const struct v4l2_ioctl_ops zoran_ioctl_ops = {
