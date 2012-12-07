Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946162Ab2LGG0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:26:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGG0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:26:14 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 13/15] PCI/ACPI: Convert "pci_slot" sub-driver's functionality
	to built-in only
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:26:11 -0700
Message-ID: <20121207062611.11051.39999.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ACPI PCI Slot Detection ("pci_slot")" sub-driver may be compiled as a
module.  Kernel modules are instantiated somewhat randomly - the order in
which they are linked as the kernel as built - thus if there are any
dependencies on the ordering of attaching sub-drivers, they can not be
effectively dealt with.

This patch series resolves any potential sequencing inter-dependencies by
converting "pci_slot" sub-driver's functionality to being only supported
as statically built-in to the kernel.  Inter-dependencies can then be
effectively handled by explicitly sequencing the addition of such
functionality.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/acpi/Kconfig |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 119d58d..988bb13 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -293,7 +293,7 @@ config ACPI_DEBUG_FUNC_TRACE
 	  is about half of the penalty and is rarely useful.
 
 config ACPI_PCI_SLOT
-	tristate "PCI slot detection driver"
+	bool "PCI slot detection driver"
 	depends on SYSFS
 	default n
 	help
@@ -302,9 +302,6 @@ config ACPI_PCI_SLOT
 	  i.e., segment/bus/device/function tuples, with physical slots in
 	  the system.  If you are unsure, say N.
 
-	  To compile this driver as a module, choose M here:
-	  the module will be called pci_slot.
-
 config X86_PM_TIMER
 	bool "Power Management Timer Support" if EXPERT
 	depends on X86

