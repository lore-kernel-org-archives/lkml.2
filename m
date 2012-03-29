Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab2C2AJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 20:09:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58637 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab2C2AJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 20:09:03 -0400
Date: Wed, 28 Mar 2012 17:09:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
cc: Sasha Levin <levinsasha928@gmail.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: BUG: sleeping function called from invalid context at
 fs/proc/task_mmu.c:826
In-Reply-To: <20120328181820.GB14224@redhat.com>
Message-ID: <alpine.DEB.2.00.1203281706430.8554@chino.kir.corp.google.com>
References: <20120328181820.GB14224@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012, Dave Jones wrote:

> Just hit this on v3.3-7919-g6658a69
> 
> 	Dave
> 
> BUG: sleeping function called from invalid context at fs/proc/task_mmu.c:826
> in_atomic(): 1, irqs_disabled(): 0, pid: 15123, name: trinity
> INFO: lockdep is turned off.
> Pid: 15123, comm: trinity Not tainted 3.3.0+ #30
> Call Trace:
>  [<ffffffff8109bf75>] __might_sleep+0x145/0x200
>  [<ffffffff8122ee77>] ? pagemap_pte_range+0x67/0x340
>  [<ffffffff8122ef3f>] pagemap_pte_range+0x12f/0x340
>  [<ffffffff811924b9>] walk_page_range+0x389/0x520
>  [<ffffffff8122e9a2>] pagemap_read+0x282/0x350
>  [<ffffffff8122ee10>] ? clear_refs_pte_range+0x180/0x180
>  [<ffffffff8122d340>] ? get_vmalloc_info+0x110/0x110
>  [<ffffffff8122e5c0>] ? pid_numa_maps_open+0x20/0x20
>  [<ffffffff811c3a43>] vfs_read+0xb3/0x180
>  [<ffffffff811c3b5d>] sys_read+0x4d/0x90
>  [<ffffffff816c02a9>] system_call_fastpath+0x16/0x1b
> 

This looks like it was already reported as 
http://marc.info/?l=linux-kernel&m=133289254323384 by Sasha Levin.  We're 
waiting for a patch to push to stable from Naoya Horiguchi.
