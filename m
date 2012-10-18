Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2JRUkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:40:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52510 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab2JRUkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:40:22 -0400
MIME-Version: 1.0
In-Reply-To: <20121018162611.GA11556@jshin-Toonie>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
	<CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
	<alpine.DEB.2.02.1210181444380.2689@kaball.uk.xensource.com>
	<20121018162611.GA11556@jshin-Toonie>
Date: Thu, 18 Oct 2012 13:40:21 -0700
X-Google-Sender-Auth: TZ2BLd0K1ncecG69WnMMYrEjMgI
Message-ID: <CAE9FiQVA-FF80h1nDqd1_PkxJ2U4oLTeB0-ak5FdniaLM8y4RQ@mail.gmail.com>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 9:26 AM, Jacob Shin <jacob.shin@amd.com> wrote:
>
> Hi Yinghai, I just tried it and dom0 died during init_memory_mapping, here
> is the Oops snippet, full logs are attached:
>
> e820: last_pfn = 0x22f000 max_arch_pfn = 0x400000000
> e820: last_pfn = 0xcff00 max_arch_pfn = 0x400000000
> initial memory mapped: [mem 0x00000000-0x022affff]
> Base memory trampoline at [ffff880000096000] 96000 size 24576
> init_memory_mapping: [mem 0x00000000-0x000fffff]
>  [mem 0x00000000-0x000fffff] page 4k
> init_memory_mapping: [mem 0x21fe00000-0x21fe77fff]
>  [mem 0x21fe00000-0x21fe77fff] page 4k
> init_memory_mapping: [mem 0x21c000000-0x21fdfffff]
>  [mem 0x21c000000-0x21fdfffff] page 4k
> init_memory_mapping: [mem 0x200000000-0x21bffffff]
>  [mem 0x200000000-0x21bffffff] page 4k
> init_memory_mapping: [mem 0x00100000-0xcec6dfff]
>  [mem 0x00100000-0xcec6dfff] page 4k
> init_memory_mapping: [mem 0xcf5f4000-0xcf5f4fff]
>  [mem 0xcf5f4000-0xcf5f4fff] page 4k
> init_memory_mapping: [mem 0xcf7fb000-0xcfc19fff]
>  [mem 0xcf7fb000-0xcfc19fff] page 4k
> init_memory_mapping: [mem 0xcfef4000-0xcfefffff]
>  [mem 0xcfef4000-0xcfefffff] page 4k
> init_memory_mapping: [mem 0x100001000-0x1ffffffff]
>  [mem 0x100001000-0x1ffffffff] page 4k
> PGD 0
> Oops: 0003 [#1] SMP
> Modules linked in:
> CPU 0
> Pid: 0, comm: swapper Not tainted 3.6.0+ #3 AMD Pike/Pike
> RIP: e030:[<ffffffff81cd778a>]  [<ffffffff81cd778a>] xen_set_pte_init+0x1/0x9
> RSP: e02b:ffffffff81c01ae8  EFLAGS: 00010086
> RAX: 80000001913d1063 RBX: ffff88021f63b1c8 RCX: 8000000000000163
> RDX: 00000000000001ff RSI: 80000001913d1063 RDI: ffff88021f63b1c8
> RBP: ffffffff81c01af8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 000000011b039000
> R13: 000000000000003a R14: 000000011b03a000 R15: 000000011b039000
> FS:  0000000000000000(0000) GS:ffffffff81cbe000(0000) knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000001c0b000 CR4: 0000000000000660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> Process swapper (pid: 0, threadinfo ffffffff81c00000, task ffffffff81c13410)
> Stack:
>  ffffffff81c01af8 ffffffff810330f5 ffffffff81c01b58 ffffffff816aa9f3
>  8000000000000163 ffff88021f63c000 0000000200000000 000000011b039000
>  ffffffff81c01b38 0000000000000000 000000011b000000 ffff88021f7146c0
> Call Trace:
>  [<ffffffff810330f5>] ? set_pte+0xb/0xd
>  [<ffffffff816aa9f3>] phys_pte_init+0xd4/0x106
>  [<ffffffff816aabe0>] phys_pmd_init+0x1bb/0x215
>  [<ffffffff816aadf3>] phys_pud_init+0x1b9/0x218
>  [<ffffffff816aaeff>] kernel_physical_mapping_init+0xad/0x14a
>  [<ffffffff81682a1a>] init_memory_mapping+0x275/0x303
>  [<ffffffff81ce6e62>] init_range_memory_mapping+0x8b/0xc8
>  [<ffffffff81ce6f91>] init_mem_mapping+0xf2/0x162
>  [<ffffffff81cd9d74>] setup_arch+0x682/0xaac
>  [<ffffffff816af4ab>] ? printk+0x48/0x4a
>  [<ffffffff81cd3868>] start_kernel+0x8e/0x3d8
>  [<ffffffff81cd32d3>] x86_64_start_reservations+0xae/0xb2
>  [<ffffffff81cd6dbc>] xen_start_kernel+0x63d/0x63f
> Code: 00 00 48 c7 c7 f2 a8 aa 81 e8 ee 61 36 ff c7 05 59 10 06 00 01 00 00 00 5d c3 55 48 89 f7 48 89 e5 e8 95 cf 32 ff 31 c0 5d c3 55 <48> 89 37 48 89 e5 5d c3 55 48 89 e5 41 57 41 56 45 31 f6 41 55
>  RSP <ffffffff81c01ae8>
> CR2: 0000000000000000
> ---[ end trace c2b54da46b5614cf ]---

i tested dom0 conf on 32 bit  and 64 bit, they are all working.

and just now I tried with mem=8944m, and they are still working.

anyway, can you please updated -v5 for-x86-mm branch ?
I removed mark_page_ro workaround according to stefano

Thanks

Yinghai
