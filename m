Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1F3LNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:13:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1F3LN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:13:29 -0400
From: Christian Glindkamp <christian.glindkamp@taskit.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] w1: add support for DS28EA00 to w1_therm
Date: Thu, 30 Jun 2011 13:13:27 +0200
Message-Id: <1309432407-17840-1-git-send-email-christian.glindkamp@taskit.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:9fxi1e8BeB6PC2mn6GABkzCz8AdFu3oW/a/Pa9K0XVV
 qHQXNPFSfX4Si9agv03Hbn9Ff32YybGZd9piRyTR3Qp9PS8Pp0
 XBzhthYPZWbfEiO4aMZaSQit1r7tNXJteJZGGQTMhyjrGeTR/k
 jQBLTTKtDYV+ns0ua0WRZII+peTAIDbU0tcLYi5WwejF0vojic
 FEt2mxMGVcApybl3ApYTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christian Glindkamp <christian.glindkamp@taskit.de>
---
 drivers/w1/slaves/w1_therm.c |    9 +++++++++
 drivers/w1/w1_family.h       |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 17726a0..402928b 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -86,6 +86,11 @@ static struct w1_family w1_therm_family_DS1822 = {
 	.fops = &w1_therm_fops,
 };
 
+static struct w1_family w1_therm_family_DS28EA00 = {
+	.fid = W1_THERM_DS28EA00,
+	.fops = &w1_therm_fops,
+};
+
 struct w1_therm_family_converter
 {
 	u8			broken;
@@ -111,6 +116,10 @@ static struct w1_therm_family_converter w1_therm_families[] = {
 		.f		= &w1_therm_family_DS18B20,
 		.convert 	= w1_DS18B20_convert_temp
 	},
+	{
+		.f		= &w1_therm_family_DS28EA00,
+		.convert	= w1_DS18B20_convert_temp
+	},
 };
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 97479ae..89a0b1f 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -38,6 +38,7 @@
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
 #define W1_FAMILY_DS2780	0x32
+#define W1_THERM_DS28EA00	0x42
 
 #define MAXNAMELEN		32
 
-- 
1.7.2.3

