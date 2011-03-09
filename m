Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1CIU5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 15:57:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:24518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1CIU5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 15:57:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=RQqZggm1QLzbc3OPXVNN2V2C+lWUjyypm2kBGtThLvGiRjhYTry/sUqF0hrr/I6c2F
         eTzAiLCLFbHx2ptSZmRQ==
Date: Wed, 9 Mar 2011 12:57:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Justin P. Mattock" <justinmattock@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@kernel.dk>, Dave Chinner <dchinner@redhat.com>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>
Subject: Re: <IRQ> [<ffffffff810c9204>] ?
 __alloc_pages_nodemask+0x622/0x696
In-Reply-To: <4D770178.9070908@gmail.com>
Message-ID: <alpine.DEB.2.00.1103091254540.13353@chino.kir.corp.google.com>
References: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com> <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com> <4D770178.9070908@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1238711482-1299704236=:13353"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1238711482-1299704236=:13353
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 8 Mar 2011, Justin P. Mattock wrote:

> man O man.. didnt have a chance to use the boot options yet due to other
> things I have been doing, anyways this popped up may/maynot be related:
> 

Adding some people who have been working in this area recently to the cc.

> [ 7603.339047]
> =============================================================================
> [ 7603.339053] BUG radix_tree_node: Padding overwritten.
> 0xffff88000008fe00-0xffff88000008fe32
> [ 7603.339055]
> -----------------------------------------------------------------------------
> [ 7603.339056]
> [ 7603.339059] INFO: Slab 0xffffea0000001ea0 objects=25 used=25 fp=0x
> (null) flags=0x4081
> [ 7603.339063] Pid: 0, comm: swapper Not tainted 2.6.38-rc7-00164-gcdf1389 #8
> [ 7603.339066] Call Trace:
> [ 7603.339068]  <IRQ>  [<ffffffff810f4df9>] ? slab_err+0x8a/0x98
> [ 7603.339083]  [<ffffffff81446ea2>] ? _raw_spin_unlock+0x9/0xb
> [ 7603.339088]  [<ffffffff810c7904>] ? free_one_page+0x2d4/0x2e3
> [ 7603.339091]  [<ffffffff810f52df>] ? slab_pad_check+0xc4/0x102
> [ 7603.339096]  [<ffffffff811f6382>] ? radix_tree_node_rcu_free+0x3b/0x3d
> [ 7603.339099]  [<ffffffff810f53a7>] ? check_slab+0x8a/0x91
> [ 7603.339102]  [<ffffffff810f5d9e>] ? free_debug_processing+0x22/0x208
> [ 7603.339105]  [<ffffffff810f60b4>] ? __slab_free+0x130/0x145
> [ 7603.339108]  [<ffffffff810f6a93>] ? kmem_cache_free+0x8e/0xd4
> [ 7603.339112]  [<ffffffff811f6382>] ? radix_tree_node_rcu_free+0x3b/0x3d
> [ 7603.339118]  [<ffffffff810a75c5>] ? __rcu_process_callbacks+0x186/0x28b
> [ 7603.339121]  [<ffffffff810a76ed>] ? rcu_process_callbacks+0x23/0x44
> [ 7603.339126]  [<ffffffff81067253>] ? __do_softirq+0xc7/0x1a4
> [ 7603.339132]  [<ffffffff8102fd79>] ? timer_interrupt+0x19/0x20
> [ 7603.339135]  [<ffffffff8102e15c>] ? call_softirq+0x1c/0x28
> [ 7603.339139]  [<ffffffff8102f635>] ? do_softirq+0x41/0x7e
> [ 7603.339142]  [<ffffffff810670ea>] ? irq_exit+0x36/0x78
> [ 7603.339145]  [<ffffffff8102ed0e>] ? do_IRQ+0x98/0xaf
> [ 7603.339148]  [<ffffffff81447253>] ? ret_from_intr+0x0/0x15
> [ 7603.339150]  <EOI>  [<ffffffff810337d5>] ? native_sched_clock+0x2d/0x60
> [ 7603.339183]  [<ffffffffa001a661>] ? acpi_idle_enter_bm+0x2b9/0x2f1
> [processor]
> [ 7603.339189]  [<ffffffffa001a65a>] ? acpi_idle_enter_bm+0x2b2/0x2f1
> [processor]
> [ 7603.339195]  [<ffffffff81336a52>] ? menu_select+0x175/0x2a8
> [ 7603.339198]  [<ffffffff81335c3a>] ? cpuidle_idle_call+0x118/0x1be
> [ 7603.339202]  [<ffffffff8102c691>] ? cpu_idle+0x60/0x97
> [ 7603.339206]  [<ffffffff814308b4>] ? rest_init+0x68/0x6a
> [ 7603.339211]  [<ffffffff81705c3c>] ? start_kernel+0x2fc/0x307
> [ 7603.339215]  [<ffffffff8170527b>] ? x86_64_start_reservations+0x82/0x86
> [ 7603.339218]  [<ffffffff81705385>] ? x86_64_start_kernel+0x106/0x115
> [ 7603.339221]  Padding 0xffff88000008fbeb:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339234]  Padding 0xffff88000008fbfb:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339247]  Padding 0xffff88000008fc0b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339260]  Padding 0xffff88000008fc1b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339273]  Padding 0xffff88000008fc2b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339285]  Padding 0xffff88000008fc3b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339298]  Padding 0xffff88000008fc4b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339311]  Padding 0xffff88000008fc5b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339324]  Padding 0xffff88000008fc6b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339337]  Padding 0xffff88000008fc7b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339349]  Padding 0xffff88000008fc8b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339362]  Padding 0xffff88000008fc9b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339375]  Padding 0xffff88000008fcab:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339387]  Padding 0xffff88000008fcbb:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339400]  Padding 0xffff88000008fccb:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339413]  Padding 0xffff88000008fcdb:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339426]  Padding 0xffff88000008fceb:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339439]  Padding 0xffff88000008fcfb:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339451]  Padding 0xffff88000008fd0b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339464]  Padding 0xffff88000008fd1b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339477]  Padding 0xffff88000008fd2b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339490]  Padding 0xffff88000008fd3b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339503]  Padding 0xffff88000008fd4b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339516]  Padding 0xffff88000008fd5b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339529]  Padding 0xffff88000008fd6b:  00 00 00 00 00 cc cc cc cc cc cc
> cc cc 00 00 00 .....ÌÌÌÌÌÌÌÌ...
> [ 7603.339542]  Padding 0xffff88000008fd7b:  00 00 00 00 00 29 6e 1f 81 ff ff
> ff ff 00 00 00 .....)n..ÿÿÿÿ...
> [ 7603.339555]  Padding 0xffff88000008fd8b:  00 c2 0a 00 00 44 ec 0a 00 01 00
> 00 00 00 00 00 .Â...Dì.........
> [ 7603.339568]  Padding 0xffff88000008fd9b:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339581]  Padding 0xffff88000008fdab:  00 00 00 00 00 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a .....ZZZZZZZZZZZ
> [ 7603.339593]  Padding 0xffff88000008fdbb:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.339606]  Padding 0xffff88000008fdcb:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.339619]  Padding 0xffff88000008fddb:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.339632]  Padding 0xffff88000008fdeb:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.339645]  Padding 0xffff88000008fdfb:  5a 5a 5a 5a 5a 00 5a 5a 5a 10 b0
> 08 3f 00 80 00 ZZZZZ.ZZZ.°.?...
> [ 7603.339658]  Padding 0xffff88000008fe0b:  00 c7 60 ed 3f 3f 00 10 df ed 3f
> ff 07 10 c0 ed .Ç`í??..ßí?ÿ..Àí
> [ 7603.339671]  Padding 0xffff88000008fe1b:  3f fa 33 c9 33 d2 b8 3c fe 08 00
> 0f 01 c8 b8 31 ?ú3É3Ò¸<þ....È¸1
> [ 7603.339684]  Padding 0xffff88000008fe2b:  00 00 00 0f 01 c9 eb e9
> .....Éëé
> [ 7603.339698] FIX radix_tree_node: Restoring
> 0xffff88000008fbeb-0xffff88000008fe32=0x5a
> [ 7603.339699]
> [ 7603.339791]
> =============================================================================
> [ 7603.339793] BUG radix_tree_node: Redzone overwritten
> [ 7603.339795]
> -----------------------------------------------------------------------------
> [ 7603.339796]
> [ 7603.339799] INFO: 0xffff88000008fd70-0xffff88000008fd77. First byte 0x5a
> instead of 0xcc
> [ 7603.339805] INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522584921681
> cpu=1515870810 pid=1515870810
> [ 7603.339809] INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522584921681
> cpu=1515870810 pid=1515870810
> [ 7603.339812] INFO: Slab 0xffffea0000001ea0 objects=25 used=1
> fp=0xffff88000008f8c8 flags=0x4081
> [ 7603.339815] INFO: Object 0xffff88000008fb40 @offset=15168
> fp=0x5a5a5a5a5a5a5a5a
> [ 7603.339816]
> [ 7603.339818] Bytes b4 0xffff88000008fb30:  ab 70 6f 00 01 00 00 00 5a 5a 5a
> 5a 5a 5a 5a 5a «po.....ZZZZZZZZ
> [ 7603.339832]   Object 0xffff88000008fb40:  01 00 00 00 00 00 00 00 08 80 10
> 00 00 88 ff ff ..............ÿÿ
> [ 7603.339845]   Object 0xffff88000008fb50:  47 63 1f 81 ff ff ff ff 00 00 00
> 00 00 00 00 00 Gc..ÿÿÿÿ........
> [ 7603.339857]   Object 0xffff88000008fb60:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339870]   Object 0xffff88000008fb70:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339883]   Object 0xffff88000008fb80:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339896]   Object 0xffff88000008fb90:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339908]   Object 0xffff88000008fba0:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339921]   Object 0xffff88000008fbb0:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339934]   Object 0xffff88000008fbc0:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339946]   Object 0xffff88000008fbd0:  00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 ................
> [ 7603.339959]   Object 0xffff88000008fbe0:  00 00 00 00 00 00 00 00 00 00 00
> 5a 5a 5a 5a 5a ...........ZZZZZ
> [ 7603.339972]   Object 0xffff88000008fbf0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.339985]   Object 0xffff88000008fc00:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.339998]   Object 0xffff88000008fc10:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340010]   Object 0xffff88000008fc20:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fc30:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fc40:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fc50:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fc60:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fc70:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fc80:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fc90:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fca0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fcb0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fcc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fcd0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fce0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fcf0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fd00:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fd10:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fd20:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fd30:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fd40:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fd50:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]   Object 0xffff88000008fd60:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
> 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> [ 7603.340018]  Redzone 0xffff88000008fd70:  5a 5a 5a 5a 5a 5a 5a 5a
> ZZZZZZZZ
> [ 7603.340018]  Padding 0xffff88000008fdb0:  5a 5a 5a 5a 5a 5a 5a 5a
> ZZZZZZZZ
> [ 7603.340018] Pid: 0, comm: swapper Not tainted 2.6.38-rc7-00164-gcdf1389 #8
> [ 7603.340018] Call Trace:
> [ 7603.340018]  <IRQ>  [<ffffffff810f4f35>] ? print_trailer+0x12e/0x137
> [ 7603.340018]  [<ffffffff811f63cc>] ? __lookup_tag+0x39/0xf0
> [ 7603.340018]  [<ffffffff810f5463>] ? check_bytes_and_report+0xb5/0xe6
> [ 7603.340018]  [<ffffffff811f63cc>] ? __lookup_tag+0x39/0xf0
> [ 7603.340018]  [<ffffffff810f54dd>] ? check_object+0x49/0x1eb
> [ 7603.340018]  [<ffffffff811f6382>] ? radix_tree_node_rcu_free+0x3b/0x3d
> [ 7603.340018]  [<ffffffff810f5e4a>] ? free_debug_processing+0xce/0x208
> [ 7603.340018]  [<ffffffff810f60b4>] ? __slab_free+0x130/0x145
> [ 7603.340018]  [<ffffffff810f6a93>] ? kmem_cache_free+0x8e/0xd4
> [ 7603.340018]  [<ffffffff811f6382>] ? radix_tree_node_rcu_free+0x3b/0x3d
> [ 7603.340018]  [<ffffffff810a75c5>] ? __rcu_process_callbacks+0x186/0x28b
> [ 7603.340018]  [<ffffffff810a76ed>] ? rcu_process_callbacks+0x23/0x44
> [ 7603.340018]  [<ffffffff81067253>] ? __do_softirq+0xc7/0x1a4
> [ 7603.340018]  [<ffffffff8102fd79>] ? timer_interrupt+0x19/0x20
> [ 7603.340018]  [<ffffffff8102e15c>] ? call_softirq+0x1c/0x28
> [ 7603.340018]  [<ffffffff8102f635>] ? do_softirq+0x41/0x7e
> [ 7603.340018]  [<ffffffff810670ea>] ? irq_exit+0x36/0x78
> [ 7603.340018]  [<ffffffff8102ed0e>] ? do_IRQ+0x98/0xaf
> [ 7603.340018]  [<ffffffff81447253>] ? ret_from_intr+0x0/0x15
> [ 7603.340018]  <EOI>  [<ffffffff810337d5>] ? native_sched_clock+0x2d/0x60
> [ 7603.340018]  [<ffffffffa001a661>] ? acpi_idle_enter_bm+0x2b9/0x2f1
> [processor]
> [ 7603.340018]  [<ffffffffa001a65a>] ? acpi_idle_enter_bm+0x2b2/0x2f1
> [processor]
> [ 7603.340018]  [<ffffffff81336a52>] ? menu_select+0x175/0x2a8
> [ 7603.340018]  [<ffffffff81335c3a>] ? cpuidle_idle_call+0x118/0x1be
> [ 7603.340018]  [<ffffffff8102c691>] ? cpu_idle+0x60/0x97
> [ 7603.340018]  [<ffffffff814308b4>] ? rest_init+0x68/0x6a
> [ 7603.340018]  [<ffffffff81705c3c>] ? start_kernel+0x2fc/0x307
> [ 7603.340018]  [<ffffffff8170527b>] ? x86_64_start_reservations+0x82/0x86
> [ 7603.340018]  [<ffffffff81705385>] ? x86_64_start_kernel+0x106/0x115
> [ 7603.340018] FIX radix_tree_node: Restoring
> 0xffff88000008fd70-0xffff88000008fd77=0xcc
> [ 7603.340018]
> [ 7747.730540] cfg80211: Calling CRDA to update world regulatory domain
> [ 7750.272336] wlan0: authenticate with 00:21:55:b4:20:20 (try 1)
> [ 7750.275393] wlan0: authenticated
--531368966-1238711482-1299704236=:13353--
