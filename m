Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2HCTyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:54:10 -0400
Received: from roc.holo.8d.com ([64.254.227.115]:57450 "EHLO roc.holo.8d.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2HCTyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:54:06 -0400
X-Greylist: delayed 1653 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2012 15:54:06 EDT
Date: Fri, 3 Aug 2012 15:26:04 -0400
From: Raphael Assenat <raph@8d.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] 1-Wire: Add support for the maxim ds1825 temperature sensor
Message-ID: <20120803192604.GA21388@renkinjitsu.usine.8d.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6
X-Spam-Report: -2.6 points, 5.0 required autolearn=ham
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for maxim ds1825 based 1-wire temperature sensors.

diff --git a/Documentation/w1/slaves/w1_therm b/Documentation/w1/slaves/w1_therm
index 0403aaa..874a8ca 100644
--- a/Documentation/w1/slaves/w1_therm
+++ b/Documentation/w1/slaves/w1_therm
@@ -3,6 +3,7 @@ Kernel driver w1_therm
 
 Supported chips:
   * Maxim ds18*20 based temperature sensors.
+  * Maxim ds1825 based temperature sensors.
 
 Author: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
 
@@ -15,6 +16,7 @@ supported family codes:
 W1_THERM_DS18S20	0x10
 W1_THERM_DS1822		0x22
 W1_THERM_DS18B20	0x28
+W1_THERM_DS1825		0x3B
 
 Support is provided through the sysfs w1_slave file.  Each open and
 read sequence will initiate a temperature conversion then provide two
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index ff29ae7..b34bf1d 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -91,6 +91,11 @@ static struct w1_family w1_therm_family_DS28EA00 = {
 	.fops = &w1_therm_fops,
 };
 
+static struct w1_family w1_therm_family_DS1825 = {
+	.fid = W1_THERM_DS1825,
+	.fops = &w1_therm_fops,
+};
+
 struct w1_therm_family_converter
 {
 	u8			broken;
@@ -120,6 +125,10 @@ static struct w1_therm_family_converter w1_therm_families[] = {
 		.f		= &w1_therm_family_DS28EA00,
 		.convert	= w1_DS18B20_convert_temp
 	},
+	{
+		.f		= &w1_therm_family_DS1825,
+		.convert	= w1_DS18B20_convert_temp
+	}
 };
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 874aeb0..b998c30 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -38,6 +38,7 @@
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
 #define W1_FAMILY_DS2780	0x32
+#define W1_THERM_DS1825		0x3B
 #define W1_FAMILY_DS2781	0x3D
 #define W1_THERM_DS28EA00	0x42
 
