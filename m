Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2KIGV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 01:21:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51903 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2KIGVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 01:21:54 -0500
Date: Thu, 8 Nov 2012 22:21:50 -0800
From: Michel Lespinasse <walken@google.com>
To: kbuild test robot <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [next:akpm 136/313] mm/mmap.c:1878:6: error: 'mm' undeclared
Message-ID: <20121109062150.GA7022@google.com>
References: <509c9bb9.+RUyEEi+hJKJghoL%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509c9bb9.+RUyEEi+hJKJghoL%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 01:59:21PM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
> head:   6703d59701f7592c897b975de3952ba6bbb98b83
> commit: db877c95d306d688818542d49e9b63eb7a3b0894 [136/313] mm: augment vma rbtree with rb_subtree_gap
> config: make ARCH=ia64 alldefconfig
> 
> All error/warnings:
> 
> mm/mmap.c: In function 'expand_upwards':
> mm/mmap.c:1878:6: error: 'mm' undeclared (first use in this function)
> mm/mmap.c:1878:6: note: each undeclared identifier is reported only once for each function it appears in

commit 34550b95185c1ecfa8882664744c14edda385868
Author: Michel Lespinasse <walken@google.com>
Date:   Thu Nov 8 22:14:34 2012 -0800

    fix mm: augment vma rbtree with rb_subtree_gap

diff --git a/mm/mmap.c b/mm/mmap.c
index d12c69eaf23f..0b8f9d83e2e2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2032,7 +2032,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 				if (vma->vm_next)
 					vma_gap_update(vma->vm_next);
 				else
-					mm->highest_vm_end = address;
+					vma->vm_mm->highest_vm_end = address;
 				perf_event_mmap(vma);
 			}
 		}
