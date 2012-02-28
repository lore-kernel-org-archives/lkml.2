Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030187Ab2B1St7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:49:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41565 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965988Ab2B1St5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:49:57 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH trivial next 1/9] sparc: Use vsprintf extention %pf with builtin_return_address
Date: Tue, 28 Feb 2012 10:49:30 -0800
Message-Id: <5788cc9f8e5e9b3d8d2d7b78b2d1fb71325df773.1330454853.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the function name not the address when possible.

builtin_return_address() gives an address.  When building
a kernel with CONFIG_KALLSYMS, emit the actual function
name not the address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/sparc/kernel/ds.c |    2 +-
 arch/sparc/mm/srmmu.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 381edcd..e65b9fc 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -868,7 +868,7 @@ void ldom_power_off(void)
 
 static void ds_conn_reset(struct ds_info *dp)
 {
-	printk(KERN_ERR "ds-%llu: ds_conn_reset() from %p\n",
+	printk(KERN_ERR "ds-%llu: ds_conn_reset() from %pf\n",
 	       dp->id, __builtin_return_address(0));
 }
 
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index cbef74e..f37fbb2 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -705,7 +705,7 @@ static void swift_update_mmu_cache(struct vm_area_struct * vma, unsigned long ad
 		val = srmmu_hwprobe(address);
 		if (val != 0 && pte_val(*ptep) != val) {
 			printk("swift_update_mmu_cache: "
-			    "addr %lx put %08x probed %08x from %p\n",
+			    "addr %lx put %08x probed %08x from %pf\n",
 			    address, pte_val(*ptep), val,
 			    __builtin_return_address(0));
 			srmmu_flush_whole_tlb();
-- 
1.7.8.111.gad25c.dirty

