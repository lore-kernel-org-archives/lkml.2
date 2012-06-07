Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174Ab2FGIxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:53:33 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:35993 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2FGIxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:53:30 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApxoAFxr0E9V5qg+PGdsb2JhbABFigmqEhkBAQEBNzSCdRMBDxiBAgoaE4gPuHsUix6FcwOaf4x6gVU
X-IronPort-AV: E=Sophos;i="4.75,730,1330902000"; 
   d="scan'208";a="130206768"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] hwmon: (applesmc) Limit key length in warning messages
Date: Thu,  7 Jun 2012 10:54:29 +0200
Message-Id: <1339059269-383-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Key lookups may call read_smc() with a fixed-length key string,
and if the lookup fails, trailing stack content may appear in the
kernel log. Fixed with this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index f082e48..70d62f5 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -215,7 +215,7 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 	int i;
 
 	if (send_command(cmd) || send_argument(key)) {
-		pr_warn("%s: read arg fail\n", key);
+		pr_warn("%.4s: read arg fail\n", key);
 		return -EIO;
 	}
 
@@ -223,7 +223,7 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 
 	for (i = 0; i < len; i++) {
 		if (__wait_status(0x05)) {
-			pr_warn("%s: read data fail\n", key);
+			pr_warn("%.4s: read data fail\n", key);
 			return -EIO;
 		}
 		buffer[i] = inb(APPLESMC_DATA_PORT);
-- 
1.7.10.3

