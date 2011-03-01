Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1CAVfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:35:55 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:47346 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab1CAVfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:35:54 -0500
Date: Tue, 1 Mar 2011 13:35:48 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] jz4740: silence warnings related to mfd_get_cell changes
Message-ID: <20110301133548.6acb5170@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mfd_get_cell returns a const, so change the jz4740 clients to store
a const mfd cell.  This silences type mismatch warnings.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/hwmon/jz4740-hwmon.c   |    2 +-
 drivers/power/jz4740-battery.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
index 40f106d..fea292d 100644
--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -32,7 +32,7 @@ struct jz4740_hwmon {
 
 	int irq;
 
-	struct mfd_cell *cell;
+	const struct mfd_cell *cell;
 	struct device *hwmon;
 
 	struct completion read_completion;
diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 0938650..763f894 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -39,7 +39,7 @@ struct jz_battery {
 	int irq;
 	int charge_irq;
 
-	struct mfd_cell *cell;
+	const struct mfd_cell *cell;
 
 	int status;
 	long voltage;
-- 
1.7.2.3

