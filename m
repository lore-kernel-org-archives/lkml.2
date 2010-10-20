Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab0JTGwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:52:10 -0400
Received: from mail.perches.com ([173.55.12.10]:3199 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758277Ab0JTGwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:06 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/32] drivers/hwmon/adt7470.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:27 -0700
Message-Id: <80655c9b7f3a081126cde1ab505f7326fb65c583.1287556801.git.joe@perches.com>
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
 drivers/hwmon/adt7470.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 9e77571..fc5da44 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/i2c.h>
@@ -274,7 +276,7 @@ static int adt7470_read_temperatures(struct i2c_client *client,
 	i2c_smbus_write_byte_data(client, ADT7470_REG_PWM_CFG(2), pwm_cfg[1]);
 
 	if (res) {
-		printk(KERN_ERR "ha ha, interrupted");
+		pr_err("ha ha, interrupted\n");
 		return -EAGAIN;
 	}
 
-- 
1.7.3.1.g432b3.dirty

