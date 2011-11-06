Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1KFXyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:54:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46117 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754811Ab1KFXyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:54:18 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18prokhJ9opgkPseMLtFdRw+swGII5qaQ/A/j2m65
	Sy33+jwiQNM1lv
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 7/9] staging/comedi/ke_counter: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Mon,  7 Nov 2011 00:54:05 +0100
Message-Id: <1320623647-5108-7-git-send-email-peterhuewe@gmx.de>
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
 drivers/staging/comedi/drivers/ke_counter.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 286093b..4e9e9a0 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -52,10 +52,8 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it);
 static int cnt_detach(struct comedi_device *dev);
 
 static DEFINE_PCI_DEVICE_TABLE(cnt_pci_table) = {
-	{
-	PCI_VENDOR_ID_KOLTER, CNT_CARD_DEVICE_ID, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_KOLTER, CNT_CARD_DEVICE_ID) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, cnt_pci_table);
-- 
1.7.3.4

