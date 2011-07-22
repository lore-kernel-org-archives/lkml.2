Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1GVGLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:11:00 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:61127 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1GVGK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:10:59 -0400
Date: Fri, 22 Jul 2011 08:10:54 +0200
From: Tejun Heo <tj@kernel.org>
To: Shreshtha <shreshthakumar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel Oops on enabling CONFIG_LOCK_STAT
Message-ID: <20110722061054.GA2622@htj.dyndns.org>
References: <CAKWOLpKFe=rjms5=cvEMJSbiHE0+j+3wK-bGRJWpP1QCJ63Sow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKWOLpKFe=rjms5=cvEMJSbiHE0+j+3wK-bGRJWpP1QCJ63Sow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Andrew.  Thanks for forwarding. :)

Hi,

On Tue, Jul 19, 2011 at 06:59:36PM +0530, Shreshtha wrote:
> After enabling CONFIG_LOCK_STAT, kernel Oops with following -

How reproducible is the problem?  Can you please attach .config?

> <4>WARNING: at /home/kernel/mm/percpu-vm.c:181 pcpu_unmap_pages+0x44/0x10c()
> <d>Modules linked in:
> Backtrace:
> [<c01a4e0c>] (dump_backtrace+0x0/0xf8) from [<c01a4f38>] (dump_stack+0x18/0x1c)
>  r7:00000000 r6:c028f6e0 r5:c0848bd2 r4:000000b5
> [<c01a4f20>] (dump_stack+0x0/0x1c) from [<c01e6848>]
> (warn_slowpath_common+0x54/0x6c)
> [<c01e67f4>] (warn_slowpath_common+0x0/0x6c) from [<c01e6884>]
> (warn_slowpath_null+0x24/0x2c)
>  r9:df801fa0 r8:c1a27180 r7:00000000 r6:00000001 r5:00000167
> r4:00000167
> [<c01e6860>] (warn_slowpath_null+0x0/0x2c) from [<c028f6e0>]
> (pcpu_unmap_pages+0x44/0x10c)
> [<c028f69c>] (pcpu_unmap_pages+0x0/0x10c) from [<c0290778>]
> (pcpu_populate_chunk+0x250/0x314)
> [<c0290528>] (pcpu_populate_chunk+0x0/0x314) from [<c0290a38>]
> (pcpu_alloc+0x1fc/0x2f0)
> [<c029083c>] (pcpu_alloc+0x0/0x2f0) from [<c0290b58>] (__alloc_percpu+0x14/0x18)
> [<c0290b44>] (__alloc_percpu+0x0/0x18) from [<c03c6468>]
> (__percpu_counter_init+0x48/0xa4)
> [<c03c6420>] (__percpu_counter_init+0x0/0xa4) from [<c00192c0>]
> (mmap_init+0x28/0x34)
>  r7:c0913d7c r6:c0035074 r5:c0977ca0 r4:00000000
> [<c0019298>] (mmap_init+0x0/0x34) from [<c0013860>] (proc_caches_init+0xc8/0xf0)
> [<c0013798>] (proc_caches_init+0x0/0xf0) from [<c0008f58>]
> (start_kernel+0x204/0x288)
>  r5:c0974240 r4:c0f2b54c
> [<c0008d54>] (start_kernel+0x0/0x288) from [<00008080>] (0x8080)
>  r5:c0975284 r4:10c53c7d

Hrmm... so it's pcpu_populate_chunk() failure path.  Can you please
attach full kernel log?  Attaching full kernel log and including a bit
of hardware details is generally a good idea when reporting a bug.

It's most likely there's a bug in the code which rolls back from
partial allocation after encountering alloc failure in the middle.
I'll take a deeper look there and report what I find.

Thank you.

-- 
tejun
