Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab2INEkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 00:40:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2INEkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 00:40:43 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Kevin McKinney <klmckinney1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] Staging: bcm: Fix udelay related compilation error
Date: Fri, 14 Sep 2012 10:07:33 +0530
Message-Id: <1347597453-19443-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6788d7dab6a5 ("Staging: bcm: Use udelay instead of msleep for
delays in nvm.c") replaces msleep with udelay values. udelay values
of more than 1000 should be replaced by mdelay instead.

This fixes following build error.
ERROR: "__bad_udelay" [drivers/staging/bcm/bcm_wimax.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Cc: Kevin McKinney <klmckinney1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/staging/bcm/nvm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index b179dba..921e25e 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -577,7 +577,7 @@ static int FlashSectorErase(struct bcm_mini_adapter *Adapter,
 			 * the sector erase cycle is 500 ms to 40000 msec. hence sleeping 10 ms
 			 * won't hamper performance in any case.
 			 */
-			udelay(10000);
+			mdelay(10);
 		} while ((uiStatus & 0x1) && (iRetries < 400));
 
 		if (uiStatus & 0x1) {
-- 
1.7.4.1

