Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab1CBKvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:51:32 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:37034 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756834Ab1CBKvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:51:31 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] MFD: ab8500 chip revision 3.0 support
Date: Wed, 2 Mar 2011 11:51:11 +0100
Message-ID: <1299063071-26235-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for ab8500 chip revision cut 3.0.
Also rephrased from Changes to Author in the header.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c  |    9 +++++----
 include/linux/mfd/ab8500.h |    4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index b688701..8d6c292 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -4,7 +4,7 @@
  * License Terms: GNU General Public License v2
  * Author: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
  * Author: Rabin Vincent <rabin.vincent@stericsson.com>
- * Changes: Mattias Wallin <mattias.wallin@stericsson.com>
+ * Author: Mattias Wallin <mattias.wallin@stericsson.com>
  */
 
 #include <linux/kernel.h>
@@ -686,9 +686,10 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	 * 0x10 - Cut 1.0
 	 * 0x11 - Cut 1.1
 	 * 0x20 - Cut 2.0
+	 * 0x30 - Cut 3.0
 	 */
-	if (value == 0x0 || value == 0x10 || value == 0x11 || value == 0x20) {
-		ab8500->revision = value;
+	if (value == 0x0 || value == 0x10 || value == 0x11 || value == 0x20 ||
+		value == 0x30) {
 		dev_info(ab8500->dev, "detected chip, revision: %#x\n", value);
 	} else {
 		dev_err(ab8500->dev, "unknown chip, revision: %#x\n", value);
@@ -764,6 +765,6 @@ int __devexit ab8500_exit(struct ab8500 *ab8500)
 	return 0;
 }
 
-MODULE_AUTHOR("Srinidhi Kasagar, Rabin Vincent");
+MODULE_AUTHOR("Mattias Wallin, Srinidhi Kasagar, Rabin Vincent");
 MODULE_DESCRIPTION("AB8500 MFD core");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index 37f56b7..56f8dea 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -111,8 +111,8 @@
  * @dev: parent device
  * @lock: read/write operations lock
  * @irq_lock: genirq bus lock
- * @revision: chip revision
  * @irq: irq line
+ * @chip_id: chip revision id
  * @write: register write
  * @read: register read
  * @rx_buf: rx buf for SPI
@@ -124,7 +124,7 @@ struct ab8500 {
 	struct device	*dev;
 	struct mutex	lock;
 	struct mutex	irq_lock;
-	int		revision;
+
 	int		irq_base;
 	int		irq;
 	u8		chip_id;
-- 
1.7.4.1

