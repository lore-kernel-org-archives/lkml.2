Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2AMPVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:21:02 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:37024 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932549Ab2AMPU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:20:58 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 7/8] mfd/db8500-prcmu: remove check for firmware bug
Date: Fri, 13 Jan 2012 16:20:51 +0100
Message-ID: <1326468051-11900-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

In prcmu firmware version 3.4.4 the issue with longer
intervalls than 131 s was fixed, we don't expect the
issue to creep back up.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 8056968..0ee8015 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2184,16 +2184,8 @@ int db8500_prcmu_kick_a9wdog(u8 id)
 /*
  * timeout is 28 bit, in ms.
  */
-#define MAX_WATCHDOG_TIMEOUT 131000
 int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
 {
-	if (timeout > MAX_WATCHDOG_TIMEOUT)
-		/*
-		 * Due to calculation bug in prcmu fw, timeouts
-		 * can't be bigger than 131 seconds.
-		 */
-		return -EINVAL;
-
 	return prcmu_a9wdog(MB4H_A9WDOG_LOAD,
 			    (id & A9WDOG_ID_MASK) |
 			    /*
-- 
1.7.8

