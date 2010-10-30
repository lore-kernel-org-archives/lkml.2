Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0J3TqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:46:17 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10226 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0J3TqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:46:16 -0400
Date: Sat, 30 Oct 2010 21:35:58 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Stephane Eranian <eranian@hpl.hp.com>,
        David Mosberger-Tang <davidm@hpl.hp.com>, linux-ia64@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] IA64 perfmon: Change vmalloc to vzalloc and drop memset.
Message-ID: <alpine.LNX.2.00.1010302131050.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

vzalloc() nicely zeroes memory for us, so we don't have to do a vmalloc() 
and then manually memset() the returned memory when all we want is for it 
to be zero. Patch changes this for pfm_rvmalloc().


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
Untested patch since I have neither the hardware nor tools to even compile 
this.

 perfmon.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 39e534f..3aee09d 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -829,10 +829,9 @@ pfm_rvmalloc(unsigned long size)
 	unsigned long addr;
 
 	size = PAGE_ALIGN(size);
-	mem  = vmalloc(size);
+	mem  = vzalloc(size);
 	if (mem) {
 		//printk("perfmon: CPU%d pfm_rvmalloc(%ld)=%p\n", smp_processor_id(), size, mem);
-		memset(mem, 0, size);
 		addr = (unsigned long)mem;
 		while (size > 0) {
 			pfm_reserve_page(addr);

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

