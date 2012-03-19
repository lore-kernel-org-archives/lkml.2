Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2CSFoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:44:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26855 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab2CSFn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:43:57 -0400
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
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v11 01/30] x86, PCI: Add print all root info for not using _CRS path
Date: Sun, 18 Mar 2012 22:42:32 -0700
Message-Id: <1332135781-13695-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F66C792.004C,ss=1,re=0.000,fgs=0
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

