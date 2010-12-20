Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab0LTVwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:52:33 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:52266 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab0LTVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:03 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 01/13] sisfb: eliminate unused variable compiler warning
Date: Mon, 20 Dec 2010 23:50:10 +0200
Message-Id: <1292881822-32630-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the following compiler warning on non-x86 platforms by limiting
the variable scope:

drivers/video/sis/sis_main.c:4108: warning: unused variable 'temp'

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 7e3370f..436ae46 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4105,7 +4105,6 @@ sisfb_find_rom(struct pci_dev *pdev)
 	struct sis_video_info *ivideo = pci_get_drvdata(pdev);
 	void __iomem *rom_base;
 	unsigned char *myrombase = NULL;
-	u32 temp;
 	size_t romsize;
 
 	/* First, try the official pci ROM functions (except
@@ -4132,26 +4131,29 @@ sisfb_find_rom(struct pci_dev *pdev)
 	/* Otherwise do it the conventional way. */
 
 #if defined(__i386__) || defined(__x86_64__)
+	{
+		u32 temp;
 
-	for(temp = 0x000c0000; temp < 0x000f0000; temp += 0x00001000) {
+		for (temp = 0x000c0000; temp < 0x000f0000; temp += 0x00001000) {
 
-		rom_base = ioremap(temp, 65536);
-		if(!rom_base)
-			continue;
+			rom_base = ioremap(temp, 65536);
+			if (!rom_base)
+				continue;
 
-		if(!sisfb_check_rom(rom_base, ivideo)) {
-			iounmap(rom_base);
-			continue;
-		}
+			if (!sisfb_check_rom(rom_base, ivideo)) {
+				iounmap(rom_base);
+				continue;
+			}
 
-		if((myrombase = vmalloc(65536)))
-			memcpy_fromio(myrombase, rom_base, 65536);
+			if ((myrombase = vmalloc(65536)))
+				memcpy_fromio(myrombase, rom_base, 65536);
 
-		iounmap(rom_base);
-		break;
+			iounmap(rom_base);
+			break;
 
-        }
+		}
 
+	}
 #endif
 
 	return myrombase;
-- 
1.5.6.5

