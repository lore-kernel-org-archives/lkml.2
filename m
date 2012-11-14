Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945969Ab2KNXJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:09:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2KNXJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:09:21 -0500
Date: Wed, 14 Nov 2012 15:09:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, walken@google.com, riel@redhat.com
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-Id: <20121114150919.19c1633a.akpm@linux-foundation.org>
In-Reply-To: <20121114.173059.2152995770988231211.davem@davemloft.net>
References: <20121109150957.4f274fa7b3a75c9baaa1b7ff@canb.auug.org.au>
	<20121114141847.fab752c2.akpm@linux-foundation.org>
	<20121114.173059.2152995770988231211.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 17:30:59 -0500 (EST)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 14 Nov 2012 14:18:47 -0800
> 
> > s/colour/color/
> 
> The whole file uses the COLOUR spelling in it's macros, for
> consistency I see no reason not to use the same spelling
> for local variables.
> 
> Else, fix the whole file instead of leaving an inconsistent
> mess around.

Sure, but which way do you want it?

Current mainline:

akpm:/usr/src/linux-3.7-rc5> grep -i colour arch/sparc/kernel/*.c arch/sparc/mm/*.c
arch/sparc/kernel/sys_sparc_32.c:#define COLOUR_ALIGN(addr)      (((addr)+SHMLBA-1)&~(SHMLBA-1))
arch/sparc/kernel/sys_sparc_32.c:               addr = COLOUR_ALIGN(addr);
arch/sparc/kernel/sys_sparc_32.c:                       addr = COLOUR_ALIGN(addr);
arch/sparc/kernel/sys_sparc_64.c:static inline unsigned long COLOUR_ALIGN(unsigned long addr,
arch/sparc/kernel/sys_sparc_64.c:static inline unsigned long COLOUR_ALIGN_DOWN(unsigned long addr,
arch/sparc/kernel/sys_sparc_64.c:                       addr = COLOUR_ALIGN(addr, pgoff);
arch/sparc/kernel/sys_sparc_64.c:               addr = COLOUR_ALIGN(addr, pgoff);
arch/sparc/kernel/sys_sparc_64.c:                       addr = COLOUR_ALIGN(addr, pgoff);
arch/sparc/kernel/sys_sparc_64.c:                       addr = COLOUR_ALIGN(addr, pgoff);
arch/sparc/kernel/sys_sparc_64.c:               unsigned long base = COLOUR_ALIGN_DOWN(addr-len, pgoff);
arch/sparc/kernel/sys_sparc_64.c:               addr = COLOUR_ALIGN_DOWN(addr, pgoff);
arch/sparc/kernel/sys_sparc_64.c:                       addr = COLOUR_ALIGN_DOWN(addr, pgoff);


arch/sparc/kernel/sys_sparc_64.c: * 1) For file backed MAP_SHARED mmap()'s we D-cache color align,
arch/sparc/kernel/sys_sparc_64.c:	int do_color_align;
arch/sparc/kernel/sys_sparc_64.c:	do_color_align = 0;
arch/sparc/kernel/sys_sparc_64.c:		do_color_align = 1;
arch/sparc/kernel/sys_sparc_64.c:		if (do_color_align)
arch/sparc/kernel/sys_sparc_64.c:	if (do_color_align)
arch/sparc/kernel/sys_sparc_64.c:		if (do_color_align)
arch/sparc/kernel/sys_sparc_64.c:	int do_color_align;
arch/sparc/kernel/sys_sparc_64.c:	do_color_align = 0;
arch/sparc/kernel/sys_sparc_64.c:		do_color_align = 1;
arch/sparc/kernel/sys_sparc_64.c:		if (do_color_align)
arch/sparc/kernel/sys_sparc_64.c:	if (do_color_align) {
arch/sparc/kernel/sys_sparc_64.c:	if (do_color_align)
arch/sparc/kernel/sys_sparc_64.c:		if (do_color_align)
arch/sparc/mm/hugetlbpage.c: * definition we don't have to worry about any page coloring stuff
arch/sparc/mm/iommu.c:	/* To be coherent on HyperSparc, the page color of DVMA
arch/sparc/mm/iommu.c:		iommu->usemap.num_colors = vac_cache_size >> PAGE_SHIFT;
arch/sparc/mm/iommu.c:		iommu->usemap.num_colors = 1;
arch/sparc/mm/iommu.c:	/* page color = pfn of page */
arch/sparc/mm/iommu.c:	/* page color = physical address */


I suspect that most people expect "color".  And given that this
patchset removes COLOUR_ALIGN_DOWN (and should have removed
arch/sparc/kernel/sys_sparc_32.c:COLOR_ALIGN), we end up with

--- a/arch/sparc/kernel/sys_sparc_64.c~a
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -75,7 +75,7 @@ static inline int invalid_64bit_range(un
  *    the spitfire/niagara VA-hole.
  */
 
-static inline unsigned long COLOUR_ALIGN(unsigned long addr,
+static inline unsigned long COLOR_ALIGN(unsigned long addr,
 					 unsigned long pgoff)
 {
 	unsigned long base = (addr+SHMLBA-1)&~(SHMLBA-1);
@@ -113,7 +113,7 @@ unsigned long arch_get_unmapped_area(str
 
 	if (addr) {
 		if (do_color_align)
-			addr = COLOUR_ALIGN(addr, pgoff);
+			addr = COLOR_ALIGN(addr, pgoff);
 		else
 			addr = PAGE_ALIGN(addr);
 
@@ -176,7 +176,7 @@ arch_get_unmapped_area_topdown(struct fi
 	/* requesting a specific address */
 	if (addr) {
 		if (do_color_align)
-			addr = COLOUR_ALIGN(addr, pgoff);
+			addr = COLOR_ALIGN(addr, pgoff);
 		else
 			addr = PAGE_ALIGN(addr);
 
_

