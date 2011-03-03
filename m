Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab1CCBVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:21:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38018 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab1CCBVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:21:16 -0500
Message-ID: <4D6EECE8.80500@kernel.org>
Date: Wed, 02 Mar 2011 17:20:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, numa: move bootnode definition into srat_64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D6EECFA.001F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



only one user there for hot memory add.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 12e0e7d..416d865 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -183,8 +183,6 @@ static inline void disable_acpi(void) { }
 
 #define ARCH_HAS_POWER_INIT	1
 
-struct bootnode;
-
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
 extern int x86_acpi_numa_init(void);
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index e264ae5..1263bf4 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -11,7 +11,6 @@ struct amd_nb_bus_dev_range {
 
 extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
-struct bootnode;
 
 extern int early_is_amd_nb(u32 value);
 extern int amd_cache_northbridges(void);
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 344eb17..52f9b12 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -3,11 +3,6 @@
 
 #include <linux/nodemask.h>
 
-struct bootnode {
-	u64 start;
-	u64 end;
-};
-
 #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
 extern int numa_off;
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 8e9d339..7e5d0e9 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -26,6 +26,11 @@
 
 int acpi_numa __initdata;
 
+struct bootnode {
+	u64 start;
+	u64 end;
+};
+
 static struct bootnode nodes_add[MAX_NUMNODES];
 
 static __init int setup_node(int pxm)
