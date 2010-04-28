Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab0D1KZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 06:25:32 -0400
Received: from server78.greatnet.de ([83.133.96.102]:35024 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab0D1KZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 06:25:26 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: linux-fbdev@vger.kernel.org
Cc: ralf@linux-mips.org, arnaud.patard@rtp-net.org, jayakumar.lkml@gmail.com,
       gregkh@suse.de, yuasa@linux-mips.org, lethal@linux-sh.org,
       akpm@linux-foundation.org, adobriyan@gmail.com, support@simtec.co.uk,
       ben@simtec.co.uk, linux@simtec.co.uk, jkosina@suse.cz,
       pjones@redhat.com, linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 2/4] hitfb: correct sections
Date: Wed, 28 Apr 2010 12:25:03 +0200
Message-Id: <1272450305-7284-2-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1272450305-7284-1-git-send-email-henne@nachtwindheim.de>
References: <1272450305-7284-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the drivers probe call was changed from .init.text
to .devinit.text in commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b
the fb_fix_screeninfo and fb_var_screeninfo structures must be
changed from .init.data to .devinit.data, too.

Also the drivers remove routine should be moved from
.exit.text to .devexit.text

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
It would be nice if someone with a SH gcc could test this patch and
give me some feedback if it works the way it should, since atm I'm lacking
a crosscompiler setup.
---
 drivers/video/hitfb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/hitfb.c b/drivers/video/hitfb.c
index 393f3f3..cfb8d64 100644
--- a/drivers/video/hitfb.c
+++ b/drivers/video/hitfb.c
@@ -30,14 +30,14 @@
 
 #define	WIDTH 640
 
-static struct fb_var_screeninfo hitfb_var __initdata = {
+static struct fb_var_screeninfo hitfb_var __devinitdata = {
 	.activate	= FB_ACTIVATE_NOW,
 	.height		= -1,
 	.width		= -1,
 	.vmode		= FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo hitfb_fix __initdata = {
+static struct fb_fix_screeninfo hitfb_fix __devinitdata = {
 	.id		= "Hitachi HD64461",
 	.type		= FB_TYPE_PACKED_PIXELS,
 	.accel		= FB_ACCEL_NONE,
@@ -417,7 +417,7 @@ err_fb:
 	return ret;
 }
 
-static int __exit hitfb_remove(struct platform_device *dev)
+static int __devexit hitfb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 
@@ -462,7 +462,7 @@ static const struct dev_pm_ops hitfb_dev_pm_ops = {
 
 static struct platform_driver hitfb_driver = {
 	.probe		= hitfb_probe,
-	.remove		= __exit_p(hitfb_remove),
+	.remove		= __devexit_p(hitfb_remove),
 	.driver		= {
 		.name	= "hitfb",
 		.owner	= THIS_MODULE,
-- 
1.7.0

