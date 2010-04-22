Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab0DVTlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:41:47 -0400
Received: from kroah.org ([198.145.64.141]:41352 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761Ab0DVT30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:26 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:20 2010
Message-Id: <20100422190920.376690826@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Seth Heasley <seth.heasley@intel.com>,
       Jean Delvare <khali@linux-fr.org>, maximilian attems <max@stro.at>
Subject: [146/197] i2c-i801: Add Intel Cougar Point device IDs
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 393764340beb595c1ad7dd2d2243c2b6551aaa71 upstream.

Add the Intel Cougar Point (PCH) SMBus controller device IDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/i2c/busses/i2c-i801 |    3 ++-
 drivers/i2c/busses/Kconfig        |    5 +++--
 drivers/i2c/busses/i2c-i801.c     |    5 ++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -15,7 +15,8 @@ Supported adapters:
   * Intel 82801I (ICH9)
   * Intel EP80579 (Tolapai)
   * Intel 82801JI (ICH10)
-  * Intel PCH
+  * Intel 3400/5 Series (PCH)
+  * Intel Cougar Point (PCH)
    Datasheets: Publicly available at the Intel website
 
 Authors: 
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -77,7 +77,7 @@ config I2C_AMD8111
 	  will be called i2c-amd8111.
 
 config I2C_I801
-	tristate "Intel 82801 (ICH)"
+	tristate "Intel 82801 (ICH/PCH)"
 	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the Intel
@@ -97,7 +97,8 @@ config I2C_I801
 	    ICH9
 	    Tolapai
 	    ICH10
-	    PCH
+	    3400/5 Series (PCH)
+	    Cougar Point (PCH)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -41,7 +41,8 @@
   Tolapai               0x5032     32     hard     yes     yes     yes
   ICH10                 0x3a30     32     hard     yes     yes     yes
   ICH10                 0x3a60     32     hard     yes     yes     yes
-  PCH                   0x3b30     32     hard     yes     yes     yes
+  3400/5 Series (PCH)   0x3b30     32     hard     yes     yes     yes
+  Cougar Point (PCH)    0x1c22     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -580,6 +581,7 @@ static struct pci_device_id i801_ids[] =
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CPT_SMBUS) },
 	{ 0, }
 };
 
@@ -709,6 +711,7 @@ static int __devinit i801_probe(struct p
 	case PCI_DEVICE_ID_INTEL_ICH10_4:
 	case PCI_DEVICE_ID_INTEL_ICH10_5:
 	case PCI_DEVICE_ID_INTEL_PCH_SMBUS:
+	case PCI_DEVICE_ID_INTEL_CPT_SMBUS:
 		i801_features |= FEATURE_I2C_BLOCK_READ;
 		/* fall through */
 	case PCI_DEVICE_ID_INTEL_82801DB_3:


