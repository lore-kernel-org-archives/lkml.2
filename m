Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2GIKKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:10:30 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:57870 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2GIKK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:10:29 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhlOAGet+k9V5qg+PGdsb2JhbABFiiGtRxkBAQEBHhkNJ4J9EwEPGIECChoTiBG6KBSLLAmGAwObG40BgVQ
X-IronPort-AV: E=Sophos;i="4.77,552,1336341600"; 
   d="scan'208";a="77085417"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] hwmon: (applesmc) Shorten minimum wait time
Date: Mon,  9 Jul 2012 12:10:26 +0200
Message-Id: <1341828626-6543-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2012 series of MacBooks have a faster SMC, and the current driver
timings do not work at all. Tests show that decreasing the minimum
wait time, from 64 us to 16 us, works well. Since this is still larger
than the original minimum of 10 us used before 2008, there is nothing
inherently problematic with changing it. The fail frequency on older
machines seems to increase slightly, but not enough to be noticeable.

Tested on MBA11, MBA31, MBA5,2, MBP9,2.

The patch was originally written by adamski99 (ubuntuforums.org) and
later tested by janhouse (bbs.archlinux.org).

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Guenter,

This patch enables the mid-2012 MacBook models. The patch affects
older models slightly, but mostly in a good way; all models get
slightly faster reads, but some older models see a slight increase in
read fail frequency. I do not think this will be noticeable, but I
would hesitate to backport too far. For 3.6.

Thanks,
Henrik

 drivers/hwmon/applesmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 0162f55..f41585e 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -54,7 +54,7 @@
 #define APPLESMC_MAX_DATA_LENGTH 32
 
 /* wait up to 32 ms for a status change. */
-#define APPLESMC_MIN_WAIT	0x0040
+#define APPLESMC_MIN_WAIT	0x0010
 #define APPLESMC_MAX_WAIT	0x8000
 
 #define APPLESMC_STATUS_MASK	0x0f
-- 
1.7.11.1

