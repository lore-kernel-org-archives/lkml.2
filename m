Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1KFXy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:54:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46245 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754750Ab1KFXyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:54:19 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18lw05akVMlg1818u27BiCjCnkq9/s2ckBiVVo6om
	eEXCuKDKu9VXL6
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 9/9] staging/comedi/contec: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Mon,  7 Nov 2011 00:54:07 +0100
Message-Id: <1320623647-5108-9-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1320623647-5108-1-git-send-email-peterhuewe@gmx.de>
References: <1320623647-5108-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts pci_table entries to use the PCI_DEVICE macro,
if .subvendor and .subdevice are set to PCI_ANY_ID,
and thus improves readablity.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 871f109..db73638 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -57,10 +57,9 @@ static const struct contec_board contec_boards[] = {
 
 #define PCI_DEVICE_ID_PIO1616L 0x8172
 static DEFINE_PCI_DEVICE_TABLE(contec_pci_table) = {
-	{
-	PCI_VENDOR_ID_CONTEC, PCI_DEVICE_ID_PIO1616L, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, PIO1616L}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_CONTEC, PCI_DEVICE_ID_PIO1616L),
+		.driver_data = PIO1616L },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, contec_pci_table);
-- 
1.7.3.4

