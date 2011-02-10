Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1BJCtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:49:09 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:46584 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab1BJCtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:49:08 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: Grant Likely <grant.likely@secretlab.ca>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH] i2c-ocores: register devices on child nodes
Date: Thu, 10 Feb 2011 10:51:54 +0800
Message-Id: <1297306314-11483-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.4
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch registers devices on the devicetree child nodes to the bus.
Also removes one trailing whitespace.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 drivers/i2c/busses/i2c-ocores.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index ef3bcb1..c63838f 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -18,7 +18,7 @@
  * - interrupts      : interrupt number
  * - regstep         : size of device registers in bytes
  * - clock-frequency : frequency of bus clock in Hz
- * 
+ *
  * Example:
  *
  *  i2c0: ocores@a0000000 {
@@ -55,6 +55,7 @@
 #include <linux/i2c-ocores.h>
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/of_i2c.h>
 
 struct ocores_i2c {
 	void __iomem *base;
@@ -347,6 +348,9 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 			i2c_new_device(&i2c->adap, pdata->devices + i);
 	}
 
+	/* Now register all the child nodes */
+	of_i2c_register_devices(&i2c->adap);
+
 	return 0;
 }
 
-- 
1.7.4

