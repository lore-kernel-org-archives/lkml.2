Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab0KSWXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:23:47 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39236 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab0KSV6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:52 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, aaro.koskinen@iki.fi
Subject: [PATCH 2/9] sisfb: delete fallback code for pci_map_rom()
Date: Fri, 19 Nov 2010 23:58:44 +0200
Message-Id: <1290203931-25188-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
References: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pci_map_rom() fails, there is some fallback code that basically
duplicates pci_map_rom() on non-x86 platforms. No point in that.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 1073b70..7feb699 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4147,23 +4147,6 @@ sisfb_find_rom(struct pci_dev *pdev)
 
         }
 
-#else
-
-	pci_read_config_dword(pdev, PCI_ROM_ADDRESS, &temp);
-	pci_write_config_dword(pdev, PCI_ROM_ADDRESS,
-			(ivideo->video_base & PCI_ROM_ADDRESS_MASK) | PCI_ROM_ADDRESS_ENABLE);
-
-	rom_base = ioremap(ivideo->video_base, 65536);
-	if(rom_base) {
-		if(sisfb_check_rom(rom_base, ivideo)) {
-			if((myrombase = vmalloc(65536)))
-				memcpy_fromio(myrombase, rom_base, 65536);
-		}
-		iounmap(rom_base);
-	}
-
-	pci_write_config_dword(pdev, PCI_ROM_ADDRESS, temp);
-
 #endif
 
 	return myrombase;
-- 
1.5.6.5

