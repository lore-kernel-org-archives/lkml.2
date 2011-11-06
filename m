Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1KFXz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:55:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46003 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754753Ab1KFXyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:54:17 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+sIR8Fch2sAY95l051Aqj7F5XdAcbiz0vE59Riso
	zhPyCLPFyQO3Zv
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 5/9] staging/comedi/cb_pcimdda: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Mon,  7 Nov 2011 00:54:03 +0100
Message-Id: <1320623647-5108-5-git-send-email-peterhuewe@gmx.de>
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
 drivers/staging/comedi/drivers/cb_pcimdda.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 8c981a8..6521d61 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -144,10 +144,8 @@ static const struct board_struct boards[] = {
 /* Please add your PCI vendor ID to comedidev.h, and it will be forwarded
  * upstream. */
 static DEFINE_PCI_DEVICE_TABLE(pci_table) = {
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, PCI_ID_PCIM_DDA06_16, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, PCI_ID_PCIM_DDA06_16) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, pci_table);
-- 
1.7.3.4

