Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0HBEnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 00:43:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44658 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0HBEnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 00:43:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=dJMqCN4XzzYBd9/nIgLv6LBdWdNYheXD9+R1QT7RngsiqJr/6GOrJYM4/Ho/YWHFtz
         v4zR7YXlnv8IAnkYh58Fezg4A95/JibxxSLh60Dlv/a1J5qeAfjHsISftMf3fff8kNMH
         zOBWBv1TfZeMGsccllUAomCV4S6aTn7CJSliI=
Subject: [PATCH] staging/wlags49_h2: use common PCI_VENDOR/DEVICE_ID name
 format
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Kulikov Vasiliy <segooon@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Henk de Groot <pe1dnn@amsat.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kernelnewbies@nl.linux.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 00:43:13 -0400
Message-ID: <1280724193.6102.6.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a common name format for PCI_VENDOR/DEVICE_ID constants.
wlags49_h2 names doesn't fit in the standard. 
This patch change the names and also fix some style issues.

Thanks a lot,

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/wlags49_h2/wl_pci.c |   10 +++++++---
 drivers/staging/wlags49_h2/wl_pci.h |    8 ++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_pci.c b/drivers/staging/wlags49_h2/wl_pci.c
index af4f4f8..020b17a 100644
--- a/drivers/staging/wlags49_h2/wl_pci.c
+++ b/drivers/staging/wlags49_h2/wl_pci.c
@@ -117,9 +117,13 @@ enum hermes_pci_versions {
 };
 
 static struct pci_device_id wl_pci_tbl[] __devinitdata = {
-	{ WL_LKM_PCI_VENDOR_ID, WL_LKM_PCI_DEVICE_ID_0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Agere_Systems_Mini_PCI_V1 },
-    { WL_LKM_PCI_VENDOR_ID, WL_LKM_PCI_DEVICE_ID_1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Agere_Systems_Mini_PCI_V1 },
-    { WL_LKM_PCI_VENDOR_ID, WL_LKM_PCI_DEVICE_ID_2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Agere_Systems_Mini_PCI_V1 },
+	{ PCI_VENDOR_ID_WL_LKM, PCI_DEVICE_ID_WL_LKM_0,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Agere_Systems_Mini_PCI_V1 },
+	{ PCI_VENDOR_ID_WL_LKM, PCI_DEVICE_ID_WL_LKM_1,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Agere_Systems_Mini_PCI_V1 },
+	{ PCI_VENDOR_ID_WL_LKM, PCI_DEVICE_ID_WL_LKM_2,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Agere_Systems_Mini_PCI_V1 },
+
 	{ }			/* Terminating entry */
 };
 
diff --git a/drivers/staging/wlags49_h2/wl_pci.h b/drivers/staging/wlags49_h2/wl_pci.h
index 18d7b51..cea04c4 100644
--- a/drivers/staging/wlags49_h2/wl_pci.h
+++ b/drivers/staging/wlags49_h2/wl_pci.h
@@ -67,10 +67,10 @@
 /*******************************************************************************
  *  constant definitions
  ******************************************************************************/
-#define WL_LKM_PCI_VENDOR_ID    0x11C1  // Lucent Microelectronics
-#define WL_LKM_PCI_DEVICE_ID_0  0xAB30  // Mini PCI
-#define WL_LKM_PCI_DEVICE_ID_1  0xAB34  // Mini PCI
-#define WL_LKM_PCI_DEVICE_ID_2  0xAB11  // WARP CardBus
+#define PCI_VENDOR_IDWL_LKM     0x11C1  /* Lucent Microelectronics */
+#define PCI_DEVICE_ID_WL_LKM_0  0xAB30  /* Mini PCI */
+#define PCI_DEVICE_ID_WL_LKM_1  0xAB34  /* Mini PCI */
+#define PCI_DEVICE_ID_WL_LKM_2  0xAB11  /* WARP CardBus */
 
 
 
-- 
1.7.0.4



