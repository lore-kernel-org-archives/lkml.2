Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2B1CGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:06:00 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25687 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2B1CEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:04:52 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/11] x86, PCI: embed name acpi version pci_root_info struct
Date: Mon, 27 Feb 2012 18:03:49 -0800
Message-Id: <1330394631-28978-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330394631-28978-1-git-send-email-yinghai@kernel.org>
References: <1330394631-28978-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020206.4F4C3642.0042,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now We allocate info, and keep that in during whole life of hostbridge.

So don't allocate info->name seperately, just put name into struct.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/acpi.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 208f257..7538fad 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -9,7 +9,7 @@
 
 struct pci_root_info {
 	struct acpi_device *bridge;
-	char *name;
+	char name[16];
 	unsigned int res_num;
 	struct resource *res;
 	int busnum;
@@ -307,7 +307,6 @@ static void add_resources(struct pci_root_info *info,
 
 static void free_pci_root_info(struct pci_root_info *info)
 {
-	kfree(info->name);
 	kfree(info->res);
 	kfree(info);
 }
@@ -357,9 +356,7 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 	if (!info->res)
 		return;
 
-	info->name = kasprintf(GFP_KERNEL, "PCI Bus %04x:%02x", domain, busnum);
-	if (!info->name)
-		return;
+	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
 
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				info);
-- 
1.7.7

