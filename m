Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1K2LvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:51:14 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:22749 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427Ab1K2LvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:51:12 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKfE1E5R8sT5/2dsb2JhbABDqnSBBoFyAQEEAScTHCMFCwgDDjgUJQMhARKIBQK3DxKKKWMElFOSEw
Date: Tue, 29 Nov 2011 12:47:44 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marc Vertes <marc.vertes@sigfox.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: [PATCH] watchdog: add nowayout helpers to Watchdog Timer
	Driver Kernel API
Message-ID: <20111129114744.GA21542@infomag.iguana.be>
References: <20111129111430.GA17609@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129111430.GA17609@infomag.iguana.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc, Wolfram,

> Add two nowayout helpers for the Watchdog Timer Driver Kernel API.
> 
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

And this would give following patch for your drivers (see below).

Kind regards,
Wim.
---
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index a79e384..4bc3744 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -378,6 +378,8 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 							"cannot start\n");
 	}
 
+	watchdog_set_nowayout(&s3c2410_wdd, nowayout);
+
 	ret = watchdog_register_device(&s3c2410_wdd);
 	if (ret) {
 		dev_err(dev, "cannot register watchdog (%d)\n", ret);
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index beb3ad2..6cd1ba4 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -213,11 +213,9 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 
 	wm831x_wdt->info = &wm831x_wdt_info;
 	wm831x_wdt->ops = &wm831x_wdt_ops;
+	watchdog_set_nowayout(wm831x_wdt, nowayout);
 	watchdog_set_drvdata(wm831x_wdt, driver_data);
 
-	if (nowayout)
-		wm831x_wdt->status |= WDOG_NO_WAY_OUT;
-
 	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
 	reg &= WM831X_WDOG_TO_MASK;
 	for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
