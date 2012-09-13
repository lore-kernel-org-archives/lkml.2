Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2IMCQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 22:16:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46927 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2IMCQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 22:16:05 -0400
Date: Wed, 12 Sep 2012 19:16:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] memory-hotplug: don't replace lowmem pages with
 highmem
In-Reply-To: <1347414231-31451-2-git-send-email-minchan@kernel.org>
Message-ID: <alpine.DEB.2.00.1209121915420.22590@chino.kir.corp.google.com>
References: <1347414231-31451-1-git-send-email-minchan@kernel.org> <1347414231-31451-2-git-send-email-minchan@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Minchan Kim wrote:

> [1] reporeted that lowmem pages could be replaced by
> highmem pages during migration of CMA and fixed.
> 
> Quote from [1]'s description
> "
>     The filesystem layer expects pages in the block device's mapping to not
>     be in highmem (the mapping's gfp mask is set in bdget()), but CMA can
>     currently replace lowmem pages with highmem pages, leading to crashes in
>     filesystem code such as the one below:
> 
>       Unable to handle kernel NULL pointer dereference at virtual address 00000400
>       pgd = c0c98000
>       [00000400] *pgd=00c91831, *pte=00000000, *ppte=00000000
>       Internal error: Oops: 817 [#1] PREEMPT SMP ARM
>       CPU: 0    Not tainted  (3.5.0-rc5+ #80)
>       PC is at __memzero+0x24/0x80
>       ...
>       Process fsstress (pid: 323, stack limit = 0xc0cbc2f0)
>       Backtrace:
>       [<c010e3f0>] (ext4_getblk+0x0/0x180) from [<c010e58c>] (ext4_bread+0x1c/0x98)
>       [<c010e570>] (ext4_bread+0x0/0x98) from [<c0117944>] (ext4_mkdir+0x160/0x3bc)
>        r4:c15337f0
>       [<c01177e4>] (ext4_mkdir+0x0/0x3bc) from [<c00c29e0>] (vfs_mkdir+0x8c/0x98)
>       [<c00c2954>] (vfs_mkdir+0x0/0x98) from [<c00c2a60>] (sys_mkdirat+0x74/0xac)
>        r6:00000000 r5:c152eb40 r4:000001ff r3:c14b43f0
>       [<c00c29ec>] (sys_mkdirat+0x0/0xac) from [<c00c2ab8>] (sys_mkdir+0x20/0x24)
>        r6:beccdcf0 r5:00074000 r4:beccdbbc
>       [<c00c2a98>] (sys_mkdir+0x0/0x24) from [<c000e3c0>] (ret_fast_syscall+0x0/0x30)
> "
> 
> Memory-hotplug has same problem with CMA so [1]'s fix could be applied
> with memory-hotplug, too.
> 
> Fix it by reusing.
> 
> [1] 6a6dccba2, mm: cma: don't replace lowmem pages with highmem
> 
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
