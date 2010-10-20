Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab0JTGye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:54:34 -0400
Received: from mail.perches.com ([173.55.12.10]:3245 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab0JTGwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:15 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/32] drivers/hwmon/pcf8591.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:45 -0700
Message-Id: <e021d63730a851db5af583961145f95217f1787d.1287556801.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <20101020035346.GA20178@ericsson.com>
References: <20101020035346.GA20178@ericsson.com>
In-Reply-To: <cover.1287556800.git.joe@perches.com>
References: <cover.1287556800.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt KBUILD_MODNAME ": " fmt
Converted printks to pr_<level>
Coalesced any long formats
Removed prefixes from formats

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hwmon/pcf8591.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pcf8591.c b/drivers/hwmon/pcf8591.c
index dc7259d..731b09a 100644
--- a/drivers/hwmon/pcf8591.c
+++ b/drivers/hwmon/pcf8591.c
@@ -18,6 +18,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -290,8 +292,7 @@ static struct i2c_driver pcf8591_driver = {
 static int __init pcf8591_init(void)
 {
 	if (input_mode < 0 || input_mode > 3) {
-		printk(KERN_WARNING "pcf8591: invalid input_mode (%d)\n",
-		       input_mode);
+		pr_warn("invalid input_mode (%d)\n", input_mode);
 		input_mode = 0;
 	}
 	return i2c_add_driver(&pcf8591_driver);
-- 
1.7.3.1.g432b3.dirty

