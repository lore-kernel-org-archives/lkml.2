Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1HLO4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 10:56:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62731 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1HLO4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 10:56:32 -0400
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH] s3c-adc-battery: fix compilation error due to missing header
Date: Fri, 12 Aug 2011 17:55:18 +0300
Message-Id: <1313160918-20697-1-git-send-email-anarsoul@gmail.com>
X-Mailer: git-send-email 1.7.5.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add linux/module.h to fix this compilation error:

drivers/power/s3c_adc_battery.c:435:15: error: expected declaration specifiers or ‘...’ before string constant
drivers/power/s3c_adc_battery.c:435:1: warning: data definition has no type or storage class
drivers/power/s3c_adc_battery.c:435:1: warning: type defaults to ‘int’ in declaration of ‘MODULE_AUTHOR’
drivers/power/s3c_adc_battery.c:435:15: warning: function declaration isn’t a prototype
drivers/power/s3c_adc_battery.c:436:20: error: expected declaration specifiers or ‘...’ before string constant
drivers/power/s3c_adc_battery.c:436:1: warning: data definition has no type or storage class
drivers/power/s3c_adc_battery.c:436:1: warning: type defaults to ‘int’ in declaration of ‘MODULE_DESCRIPTION’
drivers/power/s3c_adc_battery.c:436:20: warning: function declaration isn’t a prototype
drivers/power/s3c_adc_battery.c:437:16: error: expected declaration specifiers or ‘...’ before string constant
drivers/power/s3c_adc_battery.c:437:1: warning: data definition has no type or storage class
drivers/power/s3c_adc_battery.c:437:1: warning: type defaults to ‘int’ in declaration of ‘MODULE_LICENSE’
drivers/power/s3c_adc_battery.c:437:16: warning: function declaration isn’t a prototype
make[2]: *** [drivers/power/s3c_adc_battery.o] Error 1

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/power/s3c_adc_battery.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index a675e31..d32d0d7 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -20,6 +20,7 @@
 #include <linux/s3c_adc_battery.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/module.h>
 
 #include <plat/adc.h>
 
-- 
1.7.5.rc3

