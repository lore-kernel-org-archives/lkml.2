Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725Ab1KCBhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933604Ab1KCBhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.910604151@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Florian Fainelli <florian@openwrt.org>
Subject: [096/107] watchdog: mtx1-wdt: fix build failure
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Fainelli <florian@openwrt.org>

Commit 6d86a0ee (watchdog: mtx1-wdt: request gpio before using it) was
backported from upstream. The patch is using a gpiolib call which is only
available in kernel 2.6.34+. Fix build by using the "old" gpiolib API
instead.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/mtx-1_wdt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -211,13 +211,14 @@ static int __devinit mtx1_wdt_probe(stru
 	int ret;
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
-	ret = gpio_request_one(mtx1_wdt_device.gpio,
-				GPIOF_OUT_INIT_HIGH, "mtx1-wdt");
+	ret = gpio_request(mtx1_wdt_device.gpio, "mtx1-wdt");
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request gpio");
 		return ret;
 	}
 
+	gpio_direction_output(mtx1_wdt_device.gpio, 1);
+
 	spin_lock_init(&mtx1_wdt_device.lock);
 	init_completion(&mtx1_wdt_device.stop);
 	mtx1_wdt_device.queue = 0;


