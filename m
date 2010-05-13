Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab0EMT70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:59:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50689 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab0EMT7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:59:21 -0400
Date: Thu, 13 May 2010 21:59:15 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/20] drivers/media: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132158570.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/dvb/frontends/ds3000.c |    5 +----
 drivers/media/video/omap/omap_vout.c |    3 +--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -u -p a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -969,15 +969,12 @@ struct dvb_frontend *ds3000_attach(const
 	dprintk("%s\n", __func__);
 
 	/* allocate memory for the internal state */
-	state = kmalloc(sizeof(struct ds3000_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct ds3000_state), GFP_KERNEL);
 	if (state == NULL) {
 		printk(KERN_ERR "Unable to kmalloc\n");
 		goto error2;
 	}
 
-	/* setup the state */
-	memset(state, 0, sizeof(struct ds3000_state));
-
 	state->config = config;
 	state->i2c = i2c;
 	state->prevUCBS2 = 0;
diff -u -p a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2371,12 +2371,11 @@ static int __init omap_vout_create_video
 
 	for (k = 0; k < pdev->num_resources; k++) {
 
-		vout = kmalloc(sizeof(struct omap_vout_device), GFP_KERNEL);
+		vout = kzalloc(sizeof(struct omap_vout_device), GFP_KERNEL);
 		if (!vout) {
 			dev_err(&pdev->dev, ": could not allocate memory\n");
 			return -ENOMEM;
 		}
-		memset(vout, 0, sizeof(struct omap_vout_device));
 
 		vout->vid = k;
 		vid_dev->vouts[k] = vout;
