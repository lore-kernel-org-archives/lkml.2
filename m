Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386Ab0HEUaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:30:07 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39125 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934404Ab0HEU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:29:57 -0400
Date: Thu, 5 Aug 2010 22:29:55 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 42/42] drivers/media/video/bt8xx: Adjust confusing if
 indentation
Message-ID: <Pine.LNX.4.64.1008052229390.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Indent the branch of an if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/bt8xx/bttv-i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/bt8xx/bttv-i2c.c b/drivers/media/video/bt8xx/bttv-i2c.c
index 685d659..695765c 100644
--- a/drivers/media/video/bt8xx/bttv-i2c.c
+++ b/drivers/media/video/bt8xx/bttv-i2c.c
@@ -123,7 +123,7 @@ bttv_i2c_wait_done(struct bttv *btv)
 	if (wait_event_interruptible_timeout(btv->i2c_queue,
 		btv->i2c_done, msecs_to_jiffies(85)) == -ERESTARTSYS)
 
-	rc = -EIO;
+		rc = -EIO;
 
 	if (btv->i2c_done & BT848_INT_RACK)
 		rc = 1;
