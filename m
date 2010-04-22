Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab0DVEa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 00:30:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:45418 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab0DVEa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 00:30:56 -0400
Date: Thu, 22 Apr 2010 12:29:49 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] a WARNING and a BUG from kernel/lockdep.c
Message-ID: <20100422042949.GD8938@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <4BCFC31B.5000706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4BCFC31B.5000706@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Apr 2010 04:29:50.0947 (UTC) FILETIME=[72D6B330:01CAE1D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 11:31:39AM +0800, Li Zefan wrote:
> Maybe this is caused by commit bd6d29c25bb1a24a4c160ec5de43e0004e01f72b
> ("lockstat: Make lockstat counting per cpu")

Frederic has put patches for it:
http://lkml.org/lkml/2010/4/15/391

Thanks,
Yong

> 
> ?
> 
> 
> ============================
> 
> 
> ------------[ cut here ]------------                 
> WARNING: at kernel/lockdep.c:2301 trace_hardirqs_on_caller+0x210/0x220()
> Hardware name: Aspire SA85                                              
> Modules linked in: fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath linear ppdev pcspkr parport_pc parport r8169 mii ata_generic pata_acpi sata_sis pata_sis [last unloaded: scsi_wait_scan]
> Pid: 2452, comm: java Not tainted 2.6.34-rc5-tip+ #6
> Call Trace:
>  [<c083c276>] ? printk+0x1d/0x1f
>  [<c044c1e2>] warn_slowpath_common+0x72/0xa0
>  [<c0482500>] ? trace_hardirqs_on_caller+0x210/0x220
>  [<c0482500>] ? trace_hardirqs_on_caller+0x210/0x220
>  [<c042a52c>] ? __bad_area_nosemaphore+0x2c/0x130
>  [<c044c22a>] warn_slowpath_null+0x1a/0x20
>  [<c0482500>] trace_hardirqs_on_caller+0x210/0x220
>  [<c048251b>] trace_hardirqs_on+0xb/0x10
>  [<c042a52c>] __bad_area_nosemaphore+0x2c/0x130
>  [<c042a67e>] ? __bad_area+0x2e/0x50
>  [<c042a68f>] __bad_area+0x3f/0x50
>  [<c0842bd0>] ? do_page_fault+0x0/0x500
>  [<c042a6d7>] bad_area_access_error+0x17/0x20
>  [<c0842df9>] do_page_fault+0x229/0x500
>  [<c084074f>] ? error_code+0x67/0x70
>  [<c047e854>] ? trace_hardirqs_off_caller+0x74/0x130
>  [<c0842bd0>] ? do_page_fault+0x0/0x500
>  [<c0840753>] error_code+0x6b/0x70
>  [<c0842bd0>] ? do_page_fault+0x0/0x500
> ---[ end trace 93d0036abe3ab514 ]---
> BUG: using smp_processor_id() in preemptible [00000000] code: java/2452
> caller is trace_hardirqs_on_caller+0x18d/0x220
> Pid: 2452, comm: java Tainted: G        W  2.6.34-rc5-tip+ #6
> Call Trace:
>  [<c083c276>] ? printk+0x1d/0x1f
>  [<c0627160>] debug_smp_processor_id+0xc0/0xd0
>  [<c042a52c>] ? __bad_area_nosemaphore+0x2c/0x130
>  [<c048247d>] trace_hardirqs_on_caller+0x18d/0x220
>  [<c048251b>] trace_hardirqs_on+0xb/0x10
>  [<c042a52c>] __bad_area_nosemaphore+0x2c/0x130
>  [<c042a67e>] ? __bad_area+0x2e/0x50
>  [<c042a68f>] __bad_area+0x3f/0x50
>  [<c0842bd0>] ? do_page_fault+0x0/0x500
>  [<c042a6d7>] bad_area_access_error+0x17/0x20
>  [<c0842df9>] do_page_fault+0x229/0x500
>  [<c084074f>] ? error_code+0x67/0x70
>  [<c047e854>] ? trace_hardirqs_off_caller+0x74/0x130
>  [<c0842bd0>] ? do_page_fault+0x0/0x500
>  [<c0840753>] error_code+0x6b/0x70
>  [<c0842bd0>] ? do_page_fault+0x0/0x500
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
