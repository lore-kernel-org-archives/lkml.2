Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab0IMEQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 00:16:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30906 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0IMEQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 00:16:42 -0400
Message-ID: <4C8DA517.9000603@kernel.org>
Date: Sun, 12 Sep 2010 21:14:15 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build warnings after merge of the final tree (tip
 treee related)
References: <20100913132721.5a02cfbc.sfr@canb.auug.org.au>
In-Reply-To: <20100913132721.5a02cfbc.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2010 08:27 PM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the scsi-post-merge tree, today's linux-next build (powerpc
> allnoconfig, i386 defconfig and others) produced these warnings (I build
> with CONFIG_DEBUG_SECTION_MISMATCH=y):
> 
> WARNING: mm/built-in.o(.text+0x25910): Section mismatch in reference from the function memblock_find_in_range() to the function .init.text:memblock_find_base()
> The function memblock_find_in_range() references
> the function __init memblock_find_base().
> This is often because memblock_find_in_range lacks a __init 
> annotation or the annotation of memblock_find_base is wrong.

please check it, and it should get into core/memblock branch.

Thanks

Yinghai

[PATCH] memblock: Fix section mismatch warning

for arches that use memblock other than x86

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yinghai Lu <Yinghai@kernel.org>

---
 mm/memblock.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -125,8 +125,8 @@ static phys_addr_t __init memblock_find_
 	return MEMBLOCK_ERROR;
 }
 
-static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align,
-					phys_addr_t start, phys_addr_t end)
+static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
+			phys_addr_t align, phys_addr_t start, phys_addr_t end)
 {
 	long i;
 
@@ -439,12 +439,12 @@ long __init_memblock memblock_remove(phy
 	return __memblock_remove(&memblock.memory, base, size);
 }
 
-long __init memblock_free(phys_addr_t base, phys_addr_t size)
+long __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 {
 	return __memblock_remove(&memblock.reserved, base, size);
 }
 
-long __init memblock_reserve(phys_addr_t base, phys_addr_t size)
+long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 {
 	struct memblock_type *_rgn = &memblock.reserved;
 
@@ -693,7 +693,7 @@ int __init_memblock memblock_is_region_r
 }
 
 
-void __init memblock_set_current_limit(phys_addr_t limit)
+void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 {
 	memblock.current_limit = limit;
 }
