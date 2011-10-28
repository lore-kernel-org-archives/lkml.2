Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab1J1VuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:50:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531Ab1J1Vte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:49:34 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 13/16] PCI: mn10300: use generic pcibios_set_master()
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:48:59 -0600
Message-ID: <20111028214859.20088.60760.stgit@amt.stowe>
In-Reply-To: <20111028214726.20088.30551.stgit@amt.stowe>
References: <20111028214726.20088.30551.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

This patch removes mn10300's architecture-specific 'pcibios_set_master()'
routine for ASB2305 and lets the default PCI core based implementation
handle PCI device 'latency timer' setup.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/mn10300/unit-asb2305/pci-asb2305.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.c b/arch/mn10300/unit-asb2305/pci-asb2305.c
index 2b299c4..c4e2e79 100644
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c
+++ b/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -213,22 +213,6 @@ void __init pcibios_resource_survey(void)
 	pcibios_allocate_resources(1);
 }
 
-void pcibios_set_master(struct pci_dev *dev)
-{
-	u8 lat;
-
-	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
-
-	if (lat < 16)
-		lat = (64 <= pcibios_max_latency) ? 64 : pcibios_max_latency;
-	else if (lat > pcibios_max_latency)
-		lat = pcibios_max_latency;
-	else
-		return;
-
-	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
-}
-
 int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			enum pci_mmap_state mmap_state, int write_combine)
 {

