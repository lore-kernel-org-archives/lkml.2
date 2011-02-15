Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1BOP5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:57:23 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:56310 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1BOP5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:57:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PUgtDUJT+uYY0Vd/ySbH3CpaJtotp44mQltrWUrEnKRf2nfV4ro+4ooftIa2yxTu1p
         kpcsiTDShW2cwcA2ESiAoqdgfk08cfm3aZuzGbdc9faLKJTnY4s0hBWNSfhBlBRueSXk
         RSjMkCV792H6rykkK5blCpbT1sVbkBeB5t0PU=
Subject: [PATCH RESEND] backlight: jornada720_bl/jornada720_lcd: make
 needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 23:57:12 +0800
Message-ID: <1297785432.2596.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
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
Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
---
It was sent on https://lkml.org/lkml/2010/7/29/460
with Kristoffer's ack http://lkml.org/lkml/2010/7/30/694

Axel

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



