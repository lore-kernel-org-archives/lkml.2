Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1C2GdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:33:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42041 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1C2Gc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jv1FOD6Qc09RAihaXArfeiA8U1f+0Bo64EEucT1zUTUapmyeI5j+9sol5kB+xA5Kri
         +3iXBPpkrF+nU5ixXhExSuSbZ48IQHy+G1drBv3Gbjz8H58FYeWDyFCjb5VYlNETOFJm
         0GuXHInmFcXvDZcSnocJYIY4B4lGE38ZFMees=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net, esta1ien@gmail.com,
        buserror@gmail.com, Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/4] s3c2440: mini2440: Add support for new LCD panels.
Date: Tue, 29 Mar 2011 08:32:40 +0200
Message-Id: <1301380363-3282-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301380363-3282-1-git-send-email-marek.belisko@open-nandra.com>
References: <1301380363-3282-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for new mini2440 board LCD's:
3.5" TFT + TS (TD035STED4)
5.6" TFT (Innolux AT056TN52).
3.5" TFT + TS (SONY X35)

Values overtaken from mini2440 kernel:
git://repo.or.cz/linux-2.6/mini2440.git
and https://github.com/a1ien/mini2440-linux-kernel

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/mach-s3c2440/mach-mini2440.c |   37 +++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c b/arch/arm/mach-s3c2440/mach-mini2440.c
index dfedc9c..ce152b4 100644
--- a/arch/arm/mach-s3c2440/mach-mini2440.c
+++ b/arch/arm/mach-s3c2440/mach-mini2440.c
@@ -167,6 +167,43 @@ static struct s3c2410fb_display mini2440_lcd_cfg[] __initdata = {
 		.lcdcon5	= (S3C2410_LCDCON5_FRM565 |
 				   S3C2410_LCDCON5_HWSWP),
 	},
+	[3] = {	/* mini2440 + 3.5" TFT + TS -- New model as Nov 2009 "T35" */
+		_LCD_DECLARE(
+			7,			/* The 3.5 is quite fast */
+			240, 21, 25, 6,		/* x timing */
+			320, 2, 4, 2,		/* y timing */
+			40),			/* refresh rate */
+		.lcdcon5	= (S3C2410_LCDCON5_FRM565 |
+				   S3C2410_LCDCON5_INVVLINE |
+				   S3C2410_LCDCON5_INVVFRAME |
+				   S3C2410_LCDCON5_INVVDEN |
+				   S3C2410_LCDCON5_PWREN),
+	},
+	[4] = { /* mini2440 + 5.6" TFT + touchscreen -- Innolux AT056TN52 */
+		/* be sure the "power" jumper is set accordingly ! */
+		_LCD_DECLARE(
+			10,			/* the 5.3" runs slower */
+			640, 41, 68, 22,	/* x timing */
+			480, 26, 6, 2,		/* y timing */
+			40),			/* refresh rate */
+		.lcdcon5	= (S3C2410_LCDCON5_FRM565 |
+				   S3C2410_LCDCON5_INVVLINE |
+				   S3C2410_LCDCON5_INVVFRAME |
+				   S3C2410_LCDCON5_PWREN),
+	},
+	[5] = { /* mini2440 + 3,5" TFT + touchscreen -- SONY X35 */
+		_LCD_DECLARE(
+			7,
+			240, 1, 26, 5,		/* x timing */
+			320, 1, 5, 9,		/* y timing */
+			60),			/* refresh rate */
+		.lcdcon5	= (S3C2410_LCDCON5_FRM565 |
+					S3C2410_LCDCON5_INVVDEN |
+					S3C2410_LCDCON5_INVVFRAME |
+					S3C2410_LCDCON5_INVVLINE |
+					S3C2410_LCDCON5_INVVCLK |
+					S3C2410_LCDCON5_HWSWP),
+	},
 };
 
 /* todo - put into gpio header */
-- 
1.7.1

