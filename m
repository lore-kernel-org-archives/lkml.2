Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1A1OiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:38:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:59935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab1A1OiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:38:19 -0500
Date: Fri, 28 Jan 2011 14:37:35 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295789862-25482-3-git-send-email-tj@kernel.org>
References: <1295789862-25482-3-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Drop x86_32 MAX_APICID
Message-ID: <tip-b78aa66b1fe4179d28e3f6502dc179773519a1bb@git.kernel.org>
Git-Commit-ID: b78aa66b1fe4179d28e3f6502dc179773519a1bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 14:37:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b78aa66b1fe4179d28e3f6502dc179773519a1bb
Gitweb:     http://git.kernel.org/tip/b78aa66b1fe4179d28e3f6502dc179773519a1bb
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Sun, 23 Jan 2011 14:37:28 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 14:54:04 +0100

x86: Drop x86_32 MAX_APICID

Commit 56d91f13 (x86, acpi: Add MAX_LOCAL_APIC for 32bit) added
MAX_LOCAL_APIC for x86_32 but didn't replace MAX_APICID users
with it. Convert MAX_APICID users to MAX_LOCAL_APIC and drop
MAX_APICID.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <1295789862-25482-3-git-send-email-tj@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mpspec.h |    2 --
 arch/x86/kernel/smpboot.c     |    2 +-
 arch/x86/mm/srat_32.c         |    4 ++--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 0c90dd9..edc2a45 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -33,8 +33,6 @@ extern int mp_bus_id_to_local[MAX_MP_BUSSES];
 extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 #endif
 
-#define MAX_APICID		256
-
 #else /* CONFIG_X86_64: */
 
 #define MAX_MP_BUSSES		256
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ee9203a..53a85ba 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -72,7 +72,7 @@
 #include <asm/i8259.h>
 
 #ifdef CONFIG_X86_32
-u8 apicid_2_node[MAX_APICID];
+u8 apicid_2_node[MAX_LOCAL_APIC];
 #endif
 
 /* State of each CPU */
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index ae96e7b..6027a48 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -57,7 +57,7 @@ struct node_memory_chunk_s {
 static struct node_memory_chunk_s __initdata node_memory_chunk[MAXCHUNKS];
 
 static int __initdata num_memory_chunks; /* total number of memory chunks */
-static u8 __initdata apicid_to_pxm[MAX_APICID];
+static u8 __initdata apicid_to_pxm[MAX_LOCAL_APIC];
 
 int acpi_numa __initdata;
 
@@ -254,7 +254,7 @@ int __init get_memcfg_from_srat(void)
 	printk(KERN_DEBUG "Number of memory chunks in system = %d\n",
 			 num_memory_chunks);
 
-	for (i = 0; i < MAX_APICID; i++)
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		apicid_2_node[i] = pxm_to_node(apicid_to_pxm[i]);
 
 	for (j = 0; j < num_memory_chunks; j++){
