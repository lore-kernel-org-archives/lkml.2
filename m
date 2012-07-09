Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2GIVgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:36:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab2GIVgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:36:49 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 6/8] x86/PCI: Move final fixup quirks from __init to
	__devinit
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, ralf@linux-mips.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 15:36:33 -0600
Message-ID: <20120709213633.8975.74128.stgit@amt.stowe>
In-Reply-To: <20120709213554.8975.60552.stgit@amt.stowe>
References: <20120709213554.8975.60552.stgit@amt.stowe>
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

 arch/x86/kernel/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 03920a1..1b27de5 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -512,7 +512,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 
 #if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
 /* Set correct numa_node information for AMD NB functions */
-static void __init quirk_amd_nb_node(struct pci_dev *dev)
+static void __devinit quirk_amd_nb_node(struct pci_dev *dev)
 {
 	struct pci_dev *nb_ht;
 	unsigned int devfn;

