Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab1J1VsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:48:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933414Ab1J1VsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:48:23 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 01/16] PCI: add declaration for pcibios_set_master() to
	pci core
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:47:35 -0600
Message-ID: <20111028214735.20088.19168.stgit@amt.stowe>
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

Currently, pcibios_set_master() is implemented in architecture-
specific code.  There is nothing architecture-specific about PCI's
'latency timer'.

This patch adds a declaration for pcibios_set_master() to PCI's core
in preperation for pulling the function itself up into the core.
Without the addition of this declaration, subsequent patches that
remove inline definitions of pcibios_set_master() would be removing
the only declaration of such.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 include/linux/pci.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8c230cb..abbd8b6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1440,8 +1440,10 @@ extern u8 pci_cache_line_size;
 extern unsigned long pci_hotplug_io_size;
 extern unsigned long pci_hotplug_mem_size;
 
+/* Architecture specific versions may override these (weak) */
 int pcibios_add_platform_entries(struct pci_dev *dev);
 void pcibios_disable_device(struct pci_dev *dev);
+void pcibios_set_master(struct pci_dev *dev);
 int pcibios_set_pcie_reset_state(struct pci_dev *dev,
 				 enum pcie_reset_state state);
 

