Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608Ab2CSFot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:44:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28362 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030395Ab2CSFoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:44:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        sparclinux@vger.kernel.org
Subject: [PATCH -v11 14/30] PCI, sparc: Register busn_res for root buses
Date: Sun, 18 Mar 2012 22:42:45 -0700
Message-Id: <1332135781-13695-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F66C7C4.008F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/pci.c      |    4 ++++
 arch/sparc/kernel/pci_impl.h |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 253e8ac..1687fed 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -695,6 +695,10 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm,
 				pbm->io_space.start);
 	pci_add_resource_offset(&resources, &pbm->mem_space,
 				pbm->mem_space.start);
+	pbm->busn.start = pbm->pci_first_busno;
+	pbm->busn.end	= pbm->pci_last_busn;
+	pbm->busn.flags	= IORESOURCE_BUS;
+	pci_add_resource(&resources, &pbm->busn);
 	bus = pci_create_root_bus(parent, pbm->pci_first_busno, pbm->pci_ops,
 				  pbm, &resources);
 	if (!bus) {
diff --git a/arch/sparc/kernel/pci_impl.h b/arch/sparc/kernel/pci_impl.h
index 6beb60d..918a203 100644
--- a/arch/sparc/kernel/pci_impl.h
+++ b/arch/sparc/kernel/pci_impl.h
@@ -97,6 +97,7 @@ struct pci_pbm_info {
 	/* PBM I/O and Memory space resources. */
 	struct resource			io_space;
 	struct resource			mem_space;
+	struct resource			busn;
 
 	/* Base of PCI Config space, can be per-PBM or shared. */
 	unsigned long			config_space;
-- 
1.7.7

