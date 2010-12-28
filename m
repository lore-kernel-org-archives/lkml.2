Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab0L1LwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 06:52:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38779 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0L1Ls7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 06:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=JGIywBOV1jUfmuHtAH1Q++LIQqOzWdMQQscLZeN3W4taqcBnl6C/gMMct5wIQSSk98
         R41tCorh6JvqT6/uywfWgVs8ik/3h0KCLhwlsTEsDAciA6UjIf1buLy8VZw29SoFdjss
         r58YcrEfm02UWtRxZiQYrmnvzQp8Dpbac3+nU=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/16] x86: Rename x86_32 MAX_APICID to MAX_LOCAL_APIC
Date: Tue, 28 Dec 2010 12:48:35 +0100
Message-Id: <1293536929-31683-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293536929-31683-1-git-send-email-tj@kernel.org>
References: <1293536929-31683-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace x86_32 MAX_APICID in include/asm/mpspec.h with MAX_LOCAL_APIC
in include/asm/apicdef.h to make it consistent with x86_64.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/include/asm/apicdef.h |    1 +
 arch/x86/include/asm/mpspec.h  |    2 --
 arch/x86/kernel/smpboot.c      |    2 +-
 arch/x86/mm/srat_32.c          |    4 ++--
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index a859ca4..47a30ff 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -145,6 +145,7 @@
 
 #ifdef CONFIG_X86_32
 # define MAX_IO_APICS 64
+# define MAX_LOCAL_APIC 256
 #else
 # define MAX_IO_APICS 128
 # define MAX_LOCAL_APIC 32768
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index c82868e..018ffc1 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -32,8 +32,6 @@ extern int mp_bus_id_to_local[MAX_MP_BUSSES];
 extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 #endif
 
-#define MAX_APICID		256
-
 #else /* CONFIG_X86_64: */
 
 #define MAX_MP_BUSSES		256
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4de6a00..0b32f17 100644
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
index a17dffd..e55e748 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -57,7 +57,7 @@ struct node_memory_chunk_s {
 static struct node_memory_chunk_s __initdata node_memory_chunk[MAXCHUNKS];
 
 static int __initdata num_memory_chunks; /* total number of memory chunks */
-static u8 __initdata apicid_to_pxm[MAX_APICID];
+static u8 __initdata apicid_to_pxm[MAX_LOCAL_APIC];
 
 int numa_off __initdata;
 int acpi_numa __initdata;
@@ -254,7 +254,7 @@ int __init get_memcfg_from_srat(void)
 	printk(KERN_DEBUG "Number of memory chunks in system = %d\n",
 			 num_memory_chunks);
 
-	for (i = 0; i < MAX_APICID; i++)
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		apicid_2_node[i] = pxm_to_node(apicid_to_pxm[i]);
 
 	for (j = 0; j < num_memory_chunks; j++){
-- 
1.7.1

