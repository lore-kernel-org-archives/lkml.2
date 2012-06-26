Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab2FZDd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:33:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758234Ab2FZDd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:33:57 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 16/16] cris/PCI: Factor 'pcibios_setup()' out of cris
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
Date: Mon, 25 Jun 2012 21:32:46 -0600
Message-ID: <20120626033246.16434.46899.stgit@amt.stowe>
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes what looks like a bug in cris, which implements
pcibios_setup() such that pci_setup() doesn't look for any generic
options.

The PCI core provides a generic (__weak) 'pcibios_setup()' routine
that can be used by all architectures as a default.  Drop cris's
architecture specific version in favor of that as it does not need to be
over-ridden.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/cris/arch-v32/drivers/pci/bios.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
index bc0cfda..5b1ee82 100644
--- a/arch/cris/arch-v32/drivers/pci/bios.c
+++ b/arch/cris/arch-v32/drivers/pci/bios.c
@@ -6,11 +6,6 @@ void __devinit  pcibios_fixup_bus(struct pci_bus *b)
 {
 }
 
-char * __devinit  pcibios_setup(char *str)
-{
-	return NULL;
-}
-
 void pcibios_set_master(struct pci_dev *dev)
 {
 	u8 lat;

