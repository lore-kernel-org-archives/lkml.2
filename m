Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1KFXyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:54:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45859 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754750Ab1KFXyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:54:15 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+wDFpMCKSwAP2ILasu45km0gi9K8x97La7JmHI8F
	nbWEtMrlQApNwb
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/9] staging/comedi/daqboard: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Mon,  7 Nov 2011 00:54:00 +0100
Message-Id: <1320623647-5108-2-git-send-email-peterhuewe@gmx.de>
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
 drivers/staging/comedi/drivers/daqboard2000.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 82be77d..542c760 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -325,9 +325,8 @@ static const struct daq200_boardtype boardtypes[] = {
 #define this_board ((const struct daq200_boardtype *)dev->board_ptr)
 
 static DEFINE_PCI_DEVICE_TABLE(daqboard2000_pci_table) = {
-	{
-	0x1616, 0x0409, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(0x1616, 0x0409) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, daqboard2000_pci_table);
-- 
1.7.3.4

