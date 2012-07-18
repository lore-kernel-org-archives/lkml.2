Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab2GRNUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:20:32 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:55488 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751871Ab2GRNUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:20:31 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 1/2] drivers/rtc/rtc-pcf8563.c: set owner field in driver struct.
Date: Wed, 18 Jul 2012 09:20:03 -0400
Message-Id: <1342617604-19516-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The owner member is supposed to be set to the module implementing the
device driver, i.e., THIS_MODULE.  This enables the appropriate module
link in sysfs.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 drivers/rtc/rtc-pcf8563.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 97a3284..24a9d6a 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -288,6 +288,7 @@ MODULE_DEVICE_TABLE(i2c, pcf8563_id);
 static struct i2c_driver pcf8563_driver = {
 	.driver		= {
 		.name	= "rtc-pcf8563",
+		.owner	= THIS_MODULE,
 	},
 	.probe		= pcf8563_probe,
 	.remove		= pcf8563_remove,
-- 
1.7.8.6


