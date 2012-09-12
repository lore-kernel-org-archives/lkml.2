Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2ILJnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:43:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57932 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2ILJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:43:40 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH] at24: make module parameters changeable via sysfs
Date: Wed, 12 Sep 2012 11:43:32 +0200
Message-Id: <1347443012-21302-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The respective values are evaluated at each read/write, so no further
action is required than to change the perm argument to module_param.

Note there is no sanity check so root can make the driver effectively
unusable but that's what root is for :-)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/misc/eeprom/at24.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index ab1ad41..8a5a192 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -85,7 +85,7 @@ struct at24_data {
  * This value is forced to be a power of two so that writes align on pages.
  */
 static unsigned io_limit = 128;
-module_param(io_limit, uint, 0);
+module_param(io_limit, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(io_limit, "Maximum bytes per I/O (default 128)");
 
 /*
@@ -93,7 +93,7 @@ MODULE_PARM_DESC(io_limit, "Maximum bytes per I/O (default 128)");
  * it's important to recover from write timeouts.
  */
 static unsigned write_timeout = 25;
-module_param(write_timeout, uint, 0);
+module_param(write_timeout, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(write_timeout, "Time (in ms) to try writes (default 25)");
 
 #define AT24_SIZE_BYTELEN 5
-- 
1.7.10.4

