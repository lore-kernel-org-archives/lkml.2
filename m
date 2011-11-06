Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1KFXz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:55:56 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45949 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754752Ab1KFXyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:54:16 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+sIR8Fch2sAY95l051Aqj7F5XdAcbiz0vE59Riso
	zhPyCLPFyQO3Zv
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 4/9] staging/comedi/amplc: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Mon,  7 Nov 2011 00:54:02 +0100
Message-Id: <1320623647-5108-4-git-send-email-peterhuewe@gmx.de>
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
 drivers/staging/comedi/drivers/amplc_dio200.c |    9 +++------
 drivers/staging/comedi/drivers/amplc_pc236.c  |    6 ++----
 drivers/staging/comedi/drivers/amplc_pc263.c  |    6 ++----
 drivers/staging/comedi/drivers/amplc_pci224.c |    9 +++------
 drivers/staging/comedi/drivers/amplc_pci230.c |    9 +++------
 5 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index 93bbe4e..566cc44 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -421,12 +421,9 @@ static const struct dio200_layout_struct dio200_layouts[] = {
 
 #ifdef CONFIG_COMEDI_PCI
 static DEFINE_PCI_DEVICE_TABLE(dio200_pci_table) = {
-	{
-	PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI215,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI272,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI215) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI272) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, dio200_pci_table);
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 48246cd..7972cad 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -134,10 +134,8 @@ static const struct pc236_board pc236_boards[] = {
 
 #ifdef CONFIG_COMEDI_PCI
 static DEFINE_PCI_DEVICE_TABLE(pc236_pci_table) = {
-	{
-	PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI236,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI236) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, pc236_pci_table);
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index 8a33880..191ac0d 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -101,10 +101,8 @@ static const struct pc263_board pc263_boards[] = {
 
 #ifdef CONFIG_COMEDI_PCI
 static DEFINE_PCI_DEVICE_TABLE(pc263_pci_table) = {
-	{
-	PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI263,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI263) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, pc263_pci_table);
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 1b5ba1c..b278917 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -384,12 +384,9 @@ static const struct pci224_board pci224_boards[] = {
  */
 
 static DEFINE_PCI_DEVICE_TABLE(pci224_pci_table) = {
-	{
-	PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI224,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI234,
-		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI224) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI234) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, pci224_pci_table);
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 7edeb11..5389795 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -501,12 +501,9 @@ static const struct pci230_board pci230_boards[] = {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(pci230_pci_table) = {
-	{
-	PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI230, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI260, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI230) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI260) },
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, pci230_pci_table);
-- 
1.7.3.4

