Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0JTGwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:52:17 -0400
Received: from mail.perches.com ([173.55.12.10]:3227 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758417Ab0JTGwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:52:12 -0400
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/32] drivers/hwmon/ibmaem.c: Use pr_fmt and pr_<level>
Date: Tue, 19 Oct 2010 23:51:38 -0700
Message-Id: <49a48933aca71fbd388f438b6c24791a895e886c.1287556801.git.joe@perches.com>
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
 drivers/hwmon/ibmaem.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index eaee546..bc6e2ab 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -20,6 +20,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/ipmi.h>
 #include <linux/module.h>
 #include <linux/hwmon.h>
@@ -1090,7 +1092,7 @@ static int __init aem_init(void)
 
 	res = driver_register(&aem_driver.driver);
 	if (res) {
-		printk(KERN_ERR "Can't register aem driver\n");
+		pr_err("Can't register aem driver\n");
 		return res;
 	}
 
-- 
1.7.3.1.g432b3.dirty

