Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab2CADHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:07:13 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:32260 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab2CADCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:02:10 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/36] x86, PCI: add print all root info for nocrs path
Date: Wed, 29 Feb 2012 19:00:13 -0800
Message-Id: <1330570837-26638-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
References: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F4EE681.002C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/amd_bus.c  |    2 +-
 arch/x86/pci/bus_numa.c |    8 ++++++++
 arch/x86/pci/bus_numa.h |    1 +
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 0b6abbe..5f30a98 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -291,7 +291,7 @@ static int __init early_fill_mp_bus_info(void)
 		}
 	}
 
-	print_pci_root_info(info, "bus:", true);
+	print_all_pci_root_info("ht link", true);
 
 	return 0;
 }
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index 7251011..772949f 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -94,6 +94,14 @@ void print_pci_root_info(struct pci_root_info *info, char *name, bool nodelink)
 				 &root_res->res);
 }
 
+void print_all_pci_root_info(char *name, bool nodelink)
+{
+	struct pci_root_info *info;
+
+	list_for_each_entry(info, &pci_root_infos, list)
+		print_pci_root_info(info, name, nodelink);
+}
+
 void __devinit update_res(struct pci_root_info *info, resource_size_t start,
 			  resource_size_t end, unsigned long flags, int merge)
 {
diff --git a/arch/x86/pci/bus_numa.h b/arch/x86/pci/bus_numa.h
index d19ac93..deada6a 100644
--- a/arch/x86/pci/bus_numa.h
+++ b/arch/x86/pci/bus_numa.h
@@ -23,6 +23,7 @@ extern struct list_head pci_root_infos;
 struct pci_root_info *alloc_pci_root_info(int bus_min, int bus_max,
 						int node, int link);
 void print_pci_root_info(struct pci_root_info *info, char *name, bool nodelink);
+void print_all_pci_root_info(char *name, bool nodelink);
 extern void update_res(struct pci_root_info *info, resource_size_t start,
 		      resource_size_t end, unsigned long flags, int merge);
 #endif
-- 
1.7.7

