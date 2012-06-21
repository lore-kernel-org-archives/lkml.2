Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab2FUUZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:25:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183Ab2FUUZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:25:16 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 7/9] x86/PCI: move final fixup quirks from __init to __devinit
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 14:24:59 -0600
Message-ID: <20120621202459.16865.43604.stgit@amt.stowe>
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

 arch/x86/pci/fixup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index af8a224..8cefdbe 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -250,7 +250,7 @@ static struct pci_ops quirk_pcie_aspm_ops = {
  * the root port in an array for fast indexing. Replace the bus ops
  * with the modified one.
  */
-static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
+static void __devinit pcie_rootport_aspm_quirk(struct pci_dev *pdev)
 {
 	int cap_base, i;
 	struct pci_bus  *pbus;

