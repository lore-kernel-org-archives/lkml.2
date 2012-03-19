Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161797Ab2CSF4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:56:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30961 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031249Ab2CSFsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 46/47] x86, PCI: Add arch version pci_root_rescan()
Date: Sun, 18 Mar 2012 22:46:35 -0700
Message-Id: <1332135996-13860-47-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F66C8AC.0100,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will call acpi version pci_root_rescan and legacy pci_root_rescan.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/common.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 2ebdc231..0ec860f 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/pci-acpi.h>
 
 #include <asm/acpi.h>
 #include <asm/segment.h>
@@ -661,6 +662,12 @@ struct pci_bus * __devinit pci_scan_bus_with_sysdata(int busno)
 	return pci_scan_bus_on_node(busno, &pci_root_ops, -1);
 }
 
+void arch_pci_root_rescan(void)
+{
+	acpi_pci_root_rescan();
+	pcibios_root_rescan();
+}
+
 /*
  * NUMA info for PCI busses
  *
-- 
1.7.7

