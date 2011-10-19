Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1JSXDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:03:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37630 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab1JSXC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:02:58 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: staging: et131x: Tidy up PCI device table definition
Date: Thu, 20 Oct 2011 00:01:05 +0100
Message-Id: <1319065268-2863-15-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
References: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used the convenience macros DEFINE_PCI_DEVICE_TABLE and PCI_VDEVICE to
tidy up the device table definition.

Also remove the corresponding TODO item from the README.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README   |    1 -
 drivers/staging/et131x/et131x.c |   12 ++++--------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index 87b9360..0928eb5 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -10,7 +10,6 @@ driver as they did not build properly at the time.
 TODO:
 	- Use of kmem_cache seems a bit unusual
 	- It's too late stopping the tx queue when there is no room for the current packet. The condition should be detected for the next packet.
-	- PCI_VDEVICE ?
 
 Please send patches to:
 	Greg Kroah-Hartman <gregkh@suse.de>
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 28d54b3..cc41111 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -169,8 +169,7 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 #define ET1310_PCI_REPLAY		0xC2
 #define ET1310_PCI_L0L1LATENCY		0xCF
 
-/* PCI Vendor/Product IDs */
-#define ET131X_PCI_VENDOR_ID		0x11C1	/* Agere Systems */
+/* PCI Product IDs */
 #define ET131X_PCI_DEVICE_ID_GIG	0xED00	/* ET1310 1000 Base-T 8 */
 #define ET131X_PCI_DEVICE_ID_FAST	0xED01	/* ET1310 100  Base-T */
 
@@ -4647,14 +4646,11 @@ static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
 #define ET131X_PM_OPS NULL
 #endif
 
-static struct pci_device_id et131x_pci_table[] __devinitdata = {
-	{ET131X_PCI_VENDOR_ID, ET131X_PCI_DEVICE_ID_GIG, PCI_ANY_ID,
-	 PCI_ANY_ID, 0, 0, 0UL},
-	{ET131X_PCI_VENDOR_ID, ET131X_PCI_DEVICE_ID_FAST, PCI_ANY_ID,
-	 PCI_ANY_ID, 0, 0, 0UL},
+static DEFINE_PCI_DEVICE_TABLE(et131x_pci_table) = {
+	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_GIG), 0UL},
+	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_FAST), 0UL},
 	{0,}
 };
-
 MODULE_DEVICE_TABLE(pci, et131x_pci_table);
 
 static struct pci_driver et131x_driver = {
-- 
1.7.6.4

