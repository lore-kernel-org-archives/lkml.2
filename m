Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab2FAD51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 23:57:27 -0400
Received: from mail1.windriver.com ([147.11.146.13]:37764 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab2FAD50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 23:57:26 -0400
From: <jgq516@gmail.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <wim@iguana.be>, <jon-hunter@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-watchdog@vger.kernel.org>
Subject: [PATCHv2 3/3] watchdog: omap_wdt: add device tree support
Date: Fri, 1 Jun 2012 12:44:16 +0800
Message-ID: <1338525856-4359-4-git-send-email-jgq516@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1338525856-4359-1-git-send-email-jgq516@gmail.com>
References: <1338525856-4359-1-git-send-email-jgq516@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Jiang <jgq516@gmail.com>

Add device table for omap_wdt to support dt.

Signed-off-by: Xiao Jiang <jgq516@gmail.com>
---
 drivers/watchdog/omap_wdt.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 8285d65..02ebfd5 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -430,6 +430,12 @@ static int omap_wdt_resume(struct platform_device *pdev)
 #define	omap_wdt_resume		NULL
 #endif
 
+static const struct of_device_id omap_wdt_of_match[] = {
+	{ .compatible = "ti,omap3-wdt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_wdt_of_match);
+
 static struct platform_driver omap_wdt_driver = {
 	.probe		= omap_wdt_probe,
 	.remove		= __devexit_p(omap_wdt_remove),
@@ -439,6 +445,7 @@ static struct platform_driver omap_wdt_driver = {
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "omap_wdt",
+		.of_match_table = omap_wdt_of_match,
 	},
 };
 
-- 
1.7.3

