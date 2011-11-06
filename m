Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1KFXyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:54:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45903 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754751Ab1KFXyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:54:15 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18umbRovWAugfGYQjYk7OFER/F6nu9roNyE1SBexs
	7nONYnAZqJFKCE
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/9] staging/comedi/adl: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Mon,  7 Nov 2011 00:54:01 +0100
Message-Id: <1320623647-5108-3-git-send-email-peterhuewe@gmx.de>
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
 drivers/staging/comedi/drivers/adl_pci7230.c |   10 +---------
 drivers/staging/comedi/drivers/adl_pci7296.c |    6 ++----
 drivers/staging/comedi/drivers/adl_pci7432.c |    6 ++----
 drivers/staging/comedi/drivers/adl_pci8164.c |    6 ++----
 drivers/staging/comedi/drivers/adl_pci9111.c |    6 ++----
 5 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index 72a7258..20d5705 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -44,15 +44,7 @@ Configuration Options:
 #define PCI_DEVICE_ID_PCI7230 0x7230
 
 static DEFINE_PCI_DEVICE_TABLE(adl_pci7230_pci_table) = {
-	{
-		PCI_VENDOR_ID_ADLINK,
-		PCI_DEVICE_ID_PCI7230,
-		PCI_ANY_ID,
-		PCI_ANY_ID,
-		0,
-		0,
-		0
-	},
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7230) },
 	{0}
 };
 
diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index f28fe6b..9a232053 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -49,10 +49,8 @@ Configuration Options:
 #define PCI_DEVICE_ID_PCI7296 0x7296
 
 static DEFINE_PCI_DEVICE_TABLE(adl_pci7296_pci_table) = {
-	{
-	PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7296, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7296) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, adl_pci7296_pci_table);
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index 262da7b..86ee219 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -44,10 +44,8 @@ Configuration Options:
 #define PCI_DEVICE_ID_PCI7432 0x7432
 
 static DEFINE_PCI_DEVICE_TABLE(adl_pci7432_pci_table) = {
-	{
-	PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7432, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7432) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, adl_pci7432_pci_table);
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 767a594..3b83d65 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -57,10 +57,8 @@ Configuration Options:
 #define PCI_DEVICE_ID_PCI8164 0x8164
 
 static DEFINE_PCI_DEVICE_TABLE(adl_pci8164_pci_table) = {
-	{
-	PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI8164, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI8164) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, adl_pci8164_pci_table);
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index fc48bae..2a9bd88 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -311,10 +311,8 @@ static const struct comedi_lrange pci9111_hr_ai_range = {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
-	{ PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  0, 0, 0 },
-	/* { PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
-	 *   0, 0, 0 }, */
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID) },
+	/* { PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID) }, */
 	{ 0 }
 };
 
-- 
1.7.3.4

