Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2DOVjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 17:39:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22126 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2DOVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 17:39:34 -0400
Date: Sun, 15 Apr 2012 23:39:32 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Andres Salomon <dilinger@queued.net>
cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: olpc_dcon.c: checkpatch.pl and style fixups
In-Reply-To: <20120414192638.31fa501d@debxo>
Message-ID: <alpine.LNX.2.00.1204152338270.18522@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204150049270.15578@swampdragon.chaosbits.net> <20120414192638.31fa501d@debxo>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2012, Andres Salomon wrote:

> On Sun, 15 Apr 2012 00:53:04 +0200 (CEST)
> Jesper Juhl <jj@chaosbits.net> wrote:
> 
> > This patch removes the few checkpatch.pl issues that are currently
> > reported for this file.
> > 
> > It makes these changes:
> > 
> > 1. Quoted strings that were broken over multiple lines are put on a
> >    single line for easier grep'ability.
> > 
> > 2. Add missing level to a printk().
> > 
> > 3. A few casts have had their space between the cast and variable
> >    removed.
> > 
> 
> These first three look fine.
> 
> 
> > 4. Two msleep() calls with times <= 20 have been changed to
> >    usleep_range() calls instead since msleep(<=20) may sleep for 20ms
> >    (on 100Hz kernels for instance).
> >    Picking a value for the lower bound of the range was easy, that was
> >    just the value passed to msleep(). As for picking the upper bound
> >    of the sleep I just went with two times the lower bound, for no
> >    other reason than the fact that in both cases that value was <=20ms
> >    and the end result will in any case be closer to the intention than
> >    a 20ms sleep.
> 
> 
> That msleep(1) was replaced with a longer msleep and fewer dcon_read
> attempts in OLPC's XO-1.75 kernel.  The msleep(10) should probably be
> a shorter usleep (though we'd need to test it).  In general, this
> stuff was done to work around bugs in the dcon, and the timing of these
> bugs appears to differ (probably due to smbus timing) between the
> various OLPC platforms - XO-1 (x86 amd geode), XO-1.5 (x86 via), and
> XO-1.75 (arm armada 610). 
> 
> Given that, I'd prefer to leave these alone and figure out the proper
> values later (with lots of testing).  Mind resubmitting with the
> msleep changes removed?
> 
Not at all :-)

How's this?


From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 15 Apr 2012 00:38:03 +0200
Subject: [PATCH] staging: olpc_dcon.c: checkpatch.pl and style fixups

This patch removes a few checkpatch.pl issues that are currently
reported for this file.

It makes these changes:

1. Quoted strings that were broken over multiple lines are put on a
   single line for easier grep'ability.

2. Add missing level to a printk().

3. A few casts have had their space between the cast and variable
   removed.

I have not tested this patch beyond checking that it compiles.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 3d91993..43758c3 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -71,8 +71,8 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
 
 	ver = dcon_read(dcon, DCON_REG_ID);
 	if ((ver >> 8) != 0xDC) {
-		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x "
-				"instead.\n", ver);
+		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x instead.\n",
+				ver);
 		rc = -ENXIO;
 		goto err;
 	}
@@ -134,10 +134,10 @@ static int dcon_bus_stabilize(struct dcon_priv *dcon, int is_powered_down)
 power_up:
 	if (is_powered_down) {
 		x = 1;
-		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
+		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
 		if (x) {
-			printk(KERN_WARNING "olpc-dcon:  unable to force dcon "
-					"to power up: %d!\n", x);
+			printk(KERN_WARNING "olpc-dcon:  unable to force dcon to power up: %d!\n",
+					x);
 			return x;
 		}
 		msleep(10); /* we'll be conservative */
@@ -150,11 +150,10 @@ power_up:
 		x = dcon_read(dcon, DCON_REG_ID);
 	}
 	if (x < 0) {
-		printk(KERN_ERR "olpc-dcon:  unable to stabilize dcon's "
-				"smbus, reasserting power and praying.\n");
+		printk(KERN_ERR "olpc-dcon:  unable to stabilize dcon's smbus, reasserting power and praying.\n");
 		BUG_ON(olpc_board_at_least(olpc_board(0xc2)));
 		x = 0;
-		olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
+		olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
 		msleep(100);
 		is_powered_down = 1;
 		goto power_up;	/* argh, stupid hardware.. */
@@ -220,10 +219,10 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 
 	if (sleep) {
 		x = 0;
-		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
+		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
 		if (x)
-			printk(KERN_WARNING "olpc-dcon:  unable to force dcon "
-					"to power down: %d!\n", x);
+			printk(KERN_WARNING "olpc-dcon:  unable to force dcon to power down: %d!\n",
+					x);
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
 
@@ -304,7 +303,7 @@ static void dcon_source_switch(struct work_struct *work)
 
 	switch (source) {
 	case DCON_SOURCE_CPU:
-		printk("dcon_source_switch to CPU\n");
+		printk(KERN_INFO "dcon_source_switch to CPU\n");
 		/* Enable the scanline interrupt bit */
 		if (dcon_write(dcon, DCON_REG_MODE,
 				dcon->disp_mode | MODE_SCAN_INT))
@@ -599,7 +598,7 @@ static int dcon_fb_notifier(struct notifier_block *self,
 	struct fb_event *evdata = data;
 	struct dcon_priv *dcon = container_of(self, struct dcon_priv,
 			fbevent_nb);
-	int *blank = (int *) evdata->data;
+	int *blank = (int *)evdata->data;
 	if (((event != FB_EVENT_BLANK) && (event != FB_EVENT_CONBLANK)) ||
 			dcon->ignore_fb_events)
 		return 0;
-- 
1.7.10




-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

