Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1H2PH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:07:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:64768 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1H2PHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:07:54 -0400
Date: Mon, 29 Aug 2011 11:07:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Christopher S. Aker" <caker@theshore.net>
Cc: LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0 Xen
 pv guest - BUG: Unable to handle]
Message-ID: <20110829150734.GB24825@dumpdata.com>
References: <9CAEB881-07FE-437C-8A6B-DB7B690CEABE@linode.com>
 <4E5BA49D.5060800@theshore.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5BA49D.5060800@theshore.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E5BAB41.01C4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 10:39:25AM -0400, Christopher S. Aker wrote:
> And another related from 2.6.39:

I just don't get how you are the only person seeing this - and you have
been seeing this from 2.6.32... The dom0 you have - is it printing at least
something when this happens (or before)? Or the Xen hypervisor:
maybe a message about L1 pages not found?

And the dom0 is 2.6.18, right? - Did you update it (I know that the Red Hat guys
have been updating a couple of things on it).

Any chance I can get access to your setup and try to work with somebody
to reproduce this?

> 
> ------------[ cut here ]------------
> kernel BUG at mm/swapfile.c:2527!
> invalid opcode: 0000 [#1] SMP
> last sysfs file: /sys/devices/system/cpu/cpu3/topology/core_id
> Modules linked in:
> 
> Pid: 17680, comm: postgres Tainted: G    B       2.6.39-linode33 #3
> EIP: 0061:[<c01b4b26>] EFLAGS: 00210246 CPU: 0
> EIP is at swap_count_continued+0x176/0x180
> EAX: f57bac57 EBX: eba2c200 ECX: f57ba000 EDX: 00000000
> ESI: ebfd7c20 EDI: 00000080 EBP: 00000c57 ESP: c670fe0c
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
> Process postgres (pid: 17680, ti=c670e000 task=e93415d0 task.ti=c670e000)
> Stack:
>  e9e3a340 00013c57 ee15fc57 00000000 c01b60b1 c0731000 c06982d5 401b4b73
>  ceebc988 e9e3a340 00013c57 00000000 c01b60f7 ceebc988 b7731000 c670ff04
>  c01a7183 4646e045 80000005 e62ce348 28999063 c0103fc5 7f662000 00278ae0
> Call Trace:
>  [<c01b60b1>] ? swap_entry_free+0x121/0x140
>  [<c06982d5>] ? _raw_spin_lock+0x5/0x10
>  [<c01b60f7>] ? free_swap_and_cache+0x27/0xd0
>  [<c01a7183>] ? zap_pte_range+0x1b3/0x480
>  [<c0103fc5>] ? pte_pfn_to_mfn+0xb5/0xd0
>  [<c01a7568>] ? unmap_page_range+0x118/0x1a0
>  [<c0105b17>] ? xen_force_evtchn_callback+0x17/0x30
>  [<c01a771b>] ? unmap_vmas+0x12b/0x1e0
>  [<c01aba01>] ? exit_mmap+0x91/0x140
>  [<c0134b2b>] ? mmput+0x2b/0xc0
>  [<c01386ba>] ? exit_mm+0xfa/0x130
>  [<c0698330>] ? _raw_spin_lock_irq+0x10/0x20
>  [<c013a2b5>] ? do_exit+0x125/0x360
>  [<c0105b17>] ? xen_force_evtchn_callback+0x17/0x30
>  [<c013a52c>] ? do_group_exit+0x3c/0xa0
>  [<c013a5a1>] ? sys_exit_group+0x11/0x20
>  [<c0698631>] ? syscall_call+0x7/0xb
> Code: ff 89 d8 e8 7d ec f6 ff 01 e8 8d 76 00 c6 00 00 ba 01 00 00 00
> eb b2 89 f8 3c 80 0f 94 c0
> e9 b9 fe ff ff 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 66
> 90 53 31 db 83 ec 0c 85 c0 7
> 4 39 89
> EIP: [<c01b4b26>] swap_count_continued+0x176/0x180 SS:ESP 0069:c670fe0c
> ---[ end trace c2dcb41c89b0a9f7 ]---
> 
> Thanks,
> -Chris
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
