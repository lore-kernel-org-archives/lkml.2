Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0HPQ0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:26:18 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34747 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab0HPQ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:26:16 -0400
Date: Mon, 16 Aug 2010 18:26:13 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/16] drivers/media: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161825570.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, error codes are stored in rc, but the return value is always
0.  Return rc instead.

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
The changes change the semantics and are not tested.  In the second case,
the function is used in only one place and the return value is igored.

 drivers/media/dvb/frontends/drx397xD.c |    2 +-
 drivers/media/video/s2255drv.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
index f74cca6..a05007c 100644
--- a/drivers/media/dvb/frontends/drx397xD.c
+++ b/drivers/media/dvb/frontends/drx397xD.c
@@ -232,7 +232,7 @@ static int write_fw(struct drx397xD_state *s, enum blob_ix ix)
 exit_rc:
 	read_unlock(&fw[s->chip_rev].lock);
 
-	return 0;
+	return rc;
 }
 
 /* Function is not endian safe, use the RD16 wrapper below */
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 8ec7c9a..8f74341 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -600,7 +600,7 @@ static int s2255_got_frame(struct s2255_channel *channel, int jpgsize)
 	dprintk(2, "%s: [buf/i] [%p/%d]\n", __func__, buf, buf->vb.i);
 unlock:
 	spin_unlock_irqrestore(&dev->slock, flags);
-	return 0;
+	return rc;
 }
 
 static const struct s2255_fmt *format_by_fourcc(int fourcc)
