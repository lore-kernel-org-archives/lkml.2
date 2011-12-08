Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1LHIpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:45:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44353 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1LHIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:45:44 -0500
Message-ID: <1323333920.10774.1.camel@phoenix>
Subject: [PATCH] mfd: Avoid writing uninitialized value to device
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 08 Dec 2011 16:45:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid writing uninitialized value to device by explicitly initialize
zero to 0.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/88pm860x-i2c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index e017dc8..fcde8a3 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -151,7 +151,7 @@ int pm860x_page_reg_write(struct i2c_client *i2c, int reg,
 			  unsigned char data)
 {
 	struct pm860x_chip *chip = i2c_get_clientdata(i2c);
-	unsigned char zero;
+	unsigned char zero = 0;
 	int ret;
 
 	mutex_lock(&chip->io_lock);
@@ -208,7 +208,7 @@ int pm860x_page_set_bits(struct i2c_client *i2c, int reg,
 			 unsigned char mask, unsigned char data)
 {
 	struct pm860x_chip *chip = i2c_get_clientdata(i2c);
-	unsigned char zero;
+	unsigned char zero = 0;
 	unsigned char value;
 	int ret;
 
-- 
1.7.5.4



