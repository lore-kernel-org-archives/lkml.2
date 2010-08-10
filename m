Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0HJJLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:11:19 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57973 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab0HJJLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:11:10 -0400
Date: Tue, 10 Aug 2010 11:11:08 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 1/4] arch/frv: Removing dead RAMKERNEL config option
Message-ID: <c80d5af9b2921e9d8cc6d8d7b9a54a882f1c919e.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_RAMKERNEL doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/frv/mm/init.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index ed64588..73586ad 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -170,23 +170,6 @@ void __init mem_init(void)
  */
 void free_initmem(void)
 {
-#if defined(CONFIG_RAMKERNEL) && !defined(CONFIG_PROTECT_KERNEL)
-	unsigned long start, end, addr;
-
-	start = PAGE_ALIGN((unsigned long) &__init_begin);	/* round up */
-	end   = ((unsigned long) &__init_end) & PAGE_MASK;	/* round down */
-
-	/* next to check that the page we free is not a partial page */
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-
-	printk("Freeing unused kernel memory: %ldKiB freed (0x%lx - 0x%lx)\n",
-	       (end - start) >> 10, start, end);
-#endif
 } /* end free_initmem() */
 
 /*****************************************************************************/
-- 
1.7.0.4

