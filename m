Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab2FZDcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:32:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab2FZDc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:32:27 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 02/16] alpha/PCI: Factor 'pcibios_setup()' out of alpha
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
Date: Mon, 25 Jun 2012 21:31:10 -0600
Message-ID: <20120626033109.16434.92644.stgit@amt.stowe>
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
that can be used by all architectures as a default.  Drop alpha's
architecture specific version in favor of that as it does not need to be
over-ridden.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/alpha/kernel/pci.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index 1a62963..133d2d4 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -198,12 +198,6 @@ pcibios_init(void)
 
 subsys_initcall(pcibios_init);
 
-char * __devinit
-pcibios_setup(char *str)
-{
-	return str;
-}
-
 #ifdef ALPHA_RESTORE_SRM_SETUP
 static struct pdev_srm_saved_conf *srm_saved_configs;
 

