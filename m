Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab0KSWYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:24:00 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:59196 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab0KSV6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:52 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, aaro.koskinen@iki.fi
Subject: [PATCH 1/9] sisfb: delete obsolete PCI ROM bug workaround
Date: Fri, 19 Nov 2010 23:58:43 +0200
Message-Id: <1290203931-25188-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
References: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete a workaround for a PCI ROM bug that has been fixed ages ago by
the commit 761a3ac08c63718dacde12aaf0ec6d6760e8c2b7.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis_main.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 3dde12b..1073b70 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4114,14 +4114,6 @@ sisfb_find_rom(struct pci_dev *pdev)
 			if(sisfb_check_rom(rom_base, ivideo)) {
 
 				if((myrombase = vmalloc(65536))) {
-
-					/* Work around bug in pci/rom.c: Folks forgot to check
-					 * whether the size retrieved from the BIOS image eventually
-					 * is larger than the mapped size
-					 */
-					if(pci_resource_len(pdev, PCI_ROM_RESOURCE) < romsize)
-						romsize = pci_resource_len(pdev, PCI_ROM_RESOURCE);
-
 					memcpy_fromio(myrombase, rom_base,
 							(romsize > 65536) ? 65536 : romsize);
 				}
-- 
1.5.6.5

