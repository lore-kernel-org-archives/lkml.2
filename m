Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1GKLhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:37:47 -0400
Received: from mx1.emlix.com ([193.175.82.238]:37201 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab1GKLhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:37:46 -0400
X-Greylist: delayed 2361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jul 2011 07:37:46 EDT
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: "George G. Davis" <gdavis@mvista.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH] rtc-omap: Fix initialization of control register
Date: Mon, 11 Jul 2011 12:57:46 +0200
Message-Id: <1310381866-25584-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the comment explains, the intention of the code is to clear the
OMAP_RTC_CTRL_MODE_12_24 bit, but instead it only clears the
OMAP_RTC_CTRL_SPLIT and OMAP_RTC_CTRL_AUTO_COMP bits, which should be
kept. OMAP_RTC_CTRL_DISABLE, OMAP_RTC_CTRL_SET_32_COUNTER,
OMAP_RTC_CTRL_TEST, and OMAP_RTC_CTRL_ROUND_30S are also better off
being cleared.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/rtc/rtc-omap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index bcae8dd..7789002 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -368,7 +368,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		pr_info("%s: already running\n", pdev->name);
 
 	/* force to 24 hour mode */
-	new_ctrl = reg & ~(OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
+	new_ctrl = reg & (OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
 	new_ctrl |= OMAP_RTC_CTRL_STOP;
 
 	/* BOARD-SPECIFIC CUSTOMIZATION CAN GO HERE:
-- 
1.7.1

