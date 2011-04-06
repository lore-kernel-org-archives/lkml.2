Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1DFNB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:01:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48445 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab1DFNB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=q6BvCnNodnniJIV+TpDW5VmfSpUfEgFOmQmYoF0Nusr0YWfqEA/bHERwYaY9dR3leV
         fAQbA0EOAVbKhneWGp+dWqyTbIW9EtuVPMYqQS16xAJeYjQESqs1rpRHb4e190UQlEFQ
         ZXBp5qA2/qRv/0dF2Mfj4+q0gXjz8KcsPIz9g=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, esta1ien@gmail.com, buserror@gmail.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 1/4] s3c2440: mini2440: Add support for new LCD panels.
Date: Wed,  6 Apr 2011 15:01:34 +0200
Message-Id: <1302094897-18446-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
References: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
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

