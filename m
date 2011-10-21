Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1JUKIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 06:08:17 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:58794 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab1JUKIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 06:08:16 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: rmallon@gmail.com, cbou@mail.ru, dwmw2@infradead.org,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH] power:ds2782 use swapped varient of i2c_smbus_read_word_data
Date: Fri, 21 Oct 2011 11:08:18 +0100
Message-Id: <1319191698-23745-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relies on: i2c: boilerplate function for byte swapped smbus_write/read_word_data

Ensures the error isn't mangled as a side effect.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
Note the patch introducing this fucntion is working its way through
the i2c tree.

 drivers/power/ds2782_battery.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index bfbce5d..a616954 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <linux/swab.h>
 #include <linux/i2c.h>
 #include <linux/idr.h>
 #include <linux/power_supply.h>
@@ -80,7 +79,7 @@ static inline int ds278x_read_reg16(struct ds278x_info *info, int reg_msb,
 {
 	int ret;
 
-	ret = swab16(i2c_smbus_read_word_data(info->client, reg_msb));
+	ret = i2c_smbus_read_word_data_swapped(info->client, reg_msb);
 	if (ret < 0) {
 		dev_err(&info->client->dev, "register read failed\n");
 		return ret;
-- 
1.7.7

