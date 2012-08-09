Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2HIQoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:44:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:43333 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab2HIQo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,741,1336374000"; 
   d="scan'208";a="178057288"
From: james.d.ralston@intel.com
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Rob Landley <rob@landley.net>
Cc: Seth Heasley <seth.heasley@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Olof Johansson <olof@lixom.net>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 4/5] i2c-i801: Add Device IDs for Intel Lynx Point-LP PCH
Date: Thu,  9 Aug 2012 09:43:52 -0700
Message-Id: <1344530632-2645-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Ralston <james.d.ralston@intel.com>

This patch adds the SMBus Device IDs for the Intel Lynx Point-LP PCH. The Device IDs are defined in drivers/i2c/busses/i2c-i801.c

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 Documentation/i2c/busses/i2c-i801 |    1 +
 drivers/i2c/busses/Kconfig        |    1 +
 drivers/i2c/busses/i2c-i801.c     |    3 +++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index 615142d..53207df 100644
--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -21,6 +21,7 @@ Supported adapters:
   * Intel DH89xxCC (PCH)
   * Intel Panther Point (PCH)
   * Intel Lynx Point (PCH)
+  * Intel Lynx Point_LP (PCH)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 2e7530a..3500af7 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -104,6 +104,7 @@ config I2C_I801
 	    DH89xxCC (PCH)
 	    Panther Point (PCH)
 	    Lynx Point (PCH)
+	    Lynx Point_LP (PCH)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 898dcf9..c467038 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -52,6 +52,7 @@
   DH89xxCC (PCH)        0x2330     32     hard     yes     yes     yes
   Panther Point (PCH)   0x1e22     32     hard     yes     yes     yes
   Lynx Point (PCH)      0x8c22     32     hard     yes     yes     yes
+  Lynx Point_LP (PCH)   0x9c22     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -155,6 +156,7 @@
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22
 
 struct i801_priv {
 	struct i2c_adapter adapter;
@@ -771,6 +773,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS) },
 	{ 0, }
 };
 
-- 
1.7.7.6

