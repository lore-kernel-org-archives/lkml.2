Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0G3C7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 22:59:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55094 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab0G3C7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 22:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rAJxka5DRbymVzgSNCKzTt6cE2WIGzH8EFvVTBPLsao+ld+Kbb+EsTYd53AZ0tiY8G
         J8VGd8sc6uZLKDJL8+owNfQnacBmvQicDlc8riHjskMVzvH4zAPXVFOxzp2ghEeMdnJ/
         QyN2stcEUBQnFluAruEGjhC9qw3gOVU6LaL3A=
Subject: [PATCH] jornada720_bl/jornada720_lcd: make needlessly global
	symbols static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 30 Jul 2010 11:00:23 +0800
Message-Id: <1280458823.7632.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following symbols are needlessly defined global:
jornada_bl_init
jornada_bl_exit
jornada_lcd_init
jornada_lcd_exit

This patch makes the symbols static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/jornada720_bl.c  |    4 ++--
 drivers/video/backlight/jornada720_lcd.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 60e1d28..a20a01a 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -146,12 +146,12 @@ static struct platform_driver jornada_bl_driver = {
 	},
 };
 
-int __init jornada_bl_init(void)
+static int __init jornada_bl_init(void)
 {
 	return platform_driver_register(&jornada_bl_driver);
 }
 
-void __exit jornada_bl_exit(void)
+static void __exit jornada_bl_exit(void)
 {
 	platform_driver_unregister(&jornada_bl_driver);
 }
diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index 8fe0181..9fd7af2 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -135,12 +135,12 @@ static struct platform_driver jornada_lcd_driver = {
 	},
 };
 
-int __init jornada_lcd_init(void)
+static int __init jornada_lcd_init(void)
 {
 	return platform_driver_register(&jornada_lcd_driver);
 }
 
-void __exit jornada_lcd_exit(void)
+static void __exit jornada_lcd_exit(void)
 {
 	platform_driver_unregister(&jornada_lcd_driver);
 }
-- 
1.5.4.3



