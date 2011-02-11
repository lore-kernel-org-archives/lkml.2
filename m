Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab1BKPTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:19:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49903 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab1BKPTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:19:52 -0500
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>
To: kernel@avr32linux.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>,
        linux-fbdev@vger.kernel.org (open list:ATMEL LCDFB DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] atmel_lcdfb: add fb_blank function
Date: Fri, 11 Feb 2011 16:19:44 +0100
Message-Id: <1297437584-14048-2-git-send-email-biessmann@corscience.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297437584-14048-1-git-send-email-biessmann@corscience.de>
References: <1297437584-14048-1-git-send-email-biessmann@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:zHp26PQJifkDJczySNqH2xSlttePQebcirOZSzI0XLa
 2Se7InkhRIdgTzzLKrasSvZhO5U+ZGALqSgTSHOfarA/uNeLw6
 bYRmdOUqqtNYKWDa7LwdZziP9yv+l4It+x/GUhqn+NN7ycOXJz
 5YRhub4X8xmqJB9KBEr5iQcKLw4sN8F7H0hRL6a38MV9zTnAfs
 ZfJDSTYGytDX+V6NoxpOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Bießmann <biessmann@corscience.de>
---
These are some older patches which are used in some of our systems. Heavy
merging pointed out these functionality was missed to push upstream.

 drivers/video/atmel_lcdfb.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 16da8af..59654e2 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -714,11 +714,35 @@ static int atmel_lcdfb_pan_display(struct fb_var_screeninfo *var,
 	return 0;
 }
 
+static int atmel_lcdfb_blank(int blank_mode, struct fb_info *info)
+{
+	struct atmel_lcdfb_info *sinfo = info->par;
+
+	switch (blank_mode) {
+	case FB_BLANK_UNBLANK:
+	case FB_BLANK_NORMAL:
+		atmel_lcdfb_start(sinfo);
+		break;
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+		break;
+	case FB_BLANK_POWERDOWN:
+		atmel_lcdfb_stop(sinfo);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* let fbcon do a soft blank for us */
+	return ((blank_mode == FB_BLANK_NORMAL) ? 1 : 0);
+}
+
 static struct fb_ops atmel_lcdfb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_check_var	= atmel_lcdfb_check_var,
 	.fb_set_par	= atmel_lcdfb_set_par,
 	.fb_setcolreg	= atmel_lcdfb_setcolreg,
+	.fb_blank	= atmel_lcdfb_blank,
 	.fb_pan_display	= atmel_lcdfb_pan_display,
 	.fb_fillrect	= cfb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
-- 
1.7.2.3

