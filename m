Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab3AIUsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:48:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130Ab3AIUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:26 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 06/14] ARM: pci: Keep pci_common_init() around after init
Date: Wed,  9 Jan 2013 21:43:06 +0100
Message-Id: <1357764194-12677-7-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:3FqpPzcP1jcxg7vB4+MkShRkzDny4tK3z5RxwL3y9s6
 WzRhxVL7N11uUouWzT5Dg1pxkUbE9eDwyp7bnc4OC5hyniI/LJ
 c59XPD18zaa9vc5uRQ3ekI/bf7Yq7J3vt6oUqllrxqbnLz9pD/
 lTOChfM2nf/LydI3U2R29Vvb4yqgIomWI3L62nMPVV6Q0K43qr
 KbEySC3Vz+2NHI+JHgupTVtLfUVC1cLhcQGeydRbigBl/PutBm
 FNKam7GT6cZEJyt1QW+CFxrTn6X7ul2cXwiRfdJFZDjsONXFz3
 q9i4f8p0rMjmvCvi8Xtp44zcgDjKiqUkKCFSBQ9Bf6GYg/8rR3
 7scGMeJZW97ZusL9TzgGZhDpCiaBvooE94KzlIQnu/c7sx2Guw
 GUhWyDEDJbT/ZpWvwA7WmbkgtWQ2RGFJQGFlK291av421X7ems
 U4PxJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using deferred driver probing, PCI host controller drivers may
actually require this function after the init stage.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/kernel/bios32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 379cf32..da7b0c9 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -413,7 +413,7 @@ static int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return irq;
 }
 
-static int __init pcibios_init_resources(int busnr, struct pci_sys_data *sys)
+static int pcibios_init_resources(int busnr, struct pci_sys_data *sys)
 {
 	int ret;
 	struct pci_host_bridge_window *window;
@@ -445,7 +445,7 @@ static int __init pcibios_init_resources(int busnr, struct pci_sys_data *sys)
 	return 0;
 }
 
-static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
+static void pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 {
 	struct pci_sys_data *sys = NULL;
 	int ret;
@@ -493,7 +493,7 @@ static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 	}
 }
 
-void __init pci_common_init(struct hw_pci *hw)
+void pci_common_init(struct hw_pci *hw)
 {
 	struct pci_sys_data *sys;
 	LIST_HEAD(head);
-- 
1.8.1

