Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1AJVTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:19:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:1595 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab1AJVTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:19:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,303,1291622400"; 
   d="scan'208";a="695402902"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: khali@linux-fr.org
Subject: [PATCH 2.6.37] i2c-i801: SMBus patch for Intel DH89xxCC DeviceIDs
Date: Mon, 10 Jan 2011 13:09:03 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101101309.03439.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the SMBus Controller DeviceIDs for the Intel DH89xxCC PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.37/drivers/i2c/busses/i2c-i801.c.orig	2011-01-04 16:50:19.000000000 -0800
+++ linux-2.6.37/drivers/i2c/busses/i2c-i801.c	2011-01-06 14:26:20.000000000 -0800
@@ -44,11 +44,12 @@
   ICH10                 0x3a30     32     hard     yes     yes     yes
   ICH10                 0x3a60     32     hard     yes     yes     yes
   5/3400 Series (PCH)   0x3b30     32     hard     yes     yes     yes
-  Cougar Point (PCH)    0x1c22     32     hard     yes     yes     yes
+  6 Series (PCH)        0x1c22     32     hard     yes     yes     yes
   Patsburg (PCH)        0x1d22     32     hard     yes     yes     yes
   Patsburg (PCH) IDF    0x1d70     32     hard     yes     yes     yes
   Patsburg (PCH) IDF    0x1d71     32     hard     yes     yes     yes
   Patsburg (PCH) IDF    0x1d72     32     hard     yes     yes     yes
+  DH89xxCC (PCH)        0x2330     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -620,6 +621,7 @@
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF2) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS) },
 	{ 0, }
 };
 
--- linux-2.6.37/drivers/i2c/busses/Kconfig.orig	2011-01-04 16:50:19.000000000 -0800
+++ linux-2.6.37/drivers/i2c/busses/Kconfig	2011-01-06 14:25:56.000000000 -0800
@@ -98,8 +98,9 @@
 	    EP80579 (Tolapai)
 	    ICH10
 	    5/3400 Series (PCH)
-	    Cougar Point (PCH)
+	    6 Series (PCH)
 	    Patsburg (PCH)
+	    DH89xxCC (PCH)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
--- linux-2.6.37/Documentation/i2c/busses/i2c-i801.orig	2011-01-04 16:50:19.000000000 -0800
+++ linux-2.6.37/Documentation/i2c/busses/i2c-i801	2011-01-06 14:27:03.000000000 -0800
@@ -16,8 +16,9 @@
   * Intel EP80579 (Tolapai)
   * Intel 82801JI (ICH10)
   * Intel 5/3400 Series (PCH)
-  * Intel Cougar Point (PCH)
+  * Intel 6 Series (PCH)
   * Intel Patsburg (PCH)
+  * Intel DH89xxCC (PCH)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
