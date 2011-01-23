Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab1AWNiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:38:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42549 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1AWNh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:37:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=QaBIogaGpOJ1yv0DG5OVsGgz2carzMnGJ3akrAjugr6HZ8uX72hRIgxHQTgO1Z4Gx8
         /rdYykm1J4sOHctCKuYn5ToaxQwVVBkWn11cA1bXhHx+zSrY1O3NqzON/KsyWM97db6v
         g91/pdPqrUvel1lwI/hCJIrofyO13kMTtI3dY=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, penberg@kernel.org, shaohui.zheng@intel.com,
        rientjes@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/16] x86: Drop x86_32 MAX_APICID
Date: Sun, 23 Jan 2011 14:37:28 +0100
Message-Id: <1295789862-25482-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295789862-25482-1-git-send-email-tj@kernel.org>
References: <1295789862-25482-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 56d91f13 (x86, acpi: Add MAX_LOCAL_APIC for 32bit) added
MAX_LOCAL_APIC for x86_32 but didn't replace MAX_APICID users with it.
Convert MAX_APICID users to MAX_LOCAL_APIC and drop MAX_APICID.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
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
index c255980..d68bab5 100644
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
-- 
1.7.1

