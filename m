Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0LRDAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 22:00:20 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:52870 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab0LRDAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 22:00:16 -0500
Date: Fri, 17 Dec 2010 19:00:13 -0800
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] s1d13xxxfb: drop unused code
Message-ID: <20101217190013.0107a93a@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Silence warnings such as -

drivers/video/s1d13xxxfb.c:421: warning: ‘bltbit_wait_bitset’ defined but not used

Just drop the unused code.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/video/s1d13xxxfb.c |   50 --------------------------------------------
 include/video/s1d13xxxfb.h |    6 -----
 2 files changed, 0 insertions(+), 56 deletions(-)

diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/s1d13xxxfb.c
index a6247fc..28b1c6c 100644
--- a/drivers/video/s1d13xxxfb.c
+++ b/drivers/video/s1d13xxxfb.c
@@ -410,28 +410,6 @@ s1d13xxxfb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
  ************************************************************/
 
 /**
- *	bltbit_wait_bitset - waits for change in register value
- *	@info : framebuffer structure
- *	@bit  : value expected in register
- *	@timeout : ...
- *
- *	waits until value changes INTO bit
- */
-static u8
-bltbit_wait_bitset(struct fb_info *info, u8 bit, int timeout)
-{
-	while (!(s1d13xxxfb_readreg(info->par, S1DREG_BBLT_CTL0) & bit)) {
-		udelay(10);
-		if (!--timeout) {
-			dbg_blit("wait_bitset timeout\n");
-			break;
-		}
-	}
-
-	return timeout;
-}
-
-/**
  *	bltbit_wait_bitclear - waits for change in register value
  *	@info : frambuffer structure
  *	@bit  : value currently in register
@@ -454,34 +432,6 @@ bltbit_wait_bitclear(struct fb_info *info, u8 bit, int timeout)
 	return timeout;
 }
 
-/**
- *	bltbit_fifo_status - checks the current status of the fifo
- *	@info : framebuffer structure
- *
- *	returns number of free words in buffer
- */
-static u8
-bltbit_fifo_status(struct fb_info *info)
-{
-	u8 status;
-
-	status = s1d13xxxfb_readreg(info->par, S1DREG_BBLT_CTL0);
-
-	/* its empty so room for 16 words */
-	if (status & BBLT_FIFO_EMPTY)
-		return 16;
-
-	/* its full so we dont want to add */
-	if (status & BBLT_FIFO_FULL)
-		return 0;
-
-	/* its atleast half full but we can add one atleast */
-	if (status & BBLT_FIFO_NOT_FULL)
-		return 1;
-
-	return 0;
-}
-
 /*
  *	s1d13xxxfb_bitblt_copyarea - accelerated copyarea function
  *	@info : framebuffer structure
diff --git a/include/video/s1d13xxxfb.h b/include/video/s1d13xxxfb.h
index f0736cf..55f5344 100644
--- a/include/video/s1d13xxxfb.h
+++ b/include/video/s1d13xxxfb.h
@@ -136,12 +136,6 @@
 #define S1DREG_DELAYOFF			0xFFFE
 #define S1DREG_DELAYON			0xFFFF
 
-#define BBLT_FIFO_EMPTY			0x00
-#define BBLT_FIFO_NOT_EMPTY		0x40
-#define BBLT_FIFO_NOT_FULL		0x30
-#define BBLT_FIFO_HALF_FULL		0x20
-#define BBLT_FIFO_FULL			0x10
-
 #define BBLT_SOLID_FILL			0x0c
 
 
-- 
1.7.2.3

