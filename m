Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab1GKPDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:03:30 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:33784 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757775Ab1GKPD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:03:29 -0400
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH] x86, quirks: use pci_dev->revision
Content-Disposition: inline
Cc: linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
Date: Mon, 11 Jul 2011 19:01:38 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111901.39281.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it wasn't
converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all
drivers to use pci_device->revision) before being moved to arch/x86/...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

 arch/x86/kernel/quirks.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/quirks.c
+++ linux-2.6/arch/x86/kernel/quirks.c
@@ -10,7 +10,7 @@
 
 static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 {
-	u8 config, rev;
+	u8 config;
 	u16 word;
 
 	/* BIOS may enable hardware IRQ balancing for
@@ -18,8 +18,7 @@ static void __devinit quirk_intel_irqbal
 	 * based platforms.
 	 * Disable SW irqbalance/affinity on those platforms.
 	 */
-	pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
-	if (rev > 0x9)
+	if (dev->revision > 0x9)
 		return;
 
 	/* enable access to config space*/
