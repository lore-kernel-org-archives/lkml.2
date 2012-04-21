Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2DUSdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 14:33:09 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17470 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2DUScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 14:32:53 -0400
Date: Sat, 21 Apr 2012 20:32:52 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: David Woodhouse <dwmw2@infradead.org>,
        Andres Salomon <dilinger@queued.net>,
        Jordan Crouse <jordan@cosmicpenguin.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/3] staging: olpc_dcon.c: strings printed with printk() put
 on a single line
In-Reply-To: <alpine.LNX.2.00.1204212025140.25551@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204212029520.25551@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204212025140.25551@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoted strings that were broken over multiple lines are put on a
single line for easier grep'ability.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 3d91993..862dbb5 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -71,8 +71,8 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 
 	ver = dcon_read(dcon, DCON_REG_ID);
 	if ((ver >> 8) != 0xDC) {
-		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x "
-				"instead.\n", ver);
+		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x instead.\n",
+			ver);
 		rc = -ENXIO;
 		goto err;
 	}
@@ -136,8 +136,8 @@ power_up:
 		x = 1;
 		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
 		if (x) {
-			printk(KERN_WARNING "olpc-dcon:  unable to force dcon "
-					"to power up: %d!\n", x);
+			printk(KERN_WARNING "olpc-dcon:  unable to force dcon to power up: %d!\n",
+				x);
 			return x;
 		}
 		msleep(10); /* we'll be conservative */
@@ -150,8 +150,7 @@ power_up:
 		x = dcon_read(dcon, DCON_REG_ID);
 	}
 	if (x < 0) {
-		printk(KERN_ERR "olpc-dcon:  unable to stabilize dcon's "
-				"smbus, reasserting power and praying.\n");
+		printk(KERN_ERR "olpc-dcon:  unable to stabilize dcon's smbus, reasserting power and praying.\n");
 		BUG_ON(olpc_board_at_least(olpc_board(0xc2)));
 		x = 0;
 		olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
@@ -222,8 +221,8 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 		x = 0;
 		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
 		if (x)
-			printk(KERN_WARNING "olpc-dcon:  unable to force dcon "
-					"to power down: %d!\n", x);
+			printk(KERN_WARNING "olpc-dcon:  unable to force dcon to power down: %d!\n",
+				x);
 		else
 			dcon->asleep = sleep;
 	} else {
@@ -232,8 +231,8 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 			dcon->disp_mode |= MODE_BL_ENABLE;
 		x = dcon_bus_stabilize(dcon, 1);
 		if (x)
-			printk(KERN_WARNING "olpc-dcon:  unable to reinit dcon"
-					" hardware: %d!\n", x);
+			printk(KERN_WARNING "olpc-dcon:  unable to reinit dcon hardware: %d!\n",
+				x);
 		else
 			dcon->asleep = sleep;
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

