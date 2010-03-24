Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0CXLWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:22:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:45853 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab0CXLWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:22:14 -0400
Date: Wed, 24 Mar 2010 11:21:43 GMT
From: tip-bot for Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, jkosina@suse.cz,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       jkosina@suse.cz, mingo@elte.hu
In-Reply-To: <alpine.LNX.2.00.1003220931360.18642@pobox.suse.cz>
References: <alpine.LNX.2.00.1003220931360.18642@pobox.suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] x86: Remove excessive early_res debug output
Message-ID: <tip-0ebcba91fad1fd542c9665f3514a8a37b46c6e26@git.kernel.org>
Git-Commit-ID: 0ebcba91fad1fd542c9665f3514a8a37b46c6e26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Mar 2010 11:21:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ebcba91fad1fd542c9665f3514a8a37b46c6e26
Gitweb:     http://git.kernel.org/tip/0ebcba91fad1fd542c9665f3514a8a37b46c6e26
Author:     Jiri Kosina <jkosina@suse.cz>
AuthorDate: Mon, 22 Mar 2010 09:32:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Mar 2010 12:11:09 +0100

x86: Remove excessive early_res debug output

Commit 08677214e318297 ("x86: Make 64 bit use early_res instead
of bootmem  before slab") introduced early_res replacement for
bootmem, but left code  in __free_pages_memory() which dumps all
the ranges that are beeing freed,  without any additional
information, causing some noise in dmesg during  bootup.

Just remove printing of the ranges, that doesn't provide
anything useful  anyway.

While at it, remove other commented-out KERN_DEBUG messages in
the NO_BOOTMEM code as well.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <alpine.LNX.2.00.1003220931360.18642@pobox.suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/bootmem.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index d7c791e..9b13446 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -180,19 +180,12 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 	end_aligned = end & ~(BITS_PER_LONG - 1);
 
 	if (end_aligned <= start_aligned) {
-#if 1
-		printk(KERN_DEBUG " %lx - %lx\n", start, end);
-#endif
 		for (i = start; i < end; i++)
 			__free_pages_bootmem(pfn_to_page(i), 0);
 
 		return;
 	}
 
-#if 1
-	printk(KERN_DEBUG " %lx %lx - %lx %lx\n",
-		 start, start_aligned, end_aligned, end);
-#endif
 	for (i = start; i < start_aligned; i++)
 		__free_pages_bootmem(pfn_to_page(i), 0);
 
@@ -428,9 +421,6 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 {
 #ifdef CONFIG_NO_BOOTMEM
 	free_early(physaddr, physaddr + size);
-#if 0
-	printk(KERN_DEBUG "free %lx %lx\n", physaddr, size);
-#endif
 #else
 	unsigned long start, end;
 
@@ -456,9 +446,6 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 #ifdef CONFIG_NO_BOOTMEM
 	free_early(addr, addr + size);
-#if 0
-	printk(KERN_DEBUG "free %lx %lx\n", addr, size);
-#endif
 #else
 	unsigned long start, end;
 
