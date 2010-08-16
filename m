Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab0HPQ1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:27:52 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50803 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab0HPQ1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:27:49 -0400
Date: Mon, 16 Aug 2010 18:27:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Antoine Jacquet <royale@zerezo.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 11/16] drivers/media/video: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161827310.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error codes are stored in rc, but the return value is always 0.  Return rc
instead.

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
This changes the semantics of the function, but currently its return value
is ignored.  Alternatively, the function could be converted to return
nothing.

 drivers/media/video/zr364xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index a82b5bd..616c61f 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -572,7 +572,7 @@ static int zr364xx_got_frame(struct zr364xx_camera *cam, int jpgsize)
 	DBG("wakeup [buf/i] [%p/%d]\n", buf, buf->vb.i);
 unlock:
 	spin_unlock_irqrestore(&cam->slock, flags);
-	return 0;
+	return rc;
 }
 
 /* this function moves the usb stream read pipe data
