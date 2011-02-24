Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1BXSI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:08:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:64709 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab1BXSHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:07:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,219,1297065600"; 
   d="scan'208";a="890936975"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com, christophe.guerard@intel.com
Subject: [PATCH 04/10] PTI Makefile and Kconfig additions.
Date: Thu, 24 Feb 2011 10:06:58 -0800
Message-Id: <1298570824-26085-5-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This allows the Intel implementation of the PTI standard to be
compiled and configured in Kconfig.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/Kconfig  |   12 ++++++++++++
 drivers/misc/Makefile |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4d073f1..f8076f1 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -136,6 +136,18 @@ config PHANTOM
 	  If you choose to build module, its name will be phantom. If unsure,
 	  say N here.
 
+config INTEL_MID_PTI
+        tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
+        help
+          The PTI (Parallel Trace Interface) driver directs
+          trace data routed from various parts in the system out
+          through an Intel Penwell PTI port and out of the mobile
+          device for analysis with a debugging tool (Lauterbach or Fido).
+
+          You should select this driver if the target kernel is meant for
+          an Intel Atom (non-netbook) mobile device containing a MIPI
+          P1149.7 standard implementation.
+
 config SGI_IOC4
 	tristate "SGI IOC4 Base IO support"
 	depends on PCI
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 98009cc..cae0463 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_AD525X_DPOT)	+= ad525x_dpot.o
 obj-$(CONFIG_AD525X_DPOT_I2C)	+= ad525x_dpot-i2c.o
 obj-$(CONFIG_AD525X_DPOT_SPI)	+= ad525x_dpot-spi.o
+obj-$(CONFIG_INTEL_MID_PTI)     += pti.o
 obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
-- 
1.7.2.3

