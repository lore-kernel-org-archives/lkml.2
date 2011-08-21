Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1HUHBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 03:01:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55253 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1HUHBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 03:01:49 -0400
Subject: [PATCH] power_supply: s3c_adc_battery: Needs module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Aug 2011 15:01:41 +0800
Message-ID: <1313910101.15589.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power/s3c_adc_battery:.c uses interfaces from linux/module.h,
so it should include that file.

This patch fixes below build error:

  CC      drivers/power/s3c_adc_battery.o
drivers/power/s3c_adc_battery.c:435: error: expected declaration specifiers or '...' before string constant
drivers/power/s3c_adc_battery.c:435: warning: data definition has no type or storage class
drivers/power/s3c_adc_battery.c:435: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/power/s3c_adc_battery.c:435: warning: function declaration isn't a prototype
drivers/power/s3c_adc_battery.c:436: error: expected declaration specifiers or '...' before string constant
drivers/power/s3c_adc_battery.c:436: warning: data definition has no type or storage class
drivers/power/s3c_adc_battery.c:436: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/power/s3c_adc_battery.c:436: warning: function declaration isn't a prototype
drivers/power/s3c_adc_battery.c:437: error: expected declaration specifiers or '...' before string constant
drivers/power/s3c_adc_battery.c:437: warning: data definition has no type or storage class
drivers/power/s3c_adc_battery.c:437: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/power/s3c_adc_battery.c:437: warning: function declaration isn't a prototype
make[2]: *** [drivers/power/s3c_adc_battery.o] Error 1
make[1]: *** [drivers/power] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/s3c_adc_battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index a675e31..20770ba 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -9,6 +9,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
-- 
1.7.4.1



