Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946035Ab2LGGZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:25:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGGZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:25:33 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 06/15] PCI/acpiphp: Convert "acpiphp" sub-driver's
	functionality to built-in only
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:30 -0700
Message-ID: <20121207062530.11051.47869.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ACPI Hot Plug PCI Controller ("acpiphp")" sub-driver may be compiled
as a module.  Kernel modules are instantiated somewhat randomly - the
order in which they are linked as the kernel as built - thus if there are
any dependencies on the ordering of attaching sub-drivers, they can not be
effectively dealt with.

This patch series resolves any potential sequencing inter-dependencies by
converting "acpiphp" sub-driver's functionality to being only supported as
statically built-in to the kernel.  Inter-dependencies can then be
effectively handled by explicitly sequencing the addition of such
functionality.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/hotplug/Kconfig |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index b0e46de..3bf2b82 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -52,15 +52,12 @@ config HOTPLUG_PCI_IBM
 	  When in doubt, say N.
 
 config HOTPLUG_PCI_ACPI
-	tristate "ACPI PCI Hotplug driver"
+	bool "ACPI PCI Hotplug driver"
 	depends on (!ACPI_DOCK && ACPI) || (ACPI_DOCK)
 	help
 	  Say Y here if you have a system that supports PCI Hotplug using
 	  ACPI.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called acpiphp.
-
 	  When in doubt, say N.
 
 config HOTPLUG_PCI_ACPI_IBM

