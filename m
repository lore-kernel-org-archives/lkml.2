Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2B0HFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:05:39 -0500
Received: from nm20.bullet.mail.ukl.yahoo.com ([217.146.183.194]:29708 "HELO
	nm20.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753151Ab2B0HFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:05:36 -0500
X-Yahoo-Newman-Id: 83869.69195.bm@smtp156.mail.ukl.yahoo.com
Message-ID: <83869.69195.bm@smtp156.mail.ukl.yahoo.com>
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jO0a8L8VM1kNX2tADbyI3onEILoN176_BkhBGWQffcp9NVN
 98cXet9OI4Lx4slPnKVlU_7RH3Pf6OKuT_CQIfPm2L9C0V7DgUlK8SPffNvx
 wQHI1Yjs_CRN7osfJmw9N4mwKrx2gVOB3ttsJFR_RoYX9VI7HX7VaMFnKQqa
 7S0dQ.PvBGL7JeybgGfE5K_dUdkC5HErYo72lc9_Iwap.Fw1ztb4Rj9aW1Hf
 a2_3HSeMa4cUz2h34WwTJmhooD0oFtUBbX7Pu_rKRbCRCUpGJPOx5yTHwi9x
 d_sBiFwTC5nhlsc6b7fx2NlZfosne2sCLeaFBunWQbk.qMGlG7HvwRQEWhT_
 9o5c1mYCXAV6hDMeB2b0I2_k7TH48Y4NbvngK1TaEFqiPcNTSInxH0QHgqAg
 sAA6TJig-
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
Date: Mon, 27 Feb 2012 08:05:30 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH linux-next] edac: move const pci_device_id tables from __devinitdata to __devinitconst.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on PaX and earlier work by Andi Kleen.

Patch against linux-next (20120224).

---

>From e4ed493cf2241f6ba880459e48674de0b2a394a3 Mon Sep 17 00:00:00 2001
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Date: Mon, 27 Feb 2012 07:41:47 +0100
Subject: edac: move const pci_device_id tables from __devinitdata to
 __devinitconst.

These const tables are currently marked __devinitdata, but Documentation/PCI/pci.txt says:
"
o The ID table array should be marked __devinitconst; this is done
  automatically if the table is declared with DEFINE_PCI_DEVICE_TABLE().
"
So use DEFINE_PCI_DEVICE_TABLE(x).

Based on PaX and earlier work by Andi Kleen.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 drivers/edac/amd64_edac.c      |    2 +-
 drivers/edac/amd76x_edac.c     |    2 +-
 drivers/edac/e752x_edac.c      |    2 +-
 drivers/edac/e7xxx_edac.c      |    2 +-
 drivers/edac/i3000_edac.c      |    2 +-
 drivers/edac/i3200_edac.c      |    2 +-
 drivers/edac/i5000_edac.c      |    2 +-
 drivers/edac/i5100_edac.c      |    2 +-
 drivers/edac/i5400_edac.c      |    2 +-
 drivers/edac/i7300_edac.c      |    2 +-
 drivers/edac/i7core_edac.c     |    2 +-
 drivers/edac/i82443bxgx_edac.c |    2 +-
 drivers/edac/i82860_edac.c     |    2 +-
 drivers/edac/i82875p_edac.c    |    2 +-
 drivers/edac/i82975x_edac.c    |    2 +-
 drivers/edac/r82600_edac.c     |    2 +-
 drivers/edac/sb_edac.c         |    2 +-
 drivers/edac/x38_edac.c        |    2 +-
 18 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 0380728..7ef73c9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2707,7 +2707,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
  * PCI core identifies what devices are on a system during boot, and then
  * inquiry this table to see if this driver is for a given device found.
  */
-static const struct pci_device_id amd64_pci_table[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(amd64_pci_table) = {
 	{
 		.vendor		= PCI_VENDOR_ID_AMD,
 		.device		= PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index e47e73b..f8fd3c8 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -321,7 +321,7 @@ static void __devexit amd76x_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id amd76x_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(amd76x_pci_tbl) = {
 	{
 	 PCI_VEND_DEV(AMD, FE_GATE_700C), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 AMD762},
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 1af531a..4122326 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1380,7 +1380,7 @@ static void __devexit e752x_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id e752x_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(e752x_pci_tbl) = {
 	{
 	 PCI_VEND_DEV(INTEL, 7520_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 E7520},
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 6ffb6d2..68dea87 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -525,7 +525,7 @@ static void __devexit e7xxx_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id e7xxx_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(e7xxx_pci_tbl) = {
 	{
 	 PCI_VEND_DEV(INTEL, 7205_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 E7205},
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index c0510b3..277689a 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -470,7 +470,7 @@ static void __devexit i3000_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i3000_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i3000_pci_tbl) = {
 	{
 	 PCI_VEND_DEV(INTEL, 3000_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 I3000},
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 73f55e200..046808c 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -445,7 +445,7 @@ static void __devexit i3200_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i3200_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i3200_pci_tbl) = {
 	{
 		PCI_VEND_DEV(INTEL, 3200_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		I3200},
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 4dc3ac2..a2680d8 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1516,7 +1516,7 @@ static void __devexit i5000_remove_one(struct pci_dev *pdev)
  *
  *	The "E500P" device is the first device supported.
  */
-static const struct pci_device_id i5000_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i5000_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_I5000_DEV16),
 	 .driver_data = I5000P},
 
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index bcbdeec..2e23547 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -1051,7 +1051,7 @@ static void __devexit i5100_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i5100_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i5100_pci_tbl) = {
 	/* Device 16, Function 0, Channel 0 Memory Map, Error Flag/Mask, ... */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5100_16) },
 	{ 0, }
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 74d6ec34..67ec962 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1383,7 +1383,7 @@ static void __devexit i5400_remove_one(struct pci_dev *pdev)
  *
  *	The "E500P" device is the first device supported.
  */
-static const struct pci_device_id i5400_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i5400_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR)},
 	{0,}			/* 0 terminated list. */
 };
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 6104dba..3bafa3b 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1192,7 +1192,7 @@ static void __devexit i7300_remove_one(struct pci_dev *pdev)
  *
  * Has only 8086:360c PCI ID
  */
-static const struct pci_device_id i7300_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i7300_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_I7300_MCH_ERR)},
 	{0,}			/* 0 terminated list. */
 };
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 8568d9b..85226cc 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -391,7 +391,7 @@ static const struct pci_id_table pci_dev_table[] = {
 /*
  *	pci_device_id	table for which devices we are looking for
  */
-static const struct pci_device_id i7core_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i7core_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_X58_HUB_MGMT)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNNFIELD_QPI_LINK0)},
 	{0,}			/* 0 terminated list. */
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 4329d39..3bf2b2f 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -380,7 +380,7 @@ static void __devexit i82443bxgx_edacmc_remove_one(struct pci_dev *pdev)
 
 EXPORT_SYMBOL_GPL(i82443bxgx_edacmc_remove_one);
 
-static const struct pci_device_id i82443bxgx_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i82443bxgx_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443BX_0)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443BX_2)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443GX_0)},
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 931a057..c779092 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -270,7 +270,7 @@ static void __devexit i82860_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i82860_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i82860_pci_tbl) = {
 	{
 	 PCI_VEND_DEV(INTEL, 82860_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 I82860},
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 33864c6..10f15d8 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -511,7 +511,7 @@ static void __devexit i82875p_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i82875p_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i82875p_pci_tbl) = {
 	{
 	 PCI_VEND_DEV(INTEL, 82875_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 I82875P},
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 4184e01..0cd8368 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -612,7 +612,7 @@ static void __devexit i82975x_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i82975x_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(i82975x_pci_tbl) = {
 	{
 		PCI_VEND_DEV(INTEL, 82975_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		I82975X
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index e294e1b..6d908ad 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -373,7 +373,7 @@ static void __devexit r82600_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id r82600_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(r82600_pci_tbl) = {
 	{
 	 PCI_DEVICE(PCI_VENDOR_ID_RADISYS, R82600_BRIDGE_ID)
 	 },
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 1dc118d..3a605f7 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -367,7 +367,7 @@ static const struct pci_id_table pci_dev_descr_sbridge_table[] = {
 /*
  *	pci_device_id	table for which devices we are looking for
  */
-static const struct pci_device_id sbridge_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(sbridge_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA)},
 	{0,}			/* 0 terminated list. */
 };
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index b6f47de..a438297 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -440,7 +440,7 @@ static void __devexit x38_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id x38_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(x38_pci_tbl) = {
 	{
 	 PCI_VEND_DEV(INTEL, X38_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 X38},
-- 
1.7.9.2.262.gba998

