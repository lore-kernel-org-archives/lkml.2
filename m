Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab2DZSqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:46:36 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52353 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab2DZSqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:46:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE+XmU9bdWOb/2dsb2JhbABFsXCBB4IKAQUnUhBRPBsHEogRuniQZQSVfZBAgmo
X-IronPort-AV: E=Sophos;i="4.75,487,1330902000"; 
   d="scan'208";a="981960579"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH RESEND 7/7] staging: sm7xx: rename function
Date: Thu, 26 Apr 2012 20:45:55 +0200
Message-Id: <1335465955-32057-8-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20120425205532.GA9642@kroah.com>
References: <20120425205532.GA9642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the name of function cfb_blank to smtc_blank. This
function is not implemented like a generic function for frame buffer.
Having the old prefix becomes confused when reading fb_ops structs.

Tested with SM712

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 83756a8..746c4cd 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -266,7 +266,7 @@ static inline unsigned int chan_to_field(unsigned int chan,
 	return chan << bf->offset;
 }
 
-static int cfb_blank(int blank_mode, struct fb_info *info)
+static int smtc_blank(int blank_mode, struct fb_info *info)
 {
 	/* clear DPMS setting */
 	switch (blank_mode) {
@@ -653,7 +653,7 @@ static struct fb_ops smtcfb_ops = {
 	.fb_check_var = smtc_check_var,
 	.fb_set_par   = smtc_set_par,
 	.fb_setcolreg = smtc_setcolreg,
-	.fb_blank     = cfb_blank,
+	.fb_blank     = smtc_blank,
 	.fb_fillrect  = cfb_fillrect,
 	.fb_imageblit = cfb_imageblit,
 	.fb_copyarea  = cfb_copyarea,
-- 
1.7.2.5

