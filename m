Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1KFXzC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:55:02 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46083 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754806Ab1KFXyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:54:17 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18prokhJ9opgkPseMLtFdRw+swGII5qaQ/A/j2m65
	Sy33+jwiQNM1lv
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 6/9] staging/comedi/das08: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Mon,  7 Nov 2011 00:54:04 +0100
Message-Id: <1320623647-5108-6-git-send-email-peterhuewe@gmx.de>
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

Since the driver_data field isn't used anywhere we can also drop the
assignments for class, class_mask and driver_data.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/das08.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 3141dc8..c2dd0ed 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -506,10 +506,8 @@ struct das08_board_struct das08_cs_boards[NUM_DAS08_CS_BOARDS] = {
 
 #ifdef CONFIG_COMEDI_PCI
 static DEFINE_PCI_DEVICE_TABLE(das08_pci_table) = {
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, PCI_DEVICE_ID_PCIDAS08,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, PCI_DEVICE_ID_PCIDAS08) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, das08_pci_table);
-- 
1.7.3.4

