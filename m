Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab2FZDco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:32:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644Ab2FZDcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:32:36 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 05/16] MIPS/PCI: Factor 'pcibios_setup()' out of
	MIPS/pmc-sierra
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
Date: Mon, 25 Jun 2012 21:31:30 -0600
Message-ID: <20120626033130.16434.80126.stgit@amt.stowe>
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
can be used by all architectures as a default.  Drop MIPS/pmc-sierra's
architecture specific version in favor of that as it does not need to be
over-ridden.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/mips/pmc-sierra/yosemite/ht.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/mips/pmc-sierra/yosemite/ht.c b/arch/mips/pmc-sierra/yosemite/ht.c
index 63be40e..14dc9c8 100644
--- a/arch/mips/pmc-sierra/yosemite/ht.c
+++ b/arch/mips/pmc-sierra/yosemite/ht.c
@@ -395,17 +395,6 @@ void __init pcibios_init(void)
         pci_scan_bus(3, &titan_pci_ops, NULL);
 }
 
-/*
- * for parsing "pci=" kernel boot arguments.
- */
-char *pcibios_setup(char *str)
-{
-        printk(KERN_INFO "rr: pcibios_setup\n");
-        /* Nothing to do for now.  */
-
-        return str;
-}
-
 unsigned __init int pcibios_assign_all_busses(void)
 {
         /* We want to use the PCI bus detection done by PMON */

