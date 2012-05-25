Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2EYJvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:51:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:36401 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2EYJvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:51:40 -0400
From: <jgq516@gmail.com>
To: <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <rnayak@ti.com>, <tony@atomide.com>,
        <wim@iguana.be>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-watchdog@vger.kernel.org>
Subject: [PATCH 3/3] watchdog: omap_wdt: add device tree support
Date: Fri, 25 May 2012 18:42:32 +0800
Message-ID: <1337942552-28218-4-git-send-email-jgq516@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1337942552-28218-1-git-send-email-jgq516@gmail.com>
References: <1337942552-28218-1-git-send-email-jgq516@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Jiang <jgq516@gmail.com>

Add device table for omap_wdt to support dt.

Signed-off-by: Xiao Jiang <jgq516@gmail.com>
---
 drivers/watchdog/omap_wdt.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 8285d65..d98c615 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -430,6 +430,13 @@ static int omap_wdt_resume(struct platform_device *pdev)
 #define	omap_wdt_resume		NULL
 #endif
 
+static const struct of_device_id omap_wdt_of_match[] = {
+	{ .compatible = "ti,omap3-wdt", },
+	{ .compatible = "ti,omap4-wdt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_wdt_of_match);
+
 static struct platform_driver omap_wdt_driver = {
 	.probe		= omap_wdt_probe,
 	.remove		= __devexit_p(omap_wdt_remove),
@@ -439,6 +446,7 @@ static struct platform_driver omap_wdt_driver = {
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "omap_wdt",
+		.of_match_table = omap_wdt_of_match,
 	},
 };
 
-- 
1.7.3

