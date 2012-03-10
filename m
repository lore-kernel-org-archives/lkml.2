Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220Ab2CJHDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:03:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39483 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab2CJHDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:03:23 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 34/37] x86, PCI: Add arch version pci_root_rescan()
Date: Fri,  9 Mar 2012 23:00:34 -0800
Message-Id: <1331362837-10740-35-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F5AFCB8.001B,ss=1,re=0.000,fgs=0
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

