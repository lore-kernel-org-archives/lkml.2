Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1KFWMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:12:33 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34950 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752805Ab1KFWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:12:32 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18iU9BiBeUiy4nsPkm61JnVPGLC6pNamJIO/X8YaF
	xEaH0p4nwzpc50
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH v2] staging/xgifb: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Sun,  6 Nov 2011 23:12:28 +0100
Message-Id: <1320617548-9506-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1320613517-3086-1-git-send-email-peterhuewe@gmx.de>
References: <1320613517-3086-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts pci_table entries to use the PCI_DEVICE macro,
if .subvendor and .subdevice are set to PCI_ANY_ID,
and thus improves readability.

v2:
Since the driver_data field isn't used anywhere we can also drop the
assignments for class, class_mask and driver_data.
(found by Aaro Koskinen)

KernelVersion: Staging-20111106

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main.h |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 71aebe3..cf4c188 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -32,14 +32,10 @@
 #endif
 
 static DEFINE_PCI_DEVICE_TABLE(xgifb_pci_table) = {
-	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20, PCI_ANY_ID, PCI_ANY_ID,
-	 0, 0, 0},
-	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_27, PCI_ANY_ID, PCI_ANY_ID,
-	 0, 0, 1},
-	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_40, PCI_ANY_ID, PCI_ANY_ID,
-	 0, 0, 2},
-	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_42, PCI_ANY_ID, PCI_ANY_ID,
-	 0, 0, 3},
+	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20)},
+	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_27)},
+	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_40)},
+	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_42)},
 	{0}
 };
 
-- 
1.7.3.4

