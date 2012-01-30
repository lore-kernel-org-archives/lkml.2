Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2A3WHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:07:19 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:47579 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab2A3WHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:07:15 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Antonino Daplas <adaplas@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] riva/fbdev: fix several -Wuninitialized
Date: Mon, 30 Jan 2012 23:00:17 +0100
Message-Id: <1327960820-11867-14-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327961235;03cfd146;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix several -Wuninitialized compiler warnings by changing the
order of getting modedb in riva_update_default_var() to set
first the fallback and then the prefered timing.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/video/riva/fbdev.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 2f58cf9..90df1a6 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -1816,6 +1816,8 @@ static void __devinit riva_update_default_var(struct fb_var_screeninfo *var,
 			     specs->modedb, specs->modedb_len,
 			     NULL, 8);
 	} else if (specs->modedb != NULL) {
+		/* get first mode in database as fallback */
+		modedb = specs->modedb[0];
 		/* get preferred timing */
 		if (info->monspecs.misc & FB_MISC_1ST_DETAIL) {
 			int i;
@@ -1826,9 +1828,6 @@ static void __devinit riva_update_default_var(struct fb_var_screeninfo *var,
 					break;
 				}
 			}
-		} else {
-			/* otherwise, get first mode in database */
-			modedb = specs->modedb[0];
 		}
 		var->bits_per_pixel = 8;
 		riva_update_var(var, &modedb);
-- 
1.7.7.3

