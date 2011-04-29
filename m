Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab1D2P3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:29:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344Ab1D2P3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=NP0tNQrN3j2+hWVKt4TIW97jaVsMuFgvCmN7FYkJl7nEac4MEjcXfOexhEuibQL4IT
         Xko8/vVfU7eRdra4FTVDm750Nu+bEZxyKRWjgi/GwFS1ZFz+P9SWHADVCBGC8RV0bYEt
         yUFamTDVIH2R/zptKWC4E/h0+Ij0q4JAR6DhA=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/25] x86, NUMA: make srat.c 32bit safe
Date: Fri, 29 Apr 2011 17:28:29 +0200
Message-Id: <1304090924-8197-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make srat.c 32bit safe by removing the assumption that unsigned long
is 64bit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/srat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 9994d2c..81dbfde 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -138,7 +138,7 @@ static inline int save_add_info(void) {return 0;}
 void __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 {
-	unsigned long start, end;
+	u64 start, end;
 	int node, pxm;
 
 	if (srat_disabled())
@@ -167,7 +167,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		return;
 	}
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
+	printk(KERN_INFO "SRAT: Node %u PXM %u %Lx-%Lx\n", node, pxm,
 	       start, end);
 }
 
-- 
1.7.1

