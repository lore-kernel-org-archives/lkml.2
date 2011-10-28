Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab1J1Vvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:51:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933502Ab1J1Vvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:51:52 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 16/16] PCI: latency timer doesn't apply to PCIe
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:49:20 -0600
Message-ID: <20111028214920.20088.85205.stgit@amt.stowe>
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

The latency timer is read-only and hardwired to zero for all PCIe
devices, both Type 0 and Type 1, so don't bother trying to update it
and cluttering the dmesg log with meaningless "setting latency timer
to 64" messages.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/pci.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a50e643..a20c01a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2607,6 +2607,10 @@ void __weak pcibios_set_master(struct pci_dev *dev)
 {
 	u8 lat;
 
+	/* The latency timer doesn't apply to PCIe (either Type 0 or Type 1) */
+	if (pci_is_pcie(dev))
+		return;
+
 	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
 	if (lat < 16)
 		lat = (64 <= pcibios_max_latency) ? 64 : pcibios_max_latency;

