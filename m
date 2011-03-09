Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab1CIEeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 23:34:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53209 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab1CIEe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 23:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Winh7hYpV6GlmfagGyvkTi+cvhpdORfX9Z+yYaYGnjWmuBaw+OyRbZzJx3IdzX6G/1
         wPu85knGGAQqIxWVf3sA9WwIf19D7r4sexq89hBFGqopTYiO6S44JmR6JF8dW4x0EA71
         EOn3gOZ5513w9k9XoX83TQq9EQFBwF/Gj87GE=
Message-ID: <4D770178.9070908@gmail.com>
Date: Tue, 08 Mar 2011 20:26:32 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: <IRQ> [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
References: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com> <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2011 06:50 PM, David Rientjes wrote:
> On Sat, 5 Mar 2011, Justin Mattock wrote:
>
>> [  339.787008] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
>> [  339.787008]   cache: kmalloc-8192, object size: 8192, buffer size:
>> 8264, default order: 3, min order: 2
>> [  339.787008]   kmalloc-8192 debugging increased min order, use
>> slub_debug=O to disable.
>> [  339.787008]   node 0: slabs: 181, objs: 543, free: 0
>> [  339.790575] skbuff alloc of size 3904 failed
>> [  339.823775] swapper: page allocation failure. order:2, mode:0x4020
>> [  339.823781] Pid: 0, comm: swapper Not tainted 2.6.38-rc7-00143-gd1b152c #7
>> [  339.823783] Call Trace:
>> [  339.823786]<IRQ>   [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
>> [  339.823811]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
>> [  339.823815]  [<ffffffff810f67cf>] ? new_slab+0x7b/0x1c6
>> [  339.823819]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
>> [  339.823823]  [<ffffffff810f6dd6>] ? T.925+0x163/0x29c
>> [  339.823827]  [<ffffffff810c4ecc>] ? mempool_destroy+0xf/0x17
>> [  339.823832]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
>> [  339.823836]  [<ffffffff810f895a>] ? __kmalloc_track_caller+0xfe/0x190
>>
>
> Order-2 atomic allocations are always going to be difficult since we can't
> do synchronous compaction or reclaim, but I'd try the suggestion shown
> above: boot with slub_debug=O or disable slub debugging so that
> kmalloc-8192 is actually order-1 like it should be.
>

man O man.. didnt have a chance to use the boot options yet due to other 
things I have been doing, anyways this popped up may/maynot be related:

[ 7603.339047] 
=============================================================================
[ 7603.339053] BUG radix_tree_node: Padding overwritten. 
0xffff88000008fe00-0xffff88000008fe32
[ 7603.339055] 
-----------------------------------------------------------------------------
[ 7603.339056]
[ 7603.339059] INFO: Slab 0xffffea0000001ea0 objects=25 used=25 fp=0x 
        (null) flags=0x4081
[ 7603.339063] Pid: 0, comm: swapper Not tainted 
2.6.38-rc7-00164-gcdf1389 #8
[ 7603.339066] Call Trace:
[ 7603.339068]  <IRQ>  [<ffffffff810f4df9>] ? slab_err+0x8a/0x98
[ 7603.339083]  [<ffffffff81446ea2>] ? _raw_spin_unlock+0x9/0xb
[ 7603.339088]  [<ffffffff810c7904>] ? free_one_page+0x2d4/0x2e3
[ 7603.339091]  [<ffffffff810f52df>] ? slab_pad_check+0xc4/0x102
[ 7603.339096]  [<ffffffff811f6382>] ? radix_tree_node_rcu_free+0x3b/0x3d
[ 7603.339099]  [<ffffffff810f53a7>] ? check_slab+0x8a/0x91
[ 7603.339102]  [<ffffffff810f5d9e>] ? free_debug_processing+0x22/0x208
[ 7603.339105]  [<ffffffff810f60b4>] ? __slab_free+0x130/0x145
[ 7603.339108]  [<ffffffff810f6a93>] ? kmem_cache_free+0x8e/0xd4
[ 7603.339112]  [<ffffffff811f6382>] ? radix_tree_node_rcu_free+0x3b/0x3d
[ 7603.339118]  [<ffffffff810a75c5>] ? __rcu_process_callbacks+0x186/0x28b
[ 7603.339121]  [<ffffffff810a76ed>] ? rcu_process_callbacks+0x23/0x44
[ 7603.339126]  [<ffffffff81067253>] ? __do_softirq+0xc7/0x1a4
[ 7603.339132]  [<ffffffff8102fd79>] ? timer_interrupt+0x19/0x20
[ 7603.339135]  [<ffffffff8102e15c>] ? call_softirq+0x1c/0x28
[ 7603.339139]  [<ffffffff8102f635>] ? do_softirq+0x41/0x7e
[ 7603.339142]  [<ffffffff810670ea>] ? irq_exit+0x36/0x78
[ 7603.339145]  [<ffffffff8102ed0e>] ? do_IRQ+0x98/0xaf
[ 7603.339148]  [<ffffffff81447253>] ? ret_from_intr+0x0/0x15
[ 7603.339150]  <EOI>  [<ffffffff810337d5>] ? native_sched_clock+0x2d/0x60
[ 7603.339183]  [<ffffffffa001a661>] ? acpi_idle_enter_bm+0x2b9/0x2f1 
[processor]
[ 7603.339189]  [<ffffffffa001a65a>] ? acpi_idle_enter_bm+0x2b2/0x2f1 
[processor]
[ 7603.339195]  [<ffffffff81336a52>] ? menu_select+0x175/0x2a8
[ 7603.339198]  [<ffffffff81335c3a>] ? cpuidle_idle_call+0x118/0x1be
[ 7603.339202]  [<ffffffff8102c691>] ? cpu_idle+0x60/0x97
[ 7603.339206]  [<ffffffff814308b4>] ? rest_init+0x68/0x6a
[ 7603.339211]  [<ffffffff81705c3c>] ? start_kernel+0x2fc/0x307
[ 7603.339215]  [<ffffffff8170527b>] ? x86_64_start_reservations+0x82/0x86
[ 7603.339218]  [<ffffffff81705385>] ? x86_64_start_kernel+0x106/0x115
[ 7603.339221]  Padding 0xffff88000008fbeb:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339234]  Padding 0xffff88000008fbfb:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339247]  Padding 0xffff88000008fc0b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339260]  Padding 0xffff88000008fc1b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339273]  Padding 0xffff88000008fc2b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339285]  Padding 0xffff88000008fc3b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339298]  Padding 0xffff88000008fc4b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339311]  Padding 0xffff88000008fc5b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339324]  Padding 0xffff88000008fc6b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339337]  Padding 0xffff88000008fc7b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339349]  Padding 0xffff88000008fc8b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339362]  Padding 0xffff88000008fc9b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339375]  Padding 0xffff88000008fcab:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339387]  Padding 0xffff88000008fcbb:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339400]  Padding 0xffff88000008fccb:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339413]  Padding 0xffff88000008fcdb:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339426]  Padding 0xffff88000008fceb:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339439]  Padding 0xffff88000008fcfb:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339451]  Padding 0xffff88000008fd0b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339464]  Padding 0xffff88000008fd1b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339477]  Padding 0xffff88000008fd2b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339490]  Padding 0xffff88000008fd3b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339503]  Padding 0xffff88000008fd4b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339516]  Padding 0xffff88000008fd5b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339529]  Padding 0xffff88000008fd6b:  00 00 00 00 00 cc cc cc cc 
cc cc cc cc 00 00 00 .....ÌÌÌÌÌÌÌÌ...
[ 7603.339542]  Padding 0xffff88000008fd7b:  00 00 00 00 00 29 6e 1f 81 
ff ff ff ff 00 00 00 .....)n..ÿÿÿÿ...
[ 7603.339555]  Padding 0xffff88000008fd8b:  00 c2 0a 00 00 44 ec 0a 00 
01 00 00 00 00 00 00 .Â...Dì.........
[ 7603.339568]  Padding 0xffff88000008fd9b:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339581]  Padding 0xffff88000008fdab:  00 00 00 00 00 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a .....ZZZZZZZZZZZ
[ 7603.339593]  Padding 0xffff88000008fdbb:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.339606]  Padding 0xffff88000008fdcb:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.339619]  Padding 0xffff88000008fddb:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.339632]  Padding 0xffff88000008fdeb:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.339645]  Padding 0xffff88000008fdfb:  5a 5a 5a 5a 5a 00 5a 5a 5a 
10 b0 08 3f 00 80 00 ZZZZZ.ZZZ.°.?...
[ 7603.339658]  Padding 0xffff88000008fe0b:  00 c7 60 ed 3f 3f 00 10 df 
ed 3f ff 07 10 c0 ed .Ç`í??..ßí?ÿ..Àí
[ 7603.339671]  Padding 0xffff88000008fe1b:  3f fa 33 c9 33 d2 b8 3c fe 
08 00 0f 01 c8 b8 31 ?ú3É3Ò¸<þ....È¸1
[ 7603.339684]  Padding 0xffff88000008fe2b:  00 00 00 0f 01 c9 eb e9 
                      .....Éëé
[ 7603.339698] FIX radix_tree_node: Restoring 
0xffff88000008fbeb-0xffff88000008fe32=0x5a
[ 7603.339699]
[ 7603.339791] 
=============================================================================
[ 7603.339793] BUG radix_tree_node: Redzone overwritten
[ 7603.339795] 
-----------------------------------------------------------------------------
[ 7603.339796]
[ 7603.339799] INFO: 0xffff88000008fd70-0xffff88000008fd77. First byte 
0x5a instead of 0xcc
[ 7603.339805] INFO: Allocated in 0x5a5a5a5a5a5a5a5a 
age=11936128522584921681 cpu=1515870810 pid=1515870810
[ 7603.339809] INFO: Freed in 0x5a5a5a5a5a5a5a5a 
age=11936128522584921681 cpu=1515870810 pid=1515870810
[ 7603.339812] INFO: Slab 0xffffea0000001ea0 objects=25 used=1 
fp=0xffff88000008f8c8 flags=0x4081
[ 7603.339815] INFO: Object 0xffff88000008fb40 @offset=15168 
fp=0x5a5a5a5a5a5a5a5a
[ 7603.339816]
[ 7603.339818] Bytes b4 0xffff88000008fb30:  ab 70 6f 00 01 00 00 00 5a 
5a 5a 5a 5a 5a 5a 5a «po.....ZZZZZZZZ
[ 7603.339832]   Object 0xffff88000008fb40:  01 00 00 00 00 00 00 00 08 
80 10 00 00 88 ff ff ..............ÿÿ
[ 7603.339845]   Object 0xffff88000008fb50:  47 63 1f 81 ff ff ff ff 00 
00 00 00 00 00 00 00 Gc..ÿÿÿÿ........
[ 7603.339857]   Object 0xffff88000008fb60:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339870]   Object 0xffff88000008fb70:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339883]   Object 0xffff88000008fb80:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339896]   Object 0xffff88000008fb90:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339908]   Object 0xffff88000008fba0:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339921]   Object 0xffff88000008fbb0:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339934]   Object 0xffff88000008fbc0:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339946]   Object 0xffff88000008fbd0:  00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 ................
[ 7603.339959]   Object 0xffff88000008fbe0:  00 00 00 00 00 00 00 00 00 
00 00 5a 5a 5a 5a 5a ...........ZZZZZ
[ 7603.339972]   Object 0xffff88000008fbf0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.339985]   Object 0xffff88000008fc00:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.339998]   Object 0xffff88000008fc10:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340010]   Object 0xffff88000008fc20:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fc30:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fc40:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fc50:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fc60:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fc70:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fc80:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fc90:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fca0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fcb0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fcc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fcd0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fce0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fcf0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fd00:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fd10:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fd20:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fd30:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fd40:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fd50:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]   Object 0xffff88000008fd60:  5a 5a 5a 5a 5a 5a 5a 5a 5a 
5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[ 7603.340018]  Redzone 0xffff88000008fd70:  5a 5a 5a 5a 5a 5a 5a 5a 
                      ZZZZZZZZ
[ 7603.340018]  Padding 0xffff88000008fdb0:  5a 5a 5a 5a 5a 5a 5a 5a 
                      ZZZZZZZZ
[ 7603.340018] Pid: 0, comm: swapper Not tainted 
2.6.38-rc7-00164-gcdf1389 #8
[ 7603.340018] Call Trace:
[ 7603.340018]  <IRQ>  [<ffffffff810f4f35>] ? print_trailer+0x12e/0x137
[ 7603.340018]  [<ffffffff811f63cc>] ? __lookup_tag+0x39/0xf0
[ 7603.340018]  [<ffffffff810f5463>] ? check_bytes_and_report+0xb5/0xe6
[ 7603.340018]  [<ffffffff811f63cc>] ? __lookup_tag+0x39/0xf0
[ 7603.340018]  [<ffffffff810f54dd>] ? check_object+0x49/0x1eb
[ 7603.340018]  [<ffffffff811f6382>] ? radix_tree_node_rcu_free+0x3b/0x3d
[ 7603.340018]  [<ffffffff810f5e4a>] ? free_debug_processing+0xce/0x208
[ 7603.340018]  [<ffffffff810f60b4>] ? __slab_free+0x130/0x145
[ 7603.340018]  [<ffffffff810f6a93>] ? kmem_cache_free+0x8e/0xd4
[ 7603.340018]  [<ffffffff811f6382>] ? radix_tree_node_rcu_free+0x3b/0x3d
[ 7603.340018]  [<ffffffff810a75c5>] ? __rcu_process_callbacks+0x186/0x28b
[ 7603.340018]  [<ffffffff810a76ed>] ? rcu_process_callbacks+0x23/0x44
[ 7603.340018]  [<ffffffff81067253>] ? __do_softirq+0xc7/0x1a4
[ 7603.340018]  [<ffffffff8102fd79>] ? timer_interrupt+0x19/0x20
[ 7603.340018]  [<ffffffff8102e15c>] ? call_softirq+0x1c/0x28
[ 7603.340018]  [<ffffffff8102f635>] ? do_softirq+0x41/0x7e
[ 7603.340018]  [<ffffffff810670ea>] ? irq_exit+0x36/0x78
[ 7603.340018]  [<ffffffff8102ed0e>] ? do_IRQ+0x98/0xaf
[ 7603.340018]  [<ffffffff81447253>] ? ret_from_intr+0x0/0x15
[ 7603.340018]  <EOI>  [<ffffffff810337d5>] ? native_sched_clock+0x2d/0x60
[ 7603.340018]  [<ffffffffa001a661>] ? acpi_idle_enter_bm+0x2b9/0x2f1 
[processor]
[ 7603.340018]  [<ffffffffa001a65a>] ? acpi_idle_enter_bm+0x2b2/0x2f1 
[processor]
[ 7603.340018]  [<ffffffff81336a52>] ? menu_select+0x175/0x2a8
[ 7603.340018]  [<ffffffff81335c3a>] ? cpuidle_idle_call+0x118/0x1be
[ 7603.340018]  [<ffffffff8102c691>] ? cpu_idle+0x60/0x97
[ 7603.340018]  [<ffffffff814308b4>] ? rest_init+0x68/0x6a
[ 7603.340018]  [<ffffffff81705c3c>] ? start_kernel+0x2fc/0x307
[ 7603.340018]  [<ffffffff8170527b>] ? x86_64_start_reservations+0x82/0x86
[ 7603.340018]  [<ffffffff81705385>] ? x86_64_start_kernel+0x106/0x115
[ 7603.340018] FIX radix_tree_node: Restoring 
0xffff88000008fd70-0xffff88000008fd77=0xcc
[ 7603.340018]
[ 7747.730540] cfg80211: Calling CRDA to update world regulatory domain
[ 7750.272336] wlan0: authenticate with 00:21:55:b4:20:20 (try 1)
[ 7750.275393] wlan0: authenticated


full dmesg here:
http://fpaste.org/aVFd/

Justin P. Mattock
