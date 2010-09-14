Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0INI0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:26:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:38849 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab0INI0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:26:34 -0400
Message-ID: <4C8F31A9.7070507@kernel.org>
Date: Tue, 14 Sep 2010 10:26:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, dhowells@redhat.com,
        graff.yang@gmail.com, sonic.adi@gmail.com,
        kexec <kexec@lists.infradead.org>
Subject: Re: kvm kdump regression
References: <149379123.860951284433779554.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <149379123.860951284433779554.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Sep 2010 08:26:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 05:09 AM, CAI Qian wrote:
> This commit introduced a regression that an empty vmcore was generated on a kvm guest.
> ioremap: invalid physical address db74000000000000
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/ioremap.c:83 __ioremap_caller+0x307/0x380()
> Hardware name: KVM
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.36-rc2-mm1+ #2
> Call Trace:
>  [<ffffffff8105f48f>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8103052e>] ? copy_oldmem_page+0x4e/0xc0
>  [<ffffffff8105f4ea>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8103f0a7>] __ioremap_caller+0x307/0x380
>  [<ffffffff8103f1f7>] ioremap_nocache+0x17/0x20
>  [<ffffffff8103052e>] copy_oldmem_page+0x4e/0xc0
>  [<ffffffff811af4ca>] read_from_oldmem+0x7a/0xb0
>  [<ffffffff81c4f70b>] merge_note_headers_elf64.clone.1+0x6c/0x21f
>  [<ffffffff8103056e>] ? copy_oldmem_page+0x8e/0xc0
>  [<ffffffff811af4ca>] ? read_from_oldmem+0x7a/0xb0
>  [<ffffffff81c4fa5b>] vmcore_init+0x19d/0x396
>  [<ffffffff81c4f8be>] ? vmcore_init+0x0/0x396
>  [<ffffffff81002053>] do_one_initcall+0x43/0x190
>  [<ffffffff81c278ab>] kernel_init+0x2a0/0x330
>  [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81c2760b>] ? kernel_init+0x0/0x330
>  [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 93d72a36b9146f22 ]---
> Kdump: vmcore not initialized
> 
> commit 020ec6537aa65c18e9084c568d7b94727f2026fd
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri Apr 9 18:57:00 2010 +0900
> 
>     percpu: factor out pcpu_addr_in_first/reserved_chunk() and update per_cpu_ptr_to_phys()

Hmm... I'm confused.  Isn't this the one fixed by commit 9983b6f0
(percpu: fix first chunk match in per_cpu_ptr_to_phys())?

Thanks.

-- 
tejun
