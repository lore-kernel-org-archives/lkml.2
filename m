Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2EGUam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:30:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51085 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2EGUag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:30:36 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Subject: [PATCH 15/21] ia64/PCI: register busn_res for root buses
Date: Mon,  7 May 2012 13:30:00 -0700
Message-Id: <1336422606-4244-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the host bridge bus number aperture from _CRS to the resource list.
Like the MMIO and I/O port apertures, this is used when assigning
resources to hot-added devices or in the case of conflicts.

[bhelgaas: write changelog]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/pci/pci.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 3ca9bed..d173a88 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -351,6 +351,8 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 #endif
 
 	INIT_LIST_HEAD(&info.resources);
+	/* insert busn resource at first */
+	pci_add_resource(&info.resources, &root->secondary);
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_window,
 			&windows);
 	if (windows) {
@@ -384,7 +386,7 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 		return NULL;
 	}
 
-	pbus->busn_res.end = pci_scan_child_bus(pbus);
+	pci_scan_child_bus(pbus);
 	return pbus;
 
 out3:
-- 
1.7.7

