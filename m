Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab2AHCmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 21:42:18 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:51112 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2AHCmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 21:42:17 -0500
Date: Sat, 7 Jan 2012 21:40:29 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Compile errors on 32-bit build due to
 d4bbf7e7759afc172e2bfbc5c416324590049cdd
Message-ID: <20120108024029.GA17214@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F090286.0051,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tejun

Your patch titled " Merge branch 'master' into x86/memblock" breaks compilation
under 32-bit with CONFIG_XEN=y.

/home/konrad/linux-linus/arch/x86/xen/mmu.c: In function ‘xen_setup_kernel_pagetable’:
/home/konrad/linux-linus/arch/x86/xen/mmu.c:1855: error: expected ‘;’ before ‘)’ token
/home/konrad/linux-linus/arch/x86/xen/mmu.c:1855: error: expected statement before ‘)’ token

Looking at merge it looks like you added an extra ')'?

This patch below fixes it, which I was thinking to attach it to my tree that I will
send on Monday to Linus.

>From 18ae9edebde83ef358e997e319868d664fb2ddb8 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Sat, 7 Jan 2012 21:27:38 -0500
Subject: [PATCH] xen/mmu: Fix compile errors introduced by x86/memblock mismerge.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The git commit d4bbf7e7759afc172e2bfbc5c416324590049cdd
"Merge branch 'master' into x86/memblock" mismerged the 32-bit
section causing:

arch/x86/xen/mmu.c: In function ‘xen_setup_kernel_pagetable’:
arch/x86/xen/mmu.c:1855: error: expected ‘;’ before ‘)’ token
arch/x86/xen/mmu.c:1855: error: expected statement before ‘)’ token

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f4bf8aa..58a0e46 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1852,7 +1852,7 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 	xen_write_cr3(__pa(initial_page_table));
 
 	memblock_reserve(__pa(xen_start_info->pt_base),
-			 xen_start_info->nr_pt_frames * PAGE_SIZE));
+			 xen_start_info->nr_pt_frames * PAGE_SIZE);
 
 	return initial_page_table;
 }
-- 
1.7.7.3

