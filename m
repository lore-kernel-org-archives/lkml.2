Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab2FZDcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:32:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653Ab2FZDct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:32:49 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 07/16] parisc/PCI: Factor 'pcibios_setup()' out of parisc
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
Date: Mon, 25 Jun 2012 21:31:44 -0600
Message-ID: <20120626033144.16434.53776.stgit@amt.stowe>
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI core provides a generic (__weak) 'pcibios_setup()' routine that
can be used by all architectures as a default.  Drop parisc's architecture
specific version in favor of that as it does not need to be over-ridden.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/parisc/kernel/pci.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/pci.c b/arch/parisc/kernel/pci.c
index 24644ac..6030905 100644
--- a/arch/parisc/kernel/pci.c
+++ b/arch/parisc/kernel/pci.c
@@ -139,11 +139,6 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 }
 
 
-char *pcibios_setup(char *str)
-{
-	return str;
-}
-
 /*
  * Called by pci_set_master() - a driver interface.
  *

