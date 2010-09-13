Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0IMTuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:50:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1912 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0IMTsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:41 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH 20/25] drivers/usb: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:58 -0700
Message-Id: <d366844155ca5af8525058f3376737ad7f94943e.1284406639.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/atm/ueagle-atm.c   |   14 +++++---------
 drivers/usb/otg/langwell_otg.c |    2 +-
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index ea071a5..00d2516 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1574,20 +1574,16 @@ static int uea_stat_e4(struct uea_softc *sc)
 
 static void cmvs_file_name(struct uea_softc *sc, char *const cmv_name, int ver)
 {
-	char file_arr[] = "CMVxy.bin";
+	char file_arr[sizeof("CMVxy.bin")];
 	char *file;
 
 	kparam_block_sysfs_write(cmv_file);
 	/* set proper name corresponding modem version and line type */
 	if (cmv_file[sc->modem_index] == NULL) {
-		if (UEA_CHIP_VERSION(sc) == ADI930)
-			file_arr[3] = '9';
-		else if (UEA_CHIP_VERSION(sc) == EAGLE_IV)
-			file_arr[3] = '4';
-		else
-			file_arr[3] = 'e';
-
-		file_arr[4] = IS_ISDN(sc) ? 'i' : 'p';
+		sprintf(file_arr, "CMV%c%c.bin",
+			(UEA_CHIP_VERSION(sc) == ADI930) ? '9' :
+			(UEA_CHIP_VERSION(sc) == EAGLE_IV) ? '4' : 'e',
+			IS_ISDN(sc) ? 'i' : 'p');
 		file = file_arr;
 	} else
 		file = cmv_file[sc->modem_index];
diff --git a/drivers/usb/otg/langwell_otg.c b/drivers/usb/otg/langwell_otg.c
index 8791880..ce01172 100644
--- a/drivers/usb/otg/langwell_otg.c
+++ b/drivers/usb/otg/langwell_otg.c
@@ -2035,7 +2035,7 @@ static int langwell_otg_probe(struct pci_dev *pdev,
 	int			retval;
 	u32			val32;
 	struct langwell_otg	*lnw;
-	char			qname[] = "langwell_otg_queue";
+	static const char	qname[] = "langwell_otg_queue";
 
 	retval = 0;
 	dev_dbg(&pdev->dev, "\notg controller is detected.\n");
-- 
1.7.3.rc1

