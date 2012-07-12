Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162729Ab2GLXXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:23:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162536Ab2GLXDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 16/68] hwmon: (applesmc) Limit key length in warning messages
Date: Thu, 12 Jul 2012 16:01:50 -0700
Message-Id: <20120712175036.868702085@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit ac852edb47b15900886ba2564eeeb13b3b526e3e upstream.

Key lookups may call read_smc() with a fixed-length key string,
and if the lookup fails, trailing stack content may appear in the
kernel log. Fixed with this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/applesmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -215,7 +215,7 @@ static int read_smc(u8 cmd, const char *
 	int i;
 
 	if (send_command(cmd) || send_argument(key)) {
-		pr_warn("%s: read arg fail\n", key);
+		pr_warn("%.4s: read arg fail\n", key);
 		return -EIO;
 	}
 
@@ -223,7 +223,7 @@ static int read_smc(u8 cmd, const char *
 
 	for (i = 0; i < len; i++) {
 		if (__wait_status(0x05)) {
-			pr_warn("%s: read data fail\n", key);
+			pr_warn("%.4s: read data fail\n", key);
 			return -EIO;
 		}
 		buffer[i] = inb(APPLESMC_DATA_PORT);


