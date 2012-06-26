Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2FZDd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:33:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058Ab2FZDdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:33:24 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 12/16] tile/PCI: Factor 'pcibios_setup()' out of tile
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
Date: Mon, 25 Jun 2012 21:32:19 -0600
Message-ID: <20120626033218.16434.50584.stgit@amt.stowe>
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI core provides a generic (__weak) 'pcibios_setup()' routine
that can be used by all architectures as a default.  Drop tile's
architecture specific version in favor of that as it does not need to be
over-ridden.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/tile/kernel/pci.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index b56d12b..e257226 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -401,16 +401,6 @@ void pcibios_set_master(struct pci_dev *dev)
 }
 
 /*
- * This can be called from the generic PCI layer, but doesn't need to
- * do anything.
- */
-char __devinit *pcibios_setup(char *str)
-{
-	/* Nothing needs to be done. */
-	return str;
-}
-
-/*
  * This is called from the generic Linux layer.
  */
 void __devinit pcibios_update_irq(struct pci_dev *dev, int irq)

