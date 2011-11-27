Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1K0ONF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 09:13:05 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45567 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754859Ab1K0ONE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 09:13:04 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/kYst/8EnkMu3N5b9kCwgJ52D9i4qLX1FBYuHzW1
	BOXDZMRmBaSd3j
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Teddy Wang <teddy.wang@siliconmotion.com.cn>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/sm7xx: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Sun, 27 Nov 2011 15:12:57 +0100
Message-Id: <1322403177-10211-1-git-send-email-peterhuewe@gmx.de>
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
 drivers/staging/sm7xx/smtcfb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 39dbf33..ae0035f 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -1024,9 +1024,9 @@ failed_free:
 
 /* Jason (08/11/2009) PCI_DRV wrapper essential structs */
 static DEFINE_PCI_DEVICE_TABLE(smtcfb_pci_table) = {
-	{0x126f, 0x710, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x126f, 0x712, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x126f, 0x720, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_DEVICE(0x126f, 0x710), },
+	{ PCI_DEVICE(0x126f, 0x712), },
+	{ PCI_DEVICE(0x126f, 0x720), },
 	{0,}
 };
 
-- 
1.7.3.4

