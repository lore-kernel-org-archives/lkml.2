Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2IZBLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 21:11:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39877 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IZBLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 21:11:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50625633.6020808@jp.fujitsu.com>
Date: Wed, 26 Sep 2012 10:11:15 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <lenb@kernel.org>, <tglx@linutronix.de>, <mingo@kernel.org>,
        <hpa@zytor.com>
Subject: [PATCH] x86: use the correct macros
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes to use the correct macros. 

CC: Len Brown <lenb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>
CC: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 drivers/acpi/numa.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-3.6-rc5/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-3.6-rc5.orig/arch/x86/kernel/acpi/boot.c	2012-09-13 15:44:30.000000000 +0900
+++ linux-3.6-rc5/arch/x86/kernel/acpi/boot.c	2012-09-13 15:46:31.743850426 +0900
@@ -601,7 +601,7 @@ static void __cpuinit acpi_map_cpu2node(
 	int nid;
 
 	nid = acpi_get_node(handle);
-	if (nid == -1 || !node_online(nid))
+	if (nid == NUMA_NO_NODE || !node_online(nid))
 		return;
 	set_apicid_to_node(physid, nid);
 	numa_set_node(cpu, nid);
Index: linux-3.6-rc5/drivers/acpi/numa.c
===================================================================
--- linux-3.6-rc5.orig/drivers/acpi/numa.c	2012-09-13 15:44:59.000000000 +0900
+++ linux-3.6-rc5/drivers/acpi/numa.c	2012-09-13 15:46:03.079850552 +0900
@@ -327,12 +327,12 @@ int acpi_get_pxm(acpi_handle h)
 			return pxm;
 		status = acpi_get_parent(handle, &phandle);
 	} while (ACPI_SUCCESS(status));
-	return -1;
+	return PXM_INVAL;
 }
 
 int acpi_get_node(acpi_handle *handle)
 {
-	int pxm, node = -1;
+	int pxm, node = NUMA_NO_NODE;
 
 	pxm = acpi_get_pxm(handle);
 	if (pxm >= 0 && pxm < MAX_PXM_DOMAINS)

