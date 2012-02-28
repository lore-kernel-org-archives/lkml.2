Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2B1WKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:10:36 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:28853 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab2B1WKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:10:31 -0500
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
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Subject: [PATCH 12/24] PCI, ia64: Register busn_res for root buses
Date: Tue, 28 Feb 2012 14:07:31 -0800
Message-Id: <1330466863-28469-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
References: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F4D5091.0096,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/include/asm/pci.h |    1 +
 arch/ia64/pci/pci.c         |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index b22e5f5..6e54220 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -94,6 +94,7 @@ struct pci_controller {
 
 	unsigned int windows;
 	struct pci_window *window;
+	struct resource busn;
 
 	void *platform_data;
 };
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index d1ce320..b250f0f 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -332,6 +332,7 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct acpi_device *device = root->device;
 	int domain = root->segment;
 	int bus = root->secondary.start;
+	int busmax = root->secondary.end;
 	struct pci_controller *controller;
 	unsigned int windows = 0;
 	struct pci_root_info info;
@@ -372,6 +373,10 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
 		acpi_walk_resources(device->handle, METHOD_NAME__CRS,
 			add_window, &info);
 	}
+	controller->busn.start = bus;
+	controller->busn.end = busmax;
+	conttoller->busn.flags = IORESOURCE_BUS;
+	pci_add_resource(&info.resources, &controller->busn);
 	/*
 	 * See arch/x86/pci/acpi.c.
 	 * The desired pci bus might already be scanned in a quirk. We
-- 
1.7.7

