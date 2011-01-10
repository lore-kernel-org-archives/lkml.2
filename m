Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1AJSQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:16:18 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38500 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1AJSQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:16:17 -0500
Message-ID: <4D2B4CEE.2050905@austin.ibm.com>
Date: Mon, 10 Jan 2011 12:16:14 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
Subject: [PATCH 4/4] Define memory_block_size_bytes for x86_64 with CONFIG_X86_UV
 defined
References: <4D2B4B38.80102@austin.ibm.com>
In-Reply-To: <4D2B4B38.80102@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a version of memory_block_size_bytes for x86_64 when CONFIG_X86_UV is
set.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

---
 arch/x86/mm/init_64.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c	2011-01-05 10:08:13.000000000 -0600
+++ linux-2.6/arch/x86/mm/init_64.c	2011-01-05 10:17:51.000000000 -0600
@@ -51,6 +51,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <asm/uv/uv.h>
 
 static int __init parse_direct_gbpages_off(char *arg)
 {
@@ -908,6 +909,19 @@ const char *arch_vma_name(struct vm_area
 	return NULL;
 }
 
+#ifdef CONFIG_X86_UV
+#define MIN_MEMORY_BLOCK_SIZE   (1 << SECTION_SIZE_BITS)
+
+unsigned long memory_block_size_bytes(void)
+{
+	if (is_uv_system()) {
+		printk(KERN_INFO "UV: memory block size 2GB\n");
+		return 2UL * 1024 * 1024 * 1024;
+	}
+	return MIN_MEMORY_BLOCK_SIZE;
+}
+#endif
+
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.

