Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab2FZDdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:33:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab2FZDdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:33:07 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 09/16] sh/PCI: Factor 'pcibios_setup()' out of sh
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, linux@arm.linux.org.uk, starvik@axis.com,
        jesper.nilsson@axis.com, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chris@zankel.net, linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 21:31:58 -0600
Message-ID: <20120626033158.16434.94698.stgit@amt.stowe>
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI core provides a generic (__weak) 'pcibios_setup()' routine that can
be used by all architectures as a default.  Drop sh's architecture specific
version in favor of that as it does not need to be over-ridden.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/sh/drivers/pci/pci.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index 9d10a3c..7d42288 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -197,11 +197,6 @@ void __init pcibios_update_irq(struct pci_dev *dev, int irq)
 	pci_write_config_byte(dev, PCI_INTERRUPT_LINE, irq);
 }
 
-char * __devinit __weak pcibios_setup(char *str)
-{
-	return str;
-}
-
 static void __init
 pcibios_bus_report_status_early(struct pci_channel *hose,
 				int top_bus, int current_bus,

