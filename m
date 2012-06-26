Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2FZDfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:35:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab2FZDcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:32:31 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 04/16] microblaze/PCI: Factor 'pcibios_setup()' out of
	microblaze
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
Date: Mon, 25 Jun 2012 21:31:23 -0600
Message-ID: <20120626033123.16434.47270.stgit@amt.stowe>
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
can be used by all architectures as a default.  Drop microblaze's
architecture specific version in favor of that as it does not need to be
over-ridden.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/microblaze/pci/pci-common.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index ed22bfc..7b510ae 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -192,11 +192,6 @@ void pcibios_set_master(struct pci_dev *dev)
 	/* No special bus mastering setup handling */
 }
 
-char __devinit *pcibios_setup(char *str)
-{
-	return str;
-}
-
 /*
  * Reads the interrupt pin to determine if interrupt is use by card.
  * If the interrupt is used, then gets the interrupt line from the

