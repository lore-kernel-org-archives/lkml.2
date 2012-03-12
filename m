Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2CLCMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 22:12:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50303 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2CLCMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 22:12:41 -0400
Message-ID: <1331518354.2558.3.camel@phoenix>
Subject: [PATCH] mfd: sm501: Use DIV_ROUND_CLOSEST
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Samuel Ortiz <sameo@linux.intel.com>
Date: Mon, 12 Mar 2012 10:12:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_CLOSEST to replace sm501fb_round_div function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/sm501.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index f4d8611..d927dd4 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -387,14 +387,6 @@ int sm501_unit_power(struct device *dev, unsigned int unit, unsigned int to)
 
 EXPORT_SYMBOL_GPL(sm501_unit_power);
 
-
-/* Perform a rounded division. */
-static long sm501fb_round_div(long num, long denom)
-{
-        /* n / d + 1 / 2 = (2n + d) / 2d */
-        return (2 * num + denom) / (2 * denom);
-}
-
 /* clock value structure. */
 struct sm501_clock {
 	unsigned long mclk;
@@ -428,7 +420,7 @@ static int sm501_calc_clock(unsigned long freq,
 		/* try all 8 shift values.*/
 		for (shift = 0; shift < 8; shift++) {
 			/* Calculate difference to requested clock */
-			diff = sm501fb_round_div(mclk, divider << shift) - freq;
+			diff = DIV_ROUND_CLOSEST(mclk, divider << shift) - freq;
 			if (diff < 0)
 				diff = -diff;
 
-- 
1.7.5.4



