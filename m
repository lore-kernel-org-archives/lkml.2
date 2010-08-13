Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469Ab0HMK2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:28:12 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39309 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761408Ab0HMK2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iavtIckFf18HKlRSZpQAo1uMrIg/9SsCxuMrzlM1OUKevQCC3YoE7FmJ1EexjmBdo7
         8OSO1Prck6SeaKtGZCEfmv7+BWpyq9MR/7uFFddQt2wKHf3f2xPrD3w7MqeOIlAkbRE4
         uAORMy8IqWYeqPohICzf5/PpcgMUx75fJPjtQ=
MIME-Version: 1.0
In-Reply-To: <tnxhbiyj233.fsf@e102109-lin.cambridge.arm.com>
References: <1281645464.3893.25.camel@maxim-laptop>
	<tnxhbiyj233.fsf@e102109-lin.cambridge.arm.com>
Date: Fri, 13 Aug 2010 13:28:08 +0300
X-Google-Sender-Auth: AnnCRPc5WwxDqT9gxA9cr8dUiFw
Message-ID: <AANLkTi=uD1FAPcu1_dVy_KhnqHwqj1rjpZTA8bn96q9i@mail.gmail.com>
Subject: Re: [REGRESSION 2.6.35+] crash (maybe kmemleak related)
From: Pekka Enberg <penberg@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 13, 2010 at 12:26 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> I don't think the problem is caused by kmemleak (see below).
>
>> <4>[   24.511898] kmemleak: Cannot insert 0xffff880079fe6000 into the object search tree (already existing)
>> <4>[   24.511922] Pid: 2031, comm: NetworkManager Not tainted 2.6.35-rc0+ #108
>> <4>[   24.511936] Call Trace:
>> <4>[   24.511950]  [<ffffffff810dc41a>] create_object+0x27a/0x2d0
>> <4>[   24.511966]  [<ffffffff810d7b9b>] ? __slab_alloc+0xab/0x5c0
>> <4>[   24.511982]  [<ffffffff81137e71>] ? proc_self_follow_link+0x71/0xa0
>> <4>[   24.511999]  [<ffffffff8138ea29>] kmemleak_alloc+0x59/0xd0
>> <4>[   24.512013]  [<ffffffff810d8144>] kmem_cache_alloc+0x94/0x100
>> <4>[   24.512028]  [<ffffffff81137e71>] proc_self_follow_link+0x71/0xa0
>> <4>[   24.512045]  [<ffffffff810ea1bc>] link_path_walk+0x26c/0xd00
>> <4>[   24.512060]  [<ffffffff810ebe22>] do_filp_open+0x152/0x660
>> <4>[   24.512075]  [<ffffffff810648a0>] ? sched_clock_cpu+0xc0/0x110
>> <4>[   24.512091]  [<ffffffff8106e6ac>] ? lock_release_holdtime+0xac/0x150
>> <4>[   24.512107]  [<ffffffff8103888d>] ? sub_preempt_count+0x9d/0xd0
>> <4>[   24.512123]  [<ffffffff813a0eb0>] ? _raw_spin_unlock+0x30/0x60
>> <4>[   24.512139]  [<ffffffff810f7222>] ? alloc_fd+0xf2/0x140
>> <4>[   24.512153]  [<ffffffff810dc890>] do_sys_open+0x60/0x110
>> <4>[   24.512166]  [<ffffffff810dc96b>] sys_open+0x1b/0x20
>> <4>[   24.512181]  [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b
>> <6>[   24.512205] kmemleak: Kernel memory leak detector disabled
>
> Kmemleak shouldn't cause a panic, it just prints the message and
> disables itself.
>
>> <5>[   24.512221] kmemleak: Object 0xffff880079fe6000 (size 4096):
>> <5>[   24.512234] kmemleak:   comm "NetworkManager", pid 2031, jiffies 4294939747
>> <5>[   24.512248] kmemleak:   min_count = 1
>> <5>[   24.512257] kmemleak:   count = 0
>> <5>[   24.512265] kmemleak:   flags = 0x1
>> <5>[   24.512273] kmemleak:   checksum = 0
>> <5>[   24.512281] kmemleak:   backtrace:
>> <4>[   24.512289]      [<ffffffff8138ea29>] kmemleak_alloc+0x59/0xd0
>> <4>[   24.512304]      [<ffffffff810d8144>] kmem_cache_alloc+0x94/0x100
>> <4>[   24.512319]      [<ffffffff810e9d76>] getname+0x36/0x210
>> <4>[   24.512333]      [<ffffffff810dc85d>] do_sys_open+0x2d/0x110
>> <4>[   24.512347]      [<ffffffff810dc96b>] sys_open+0x1b/0x20
>> <4>[   24.512361]      [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b
>> <4>[   24.512377]      [<ffffffffffffffff>] 0xffffffffffffffff
>
> This kmemleak warning tells us that the kmemleak_alloc() hook got called
> with a pointer (0xffff880079fe6000) that's already registered with
> kmemleak. The first trace tells us where the hook gets called from while
> the second trace shows the details of the already existing pointer.
>
> So __getname() allocates the same 4096 bytes block twice via
> kmem_cache_alloc() but there is no kmemleak_free() call between them and
> kmemleak gives up. It disables itself but does not panic the system.
>
> Pekka, were there any recent changes in the slab/slob/slub area and
> maybe a kmemleak_free() hook is missing? Or maybe something else went
> wrong with the slab allocator and returns an already allocated block?
>
>> <0>[   24.578578] general protection fault: 0000 [#1] PREEMPT SMP
>
> That's what's causing the fault but it doesn't seem to be related to
> kmemleak.

Looking at Maxim's log, slab seems to be corrupted. I don't see
anything obviously wrong with SLUB (which he is using) kmemleak hooks
so it doesn't look like a slab allocator problem either. Could this be
related to the bootmem kmemleak hook changes?

Maxim, can you see some kind of crashes with CONFIG_KMEMLEAK disabled?
If yes, can you please enable SLUB debugging either by passing
'slub_debug' as kernel parameter or enabling CONFIG_SLUB_DEBUG_ON
config option and try to reproduce the issue?

                        Pekka
