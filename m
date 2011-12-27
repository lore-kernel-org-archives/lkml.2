Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1L0DfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 22:35:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34002 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1L0DfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 22:35:09 -0500
Message-ID: <1324956897.9775.2.camel@phoenix>
Subject: [PATCH] i2c: Convert to DEFINE_PCI_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rudolf Marek <r.marek@assembler.cz>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Olof Johansson <olof@lixom.net>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Feng Tang <feng.tang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-i2c@vger.kernel.org
Date: Tue, 27 Dec 2011 11:34:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
tables.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-i2c@vger.kernel.org
---
This patch is against linux-next tree.
Axel

 drivers/i2c/busses/i2c-ali1563.c           |    2 +-
 drivers/i2c/busses/i2c-ali15x3.c           |    2 +-
 drivers/i2c/busses/i2c-amd756.c            |    2 +-
 drivers/i2c/busses/i2c-amd8111.c           |    2 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c |    2 +-
 drivers/i2c/busses/i2c-eg20t.c             |    2 +-
 drivers/i2c/busses/i2c-hydra.c             |    2 +-
 drivers/i2c/busses/i2c-i801.c              |    2 +-
 drivers/i2c/busses/i2c-intel-mid.c         |    2 +-
 drivers/i2c/busses/i2c-nforce2.c           |    2 +-
 drivers/i2c/busses/i2c-pasemi.c            |    2 +-
 drivers/i2c/busses/i2c-piix4.c             |    2 +-
 drivers/i2c/busses/i2c-pxa-pci.c           |    2 +-
 drivers/i2c/busses/i2c-sis5595.c           |    2 +-
 drivers/i2c/busses/i2c-sis630.c            |    2 +-
 drivers/i2c/busses/i2c-sis96x.c            |    2 +-
 drivers/i2c/busses/i2c-via.c               |    2 +-
 drivers/i2c/busses/i2c-viapro.c            |    2 +-
 drivers/i2c/busses/scx200_acb.c            |    2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ali1563.c b/drivers/i2c/busses/i2c-ali1563.c
index a409cfc..47ae009 100644
--- a/drivers/i2c/busses/i2c-ali1563.c
+++ b/drivers/i2c/busses/i2c-ali1563.c
@@ -417,7 +417,7 @@ static void __devexit ali1563_remove(struct pci_dev * dev)
 	ali1563_shutdown(dev);
 }
 
-static const struct pci_device_id ali1563_id_table[] __devinitconst = {
+static DEFINE_PCI_DEVICE_TABLE(ali1563_id_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1563) },
 	{},
 };
diff --git a/drivers/i2c/busses/i2c-ali15x3.c b/drivers/i2c/busses/i2c-ali15x3.c
index 83e8a60..087ea9caa 100644
--- a/drivers/i2c/busses/i2c-ali15x3.c
+++ b/drivers/i2c/busses/i2c-ali15x3.c
@@ -477,7 +477,7 @@ static struct i2c_adapter ali15x3_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
-static const struct pci_device_id ali15x3_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(ali15x3_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
index 03bcd07..eb778bf1 100644
--- a/drivers/i2c/busses/i2c-amd756.c
+++ b/drivers/i2c/busses/i2c-amd756.c
@@ -308,7 +308,7 @@ static const char* chipname[] = {
 	"nVidia nForce", "AMD8111",
 };
 
-static const struct pci_device_id amd756_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(amd756_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_VIPER_740B),
 	  .driver_data = AMD756 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_VIPER_7413),
diff --git a/drivers/i2c/busses/i2c-amd8111.c b/drivers/i2c/busses/i2c-amd8111.c
index 6b6a6b1..e5ac53b 100644
--- a/drivers/i2c/busses/i2c-amd8111.c
+++ b/drivers/i2c/busses/i2c-amd8111.c
@@ -415,7 +415,7 @@ static const struct i2c_algorithm smbus_algorithm = {
 };
 
 
-static const struct pci_device_id amd8111_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(amd8111_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8111_SMBUS2) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 9e89e73..37f4211 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -349,7 +349,7 @@ static void __devexit i2c_dw_pci_remove(struct pci_dev *pdev)
 /* work with hotplug and coldplug */
 MODULE_ALIAS("i2c_designware-pci");
 
-DEFINE_PCI_DEVICE_TABLE(i2_designware_pci_ids) = {
+static DEFINE_PCI_DEVICE_TABLE(i2_designware_pci_ids) = {
 	/* Moorestown */
 	{ PCI_VDEVICE(INTEL, 0x0802), moorestown_0 },
 	{ PCI_VDEVICE(INTEL, 0x0803), moorestown_1 },
diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 18936ac..3ef3557 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -185,7 +185,7 @@ static DEFINE_MUTEX(pch_mutex);
 #define PCI_DEVICE_ID_ML7213_I2C	0x802D
 #define PCI_DEVICE_ID_ML7223_I2C	0x8010
 
-static struct pci_device_id __devinitdata pch_pcidev_id[] = {
+static DEFINE_PCI_DEVICE_TABLE(pch_pcidev_id) = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_PCH_I2C),   1, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_I2C), 2, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_I2C), 1, },
diff --git a/drivers/i2c/busses/i2c-hydra.c b/drivers/i2c/busses/i2c-hydra.c
index 9ff1695..c527de1 100644
--- a/drivers/i2c/busses/i2c-hydra.c
+++ b/drivers/i2c/busses/i2c-hydra.c
@@ -105,7 +105,7 @@ static struct i2c_adapter hydra_adap = {
 	.algo_data	= &hydra_bit_data,
 };
 
-static const struct pci_device_id hydra_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(hydra_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_HYDRA) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index ab26840d..5d2e281 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -609,7 +609,7 @@ static const struct i2c_algorithm smbus_algorithm = {
 	.functionality	= i801_func,
 };
 
-static const struct pci_device_id i801_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AA_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_2) },
diff --git a/drivers/i2c/busses/i2c-intel-mid.c b/drivers/i2c/busses/i2c-intel-mid.c
index e828ac8..365bad5 100644
--- a/drivers/i2c/busses/i2c-intel-mid.c
+++ b/drivers/i2c/busses/i2c-intel-mid.c
@@ -1093,7 +1093,7 @@ static void __devexit intel_mid_i2c_remove(struct pci_dev *dev)
 	pci_release_region(dev, 0);
 }
 
-static struct pci_device_id intel_mid_i2c_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(intel_mid_i2c_ids) = {
 	/* Moorestown */
 	{ PCI_VDEVICE(INTEL, 0x0802), 0 },
 	{ PCI_VDEVICE(INTEL, 0x0803), 1 },
diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index 4853b52..43a96a1 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -309,7 +309,7 @@ static struct i2c_algorithm smbus_algorithm = {
 };
 
 
-static const struct pci_device_id nforce2_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(nforce2_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2S_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE3_SMBUS) },
diff --git a/drivers/i2c/busses/i2c-pasemi.c b/drivers/i2c/busses/i2c-pasemi.c
index 837b8c1..eaaea73 100644
--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -401,7 +401,7 @@ static void __devexit pasemi_smb_remove(struct pci_dev *dev)
 	kfree(smbus);
 }
 
-static const struct pci_device_id pasemi_smb_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(pasemi_smb_ids) = {
 	{ PCI_DEVICE(0x1959, 0xa003) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 6d14ac2..c14d48d 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -472,7 +472,7 @@ static struct i2c_adapter piix4_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
-static const struct pci_device_id piix4_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443MX_3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_EFAR, PCI_DEVICE_ID_EFAR_SLC90E66_3) },
diff --git a/drivers/i2c/busses/i2c-pxa-pci.c b/drivers/i2c/busses/i2c-pxa-pci.c
index 632e088..a058179 100644
--- a/drivers/i2c/busses/i2c-pxa-pci.c
+++ b/drivers/i2c/busses/i2c-pxa-pci.c
@@ -150,7 +150,7 @@ static void __devexit ce4100_i2c_remove(struct pci_dev *dev)
 	kfree(sds);
 }
 
-static struct pci_device_id ce4100_i2c_devices[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(ce4100_i2c_devices) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2e68)},
 	{ },
 };
diff --git a/drivers/i2c/busses/i2c-sis5595.c b/drivers/i2c/busses/i2c-sis5595.c
index 6d60284..87e5126 100644
--- a/drivers/i2c/busses/i2c-sis5595.c
+++ b/drivers/i2c/busses/i2c-sis5595.c
@@ -369,7 +369,7 @@ static struct i2c_adapter sis5595_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
-static const struct pci_device_id sis5595_ids[] __devinitconst = {
+static DEFINE_PCI_DEVICE_TABLE(sis5595_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_503) }, 
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
index 39a80cf..15cf78f 100644
--- a/drivers/i2c/busses/i2c-sis630.c
+++ b/drivers/i2c/busses/i2c-sis630.c
@@ -472,7 +472,7 @@ static struct i2c_adapter sis630_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
-static const struct pci_device_id sis630_ids[] __devinitconst = {
+static DEFINE_PCI_DEVICE_TABLE(sis630_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_503) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_LPC) },
 	{ 0, }
diff --git a/drivers/i2c/busses/i2c-sis96x.c b/drivers/i2c/busses/i2c-sis96x.c
index 86837f0..cc5d149 100644
--- a/drivers/i2c/busses/i2c-sis96x.c
+++ b/drivers/i2c/busses/i2c-sis96x.c
@@ -245,7 +245,7 @@ static struct i2c_adapter sis96x_adapter = {
 	.algo		= &smbus_algorithm,
 };
 
-static const struct pci_device_id sis96x_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(sis96x_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_SMBUS) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-via.c b/drivers/i2c/busses/i2c-via.c
index 7799fe5..713d31a 100644
--- a/drivers/i2c/busses/i2c-via.c
+++ b/drivers/i2c/busses/i2c-via.c
@@ -89,7 +89,7 @@ static struct i2c_adapter vt586b_adapter = {
 };
 
 
-static const struct pci_device_id vt586b_ids[] __devinitconst = {
+static DEFINE_PCI_DEVICE_TABLE(vt586b_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_3) },
 	{ 0, }
 };
diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
index a907983..333011c 100644
--- a/drivers/i2c/busses/i2c-viapro.c
+++ b/drivers/i2c/busses/i2c-viapro.c
@@ -441,7 +441,7 @@ release_region:
 	return error;
 }
 
-static const struct pci_device_id vt596_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(vt596_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C596_3),
 	  .driver_data = SMBBA1 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C596B_3),
diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 91e349c..2eacb77 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -559,7 +559,7 @@ static struct platform_driver scx200_pci_driver = {
 	.remove = __devexit_p(scx200_remove),
 };
 
-static const struct pci_device_id scx200_isa[] __initconst = {
+static DEFINE_PCI_DEVICE_TABLE(scx200_isa) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SCx200_BRIDGE) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SC1100_BRIDGE) },
 	{ 0, }
-- 
1.7.5.4



