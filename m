Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab2AUHIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 02:08:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41208 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2AUHIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 02:08:45 -0500
Message-ID: <1327129718.24831.3.camel@phoenix>
Subject: [PATCH] watchdog: via_wdt: Set min_timeout and max_timeout for
 wdt_dev
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marc Vertes <marc.vertes@sigfox.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Date: Sat, 21 Jan 2012 15:08:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the watchdog core to check the valid value range of min_timeout/max_timeout.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/via_wdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
index 8b24b00..8f07dd4 100644
--- a/drivers/watchdog/via_wdt.c
+++ b/drivers/watchdog/via_wdt.c
@@ -124,8 +124,6 @@ static int wdt_stop(struct watchdog_device *wdd)
 static int wdt_set_timeout(struct watchdog_device *wdd,
 			   unsigned int new_timeout)
 {
-	if (new_timeout < 1 || new_timeout > WDT_TIMEOUT_MAX)
-		return -EINVAL;
 	writel(new_timeout, wdt_mem + VIA_WDT_COUNT);
 	timeout = new_timeout;
 	return 0;
@@ -150,6 +148,8 @@ static const struct watchdog_ops wdt_ops = {
 static struct watchdog_device wdt_dev = {
 	.info =		&wdt_info,
 	.ops =		&wdt_ops,
+	.min_timeout =	1,
+	.max_timeout =	WDT_TIMEOUT_MAX,
 };
 
 static int __devinit wdt_probe(struct pci_dev *pdev,
-- 
1.7.5.4



