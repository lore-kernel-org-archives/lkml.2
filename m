Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab2B2XJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:09:41 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25998 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964795Ab2B2XIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:08:45 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Subject: [PATCH 26/39] PCI, ia64: Register busn_res for root buses
Date: Wed, 29 Feb 2012 15:07:25 -0800
Message-Id: <1330556858-11768-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F4EAFF4.00C4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-v2: according to Bjorn, use root->secondary directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/pci/pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index d1ce320..6c7c4ae 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -352,6 +352,8 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 #endif
 
 	INIT_LIST_HEAD(&info.resources);
+	/* insert busn resource at first */
+	pci_add_resource(&info.resources, &root->secondary);
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_window,
 			&windows);
 	if (windows) {
-- 
1.7.7

