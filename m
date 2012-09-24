Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970Ab2IXEKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 00:10:20 -0400
Received: from mailgw.tw.promise.com ([61.222.81.250]:56876 "HELO
	mailgw.promise.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750792Ab2IXEKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 00:10:19 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2012 00:10:17 EDT
X-MailGates: (compute_score:DELIVER,40,3)
From: =?big5?B?VG9ueSBIdW5nIC0gUFRUIKx4t+fArw==?= 
	<tony.hung@tw.promise.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Sep 2012 10:34:11 +0800
Subject: [PATCH] ahci: add a boot option to enable promise ahci
Thread-Topic: [PATCH] ahci: add a boot option to enable promise ahci
Thread-Index: Ac2Z+6uoqat+lNFXR+uoPJV5DD+a/Q==
Message-ID: <1AF0FA078A5A3541A8A8019D26081C2E88DCE6D976@ptt-ex02.promise.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
x-tm-as-product-ver: SMEX-10.2.0.1135-7.000.1014-19206.000
x-tm-as-result: No--40.984000-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="big5"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8O4BL76018455

linux-3.2.0/drivers/ata/ahci.c: In function 'hptiop_host_request_callback':

Use min_t(size_t, ...) to fix.

Signed-off-by: Tony Hung <tony.hung@tw.promise.com>
---

diff --git a/linux-3.2.0/drivers/ata/ahci.c b/linux-3.2.0/drivers/ata/ahci.c
--- a/linux-3.2.0/drivers/ata/ahci.c	2012-08-29 13:40:26.046851693 +0800
+++ b/linux-3.2.0/drivers/ata/ahci.c	2012-08-30 17:23:10.207838960 +0800
@@ -430,6 +430,9 @@ static int marvell_enable = 1;
 module_param(marvell_enable, int, 0644);
 MODULE_PARM_DESC(marvell_enable, "Marvell SATA via AHCI (1 = enabled)");

+static int promise_enable;
+module_param(promise_enable, int, 0644);
+MODULE_PARM_DESC(promise_enable, "Promise SATA via AHCI (1 = enabled)");

 static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 					 struct ahci_host_priv *hpriv)
@@ -1049,6 +1052,16 @@ static int ahci_init_one(struct pci_dev
 	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
 		return -ENODEV;

+        /*
+         * In RAID mode, Promise software RAID need to replace
+         * original AHCI module, but if AHCI driver build-in kernel,
+         * Promise AHCI module need a boot option to disable it
+         */
+        if (promise_enable &&
+            ((pdev->class >> 8) == PCI_CLASS_STORAGE_RAID) &&
+             (pdev->vendor == PCI_VENDOR_ID_ATI ||
+              pdev->vendor == PCI_VENDOR_ID_AMD))
+                return -ENODEV;
+
 	/*
 	 * For some reason, MCP89 on MacBook 7,1 doesn't work with
 	 * ahci, use ata_generic instead. 

To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
