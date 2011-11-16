Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1KPJFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:05:21 -0500
Received: from fallback7.mail.ru ([94.100.176.135]:36037 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1KPJFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:05:19 -0500
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Nov 2011 04:05:19 EST
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog: fix initialisation printout in s3c2410_wdt
Date: Wed, 16 Nov 2011 12:46:13 +0400
Message-Id: <1321433173-17757-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.4.rc3
X-Spam: Not detected
X-Mras: Ok
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a typo creeped in, and driver prints
s3c2410-wdt s3c2410-wdt: watchdog active, reset abled, irq abled

instead of
s3c2410-wdt s3c2410-wdt: watchdog active, reset enabled, irq enabled

Also it may completely disinform about irq status, as it prints
"irq enabled" when S3C2410_WTCON_INTEN is in fact 0.

Fix it.

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---

It seems to be here for a long time, but I don't think it's
important enough for cc-ing stable.

Also I haven't tested it, as I don't have a hardware, but it's
rather trivial (and yes, I checked with datasheet that 1 in
S3C2410_WTCON_*EN bits really means 'enabled')

 drivers/watchdog/s3c2410_wdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 5de7e4f..a79e384 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -401,8 +401,8 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 	dev_info(dev, "watchdog %sactive, reset %sabled, irq %sabled\n",
 		 (wtcon & S3C2410_WTCON_ENABLE) ?  "" : "in",
-		 (wtcon & S3C2410_WTCON_RSTEN) ? "" : "dis",
-		 (wtcon & S3C2410_WTCON_INTEN) ? "" : "en");
+		 (wtcon & S3C2410_WTCON_RSTEN) ? "en" : "dis",
+		 (wtcon & S3C2410_WTCON_INTEN) ? "en" : "dis");
 
 	return 0;
 
-- 
1.7.5.1.300.gc565c

