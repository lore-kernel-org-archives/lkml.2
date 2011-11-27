Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1K0OLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 09:11:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50644 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754859Ab1K0OLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 09:11:46 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18SvX91f4cSje+PLB5U6g1myXdQfZSxuiNR9Mm/6w
	tmlAYTWVbHmwZN
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/phison: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Sun, 27 Nov 2011 15:11:40 +0100
Message-Id: <1322403100-10100-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts pci_table entries to use the PCI_DEVICE macro,
if .subvendor and .subdevice are set to PCI_ANY_ID,
and thus improves readablity.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/phison/phison.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index 683657c..d77b21f 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -70,7 +70,7 @@ static int phison_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(phison_pci_tbl) = {
-	{ PCI_VENDOR_ID_PHISON, PCI_DEVICE_ID_PS5000, PCI_ANY_ID, PCI_ANY_ID,
+	{ PCI_DEVICE(PCI_VENDOR_ID_PHISON, PCI_DEVICE_ID_PS5000),
 	  PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 0 },
 	{ 0, },
 };
-- 
1.7.3.4

