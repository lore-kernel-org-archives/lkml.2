Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2C3XkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:40:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44619 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976Ab2C3XkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:40:09 -0400
From: Oskar Andero <oskar.andero@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>,
        trivial@kernel.org, Oskar Andero <oskar.andero@gmail.com>
Subject: [PATCH] ARM: versatile: fix broken build in pci.c
Date: Sat, 31 Mar 2012 01:37:37 +0200
Message-Id: <1333150657-6534-1-git-send-email-oskar.andero@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An undefined reference to sys was introduced by 9f786d03.

Signed-off-by: Oskar Andero <oskar.andero@gmail.com>
---
 arch/arm/mach-versatile/pci.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index a6e23f4..e4447dd 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -190,8 +190,9 @@ static struct resource pre_mem = {
 	.flags	= IORESOURCE_MEM | IORESOURCE_PREFETCH,
 };
 
-static int __init pci_versatile_setup_resources(struct list_head *resources)
+static int __init pci_versatile_setup_resources(struct pci_sys_data *sys)
 {
+	struct list_head *resources = &sys->resources;
 	int ret = 0;
 
 	ret = request_resource(&iomem_resource, &io_mem);
@@ -249,7 +250,7 @@ int __init pci_versatile_setup(int nr, struct pci_sys_data *sys)
 
 	if (nr == 0) {
 		sys->mem_offset = 0;
-		ret = pci_versatile_setup_resources(&sys->resources);
+		ret = pci_versatile_setup_resources(sys);
 		if (ret < 0) {
 			printk("pci_versatile_setup: resources... oops?\n");
 			goto out;
-- 
1.7.3.4

