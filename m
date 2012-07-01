Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2GASQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46898 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476Ab2GASQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:22 -0400
Message-Id: <20120701172007.558260503@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 06/48] hwmon: (applesmc) Limit key length in warning messages
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit ac852edb47b15900886ba2564eeeb13b3b526e3e upstream.

Key lookups may call read_smc() with a fixed-length key string,
and if the lookup fails, trailing stack content may appear in the
kernel log. Fixed with this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


