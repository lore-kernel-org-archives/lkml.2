Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2BLQmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 11:42:08 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:35151
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755473Ab2BLQmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 11:42:06 -0500
Message-ID: <4F37EBEC.8060209@compulab.co.il>
Date: Sun, 12 Feb 2012 18:42:20 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] gpio: enable SUS_GPIO[3:0] resume powered gpio, explicitly
 on Intel SCH.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resume powered gpio pins SUS_GPIO[3:0] on Intel SCH may be
disabled by BIOS setting, need to enable them explicitly.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/gpio/gpio-sch.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 8cadf4d..f287016 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -218,10 +218,9 @@ static int __devinit sch_gpio_probe(struct platform_device *pdev)
 			 */
 			outb(0x3, gpio_ba + CGEN + 1);
 			/*
-			 * SUS_GPIO[2:0] enabled by default
-			 * Enable SUS_GPIO3 resume powered gpio explicitly
+			 * Enable SUS_GPIO[3:0] resume powered gpio explicitly
 			 */
-			outb(0x8, gpio_ba + RGEN);
+			outb(0xF, gpio_ba + RGEN);
 			break;
 
 		case PCI_DEVICE_ID_INTEL_ITC_LPC:
-- 
1.7.5.4

