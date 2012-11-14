Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161033Ab2KNJmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:42:49 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:37603 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab2KNJmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:42:37 -0500
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [RFC PATCH 09/10] s390/pci: add PCI Kconfig options
Date: Wed, 14 Nov 2012 10:41:41 +0100
Message-Id: <11dacadc68300a20c761d7098fffef1861bdbbab.1352719878.git.jang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
x-cbid: 12111409-0342-0000-0000-000003644459
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/Kconfig | 56 +++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 5dba755..e3dd4aec 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -34,12 +34,6 @@ config GENERIC_BUG
 config GENERIC_BUG_RELATIVE_POINTERS
 	def_bool y
 
-config NO_IOMEM
-	def_bool y
-
-config NO_DMA
-	def_bool y
-
 config ARCH_DMA_ADDR_T_64BIT
 	def_bool 64BIT
 
@@ -58,6 +52,12 @@ config KEXEC
 config AUDIT_ARCH
 	def_bool y
 
+config NO_IOPORT
+	def_bool y
+
+config PCI_QUIRKS
+	def_bool n
+
 config S390
 	def_bool y
 	select USE_GENERIC_SMP_HELPERS if SMP
@@ -423,6 +423,50 @@ config QDIO
 
 	  If unsure, say Y.
 
+menuconfig PCI
+	bool "PCI support" 
+	default y
+	depends on 64BIT 
+ 	select ARCH_SUPPORTS_MSI
+ 	select PCI_MSI
+	help
+	  Enable PCI support.
+
+if PCI
+
+config PCI_NR_FUNCTIONS
+	int "Maximum number of PCI functions (1-4096)"
+	range 1 4096
+	default "64"
+	help
+	  This allows you to specify the maximum number of PCI functions which
+	  this kernel will support.
+
+source "drivers/pci/Kconfig"
+source "drivers/pci/pcie/Kconfig"
+source "drivers/pci/hotplug/Kconfig"
+
+endif	# PCI
+
+config PCI_DOMAINS
+	def_bool PCI
+
+config HAS_IOMEM
+	def_bool PCI
+
+config IOMMU_HELPER
+	def_bool PCI
+
+config HAS_DMA
+	def_bool PCI
+	select HAVE_DMA_API_DEBUG
+
+config NEED_SG_DMA_LENGTH
+	def_bool PCI
+
+config HAVE_DMA_ATTRS
+	def_bool PCI
+
 config CHSC_SCH
 	def_tristate m
 	prompt "Support for CHSC subchannels"
-- 
1.7.12.4

