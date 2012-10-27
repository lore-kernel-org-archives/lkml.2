Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2J0OPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 10:15:19 -0400
Received: from m13-84.163.com ([220.181.13.84]:57856 "EHLO m13-84.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab2J0OPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 10:15:17 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2012 10:15:15 EDT
X-Originating-IP: [219.217.246.72]
Date: Sat, 27 Oct 2012 21:58:07 +0800 (CST)
From: whs_jwc <whs_jwc@163.com>
To: whs_jwc@163.com
Subject: [PATCH] Some Samsung laptops with Fn+Fx key release not working
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20120914(19817.4926.4909) Copyright (c) 2002-2012 www.mailtech.cn 163com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <69021e29.7876.13aa283f3de.Coremail.whs_jwc@163.com>
X-CM-TRANSID: VMGowEBJs0Lj6ItQA7cuAA--.7562W
X-CM-SenderInfo: pzkvsylzf6il2tof0z/
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Some Samsung laptops with Fn+Fx key release not working

    Some new Samsung laptops doesn't send key-release signal of the 
    volume key to the OS, it's quite hard to change the volume by 
    using Fn+Fx, so I decode the DMI and add several samsung machines
    to the forced_release_keys table in order to fixed this problem.
    
    DMI (only a part):
    # dmidecode
... 
Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: SAMSUNG ELECTRONICS CO., LTD.
        Product Name: 355V4C/355V4X/355V5C/355V5X/356V4C/356V4X/356V5C/356V5X/3445VC/3445VX/3545VC/3545VX
        Version: P02AAN.014.CP
        Serial Number: HTD798FC7B1TQY
        UUID: 7661EB04-63B7-E111-9466-B888E35FDCEE
        Wake-up Type: Power Switch
        SKU Number: P02AAN.014.CP
        Family: Eureka
...
    P.S: I have tested this patch on all these machines and It
         works very well.
    
    Patched file(s):
    drivers/input/keyboard/atkbd.c


-----  input_keyboard_samsung_laptops.patch -----

commit f7540722cf2e98a01f64239c184882de000904ac
Author: WenCong Ji <whs_jwc@163.com>
Date:   Sat Oct 27 21:11:20 2012 +0800
    
    input/keyboard: Some Samsung laptops with Fn+Fx key release not working
    
    Some new Samsung laptops doesn't send key-release signal to the Operating
    System when we click on Fn+F[6-8], so we have to force it to release immedi-
    ately after receiving the key-press signal.
    
Signed-off-by: WenCong Ji <whs_jwc@163.com>
Signed-off-by: Cai Liu <lcc_xiaojsoft@163.com>

diff -up a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -915,10 +915,10 @@ static unsigned int atkbd_hp_forced_rele
 };
 
 /*
- * Samsung NC10,NC20 with Fn+F? key release not working
+ * Some Samsung laptops with Fn+F? key release not working
  */
 static unsigned int atkbd_samsung_forced_release_keys[] = {
-	0x82, 0x83, 0x84, 0x86, 0x88, 0x89, 0xb3, 0xf7, 0xf9, -1U
+	0x82, 0x83, 0x84, 0x86, 0x88, 0x89, 0xa0, 0xae, 0xb0, 0xb3, 0xf7, 0xf9, -1U
 };
 
 /*
@@ -1700,6 +1700,114 @@ static const struct dmi_system_id atkbd_
 		},
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 355V4C */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "355V4C"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 355V4X */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "355V4X"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 355V5C */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "355V5C"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 355V5X */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "355V5X"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 356V4C */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "356V4C"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 356V4X */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "356V4X"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 356V5C */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "356V5C"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 356V5X */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "356V5X"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 3445VC */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "3445VC"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 3445VX */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "3445VX"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 3545VC */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "3545VC"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
+		/* Samsung 3545VX */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "3545VX"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
 	},
 	{
 		/* Fujitsu Amilo PA 1510 */
