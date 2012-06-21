Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab2FUUY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:24:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab2FUUYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:24:53 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 4/9] MIPS/PCI: move final fixup quirks from __init to __devinit
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 14:24:41 -0600
Message-ID: <20120621202441.16865.64949.stgit@amt.stowe>
In-Reply-To: <20120621202415.16865.6226.stgit@amt.stowe>
References: <20120621202415.16865.6226.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI subsystem's final fixups are executed once during boot, after the
pci-device is found.  As long as the system does not support hot-plug,
specifying __init is fine.

With hot-plug, either physically based hot-plug events or pseudo hot-plug
events such as "echo 1 > /sys/bus/pci/rescan", it is possible to remove a
PCI bus during run time and have it rediscovered which will require the
call of the fixups again in order for the device to function properly.

This patch prepares specific quirk(s) for use with hot-plug events.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/mips/txx9/generic/pci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/txx9/generic/pci.c b/arch/mips/txx9/generic/pci.c
index 682efb0..de83b30 100644
--- a/arch/mips/txx9/generic/pci.c
+++ b/arch/mips/txx9/generic/pci.c
@@ -304,7 +304,7 @@ static void __init quirk_slc90e66_bridge(struct pci_dev *dev)
 	smsc_fdc37m81x_config_end();
 }
 
-static void quirk_slc90e66_ide(struct pci_dev *dev)
+static void __devinit quirk_slc90e66_ide(struct pci_dev *dev)
 {
 	unsigned char dat;
 	int regs[2] = {0x41, 0x43};
@@ -339,7 +339,7 @@ static void quirk_slc90e66_ide(struct pci_dev *dev)
 }
 #endif /* CONFIG_TOSHIBA_FPCIB0 */
 
-static void tc35815_fixup(struct pci_dev *dev)
+static void __devinit tc35815_fixup(struct pci_dev *dev)
 {
 	/* This device may have PM registers but not they are not suported. */
 	if (dev->pm_cap) {
@@ -348,7 +348,7 @@ static void tc35815_fixup(struct pci_dev *dev)
 	}
 }
 
-static void final_fixup(struct pci_dev *dev)
+static void __devinit final_fixup(struct pci_dev *dev)
 {
 	unsigned char bist;
 

