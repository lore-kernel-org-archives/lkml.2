Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1GLQzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:55:11 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49396 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab1GLQzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:55:09 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] config: introduce an INTEL_MID configuration
To: x86@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 12 Jul 2011 17:49:29 +0100
Message-ID: <20110712164859.7642.84136.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We need to carve up the configuration between

- MID general
- Moorestown specific
- Medfield specific
- Future devices

As a base point create an INTEL_MID configuration property. We make the existing
MRST configuration a sub-option. This means that the rest of the kernel config
can still use X86_MRST checks without anything going backwards.

After this is merged future patches will tidy up which devices are MID and
which are X86_MRST, as well as add options for Medfield.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..aecacab 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -384,12 +384,21 @@ config X86_INTEL_CE
 	  This option compiles in support for the CE4100 SOC for settop
 	  boxes and media devices.
 
+config X86_INTEL_MID
+	bool "Intel MID platform support"
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	---help---
+	  Select to build a kernel capable of supporting Intel MID platform
+	  systems which do not have the PCI legacy interfaces (Moorestown,
+	  Medfield). If you are building for a PC class system say N here.
+
+if X86_INTEL_MID
+
 config X86_MRST
        bool "Moorestown MID platform"
 	depends on PCI
 	depends on PCI_GOANY
-	depends on X86_32
-	depends on X86_EXTENDED_PLATFORM
 	depends on X86_IO_APIC
 	select APB_TIMER
 	select I2C
@@ -404,6 +413,8 @@ config X86_MRST
 	  nor standard legacy replacement devices/features. e.g. Moorestown does
 	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
 
+endif
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32

