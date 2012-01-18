Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2ARLZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:25:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58551 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2ARLZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:25:12 -0500
Message-ID: <1326885901.2984.1.camel@phoenix>
Subject: [PATCH 1/2] watchdog: wm8350_wdt: Fix handling
 WDIOS_DISABLECARD/WDIOS_ENABLECARD options
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Date: Wed, 18 Jan 2012 19:25:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While receiving WDIOS_DISABLECARD option for WDIOC_SETOPTIONS command,
call wm8350_wdt_stop() to disable watchdog.
Call wm8350_wdt_start() while receiving WDIOS_ENABLECARD option.

Current code has reverse behavior.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/wm8350_wdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index 909c786..5d7113c 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -212,10 +212,10 @@ static long wm8350_wdt_ioctl(struct file *file, unsigned int cmd,
 
 		/* Setting both simultaneously means at least one must fail */
 		if (options == WDIOS_DISABLECARD)
-			ret = wm8350_wdt_start(wm8350);
+			ret = wm8350_wdt_stop(wm8350);
 
 		if (options == WDIOS_ENABLECARD)
-			ret = wm8350_wdt_stop(wm8350);
+			ret = wm8350_wdt_start(wm8350);
 		break;
 	}
 
-- 
1.7.5.4



