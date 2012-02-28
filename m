Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966069Ab2B1Suj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:50:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54624 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966018Ab2B1Sue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:50:34 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH trivial next 5/9] powerpc: Use vsprintf extention %pf with builtin_return_address
Date: Tue, 28 Feb 2012 10:49:34 -0800
Message-Id: <2dbc648307582b19ab17f899936ab6d0ca456978.1330454853.git.joe@perches.com>
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
 arch/powerpc/mm/pgtable_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 51f8795..0907f92 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -207,7 +207,7 @@ __ioremap_caller(phys_addr_t addr, unsigned long size, unsigned long flags,
 	 */
 	if (mem_init_done && (p < virt_to_phys(high_memory)) &&
 	    !(__allow_ioremap_reserved && memblock_is_region_reserved(p, size))) {
-		printk("__ioremap(): phys addr 0x%llx is RAM lr %p\n",
+		printk("__ioremap(): phys addr 0x%llx is RAM lr %pf\n",
 		       (unsigned long long)p, __builtin_return_address(0));
 		return NULL;
 	}
-- 
1.7.8.111.gad25c.dirty

