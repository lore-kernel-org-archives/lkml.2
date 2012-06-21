Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab2FUUYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab2FUUYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:24:45 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 3/9] arm/PCI: move final fixup quirks from __init to __devinit
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 14:24:35 -0600
Message-ID: <20120621202435.16865.1340.stgit@amt.stowe>
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

 arch/arm/mach-iop32x/n2100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
index 5a7ae91..04c4110 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -126,7 +126,7 @@ static struct hw_pci n2100_pci __initdata = {
  * the ->broken_parity_status flag for both ports so that the r8169
  * driver knows it should ignore error interrupts.
  */
-static void n2100_fixup_r8169(struct pci_dev *dev)
+static void __devinit n2100_fixup_r8169(struct pci_dev *dev)
 {
 	if (dev->bus->number == 0 &&
 	    (dev->devfn == PCI_DEVFN(1, 0) ||

