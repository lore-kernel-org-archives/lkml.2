Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2KIAxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:53:52 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51092 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2KIAxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:53:50 -0500
MIME-Version: 1.0
In-Reply-To: <20121107162840.GA2660@mtj.dyndns.org>
References: <CADCVGbSC-T=W08xcf9rDynS8Uf9yq=KKTNUn33g-O_FqyQkU_A@mail.gmail.com>
	<20121107162840.GA2660@mtj.dyndns.org>
Date: Fri, 9 Nov 2012 08:53:49 +0800
Message-ID: <CADCVGbR-39diiMA-C2cEn315r916HMprt6Lx4s8qN8jHC_e8FQ@mail.gmail.com>
Subject: Re: Is this a kernel bug?
From: Cyberman Wu <cypher.w@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of these message on many CPU:


 Pid: 906, comm:         kworker/16:1, CPU: 16
 r0 : 0xfffffe00f9fbfea0 r1 : 0x0000000000000010 r2 : 0x0000000000000002
 r3 : 0xfffffff5001017e4 r4 : 0xfffffffffffffe00 r5 : 0xfffffffffe0000a4
 r6 : 0xfffffffffffffe00 r7 : 0x0000000000000002 r8 : 0x0000000000000000
 r9 : 0xfffffff5001017e0 r10: 0xfffffff5001017dc r11: 0xfffffff5001017c8
 r12: 0x0000000000000001 r13: 0xfffffe40fc690090 r14: 0x0000000000000000
 r15: 0x0000000000000000 r16: 0xfffffe40fc690088 r17: 0xfffffe00f841be80
 r18: 0xfffffe00f841be80 r19: 0xfffffff500101790 r20: 0x0000000000000001
 r21: 0xfffffe40fe710ce8 r22: 0xfffffffffe0000b5 r23: 0xfffffff5001017d8
 r24: 0xfffffe00008e3c80 r25: 0x000001f4ff820000 r26: 0xfffffe0000a40080
 r27: 0xfffffffffe00008e r28: 0x0000000000000010 r29: 0xfffffe0000a40000
 r30: 0x0000000000000000 r31: 0xfffffe00f9fbfe98 r32: 0xfffffffffffffe00
 r33: 0xfffffff5001017c8 r34: 0xfffffe00008e3c80 r35: 0xfffffe40fc6900a0
 r36: 0xfffffe40fc6900a0 r37: 0xfffffff5001017dc r38: 0xfffffe0000b5ad00
 r39: 0xfffffe0000a40000 r40: 0xfffffe0000b5ad04 r41: 0xfffffe00008e0040
 r42: 0xfffffff5001017c8 r43: 0xfffffe00009aa9a0 r44: 0xfffffe00008e3c80
 r45: 0xfffffe40fc6900b0 r46: 0xfffffff5001017d8 r47: 0xfffffe0000b5ad05
 r48: 0xfffffe00008e3c80 r49: 0xfffffe40fc6900b8 r50: 0xfffffff5001017e4
 r51: 0xfffffff5001017c0 r52: 0xfffffe00008e3c80 tp : 0x000001f4ff820000
 sp : 0xfffffe00f9fbfe78 lr : 0x0000000000000002
 pc : 0xfffffff7002fc488 ex1: 1     faultnum: 17

Starting stack dump of tid 906, pid 906 (kworker/16:1) on cpu 16 at
cycle 416925425702833
  frame 0: 0xfffffff7002fc488 worker_enter_idle+0x1c8/0x2e8 (sp
0xfffffe00f9fbfe78)
  frame 1: 0xfffffff7002750c8 worker_thread+0x4c8/0x898 (sp 0xfffffe00f9fbfea0)
  frame 2: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe00f9fbff80)
  frame 3: 0xfffffff7000bab38 start_kernel_thread+0x18/0x20 (sp
0xfffffe00f9fbffe8)
Stack dump complete
Unable to handle kernel paging request
 at virtual address 0x00000000fffffff8, pc 0xfffffff700375f58

 Pid: 906, comm:         kworker/16:1, CPU: 16
 r0 : 0xfffffffffffffff8 r1 : 0x0000000000000000 r2 : 0xfffffe00f841c1b8
 r3 : 0x0000000000003459 r4 : 0x0000000000000001 r5 : 0x0000000000000000
 r6 : 0xfffffe00f9fb0028 r7 : 0x000001f4ff820000 r8 : 0xfffffe00f9fb0000
 r9 : 0x0000000000000000 r10: 0x0000000000000081 r11: 0xfffffe00f841be9c
 r12: 0xfffffff500103c68 r13: 0xfffffe00f9fbf488 r14: 0xfffffe00f9fbf4c8
 r15: 0xfffffe00f9fbf490 r16: 0xfffffe00f9fbf498 r17: 0xfffffe00f9fbf4a0
 r18: 0xfffffe00f841c5b0 r19: 0xfffffe00f9fbf4a8 r20: 0xfffffe00f841c0e8
 r21: 0xffffffff8420806c r22: 0x0000000000000020 r23: 0xfffffe0000a7b988
 r24: 0xfffffe00f841be94 r25: 0xfffffffffffffe00 r26: 0xfffffffffe0000a7
 r27: 0xfffffe00f9fbf440 r28: 0xfffffe00f9fbf438 r29: 0xfffffe00f9fbf448
 r30: 0x0000000000000010 r31: 0xfffffe00f841be80 r32: 0x00000000001a1174
 r33: 0x00000000001a1173 r34: 0xfffffe00f9fbf610 r35: 0x00000001f9fbf398
 r36: 0xfffffe401d9008c0 r37: 0xfffffe401d9008c0 r38: 0xfffffe401d9008c8
 r39: 0xfffffe0000a9c770 r40: 0xfffffe0000a9c750 r41: 0x0000000000000001
 r42: 0xfffffe401d900990 r43: 0xfffffff7003dd1b0 r44: 0xfffffe00f9fbf350
 r45: 0xfffffe0000b5865b r46: 0x0000000000000002 r47: 0xfffffe0000b58a50
 r48: 0xfffffff7003dfbe8 r49: 0xfffffe00f9fbf400 r50: 0xffffffff6c102009
 r51: 0x6639666266666538 r52: 0xfffffe00f9fbf790 tp : 0x000001f4ff820000
 sp : 0xfffffe00f9fbf430 lr : 0xfffffff700357fe8
 pc : 0xfffffff700375f58 ex1: 1     faultnum: 18

Starting stack dump of tid 906, pid 906 (kworker/16:1) on cpu 16 at
cycle 416925426066163
  frame 0: 0xfffffff700375f58 kthread_data+0x18/0x20 (sp 0xfffffe00f9fbf430)
  frame 1: 0xfffffff700357fe8 wq_worker_sleeping+0x28/0xf8 (sp
0xfffffe00f9fbf430)
  frame 2: 0xfffffff700021ab8 schedule+0xd00/0x1538 (sp 0xfffffe00f9fbf448)
  frame 3: 0xfffffff70041f950 do_exit+0x510/0x658 (sp 0xfffffe00f9fbf790)
  frame 4: 0xfffffff7000ade50 do_group_exit+0xc0/0x220 (sp 0xfffffe00f9fbf840)
  frame 5: 0xfffffff7001137a0 jit_bundle_gen+0xf20/0x27d8 (sp
0xfffffe00f9fbf878)
  frame 6: 0xfffffff70034e830 do_unaligned+0xe0/0x5b0 (sp 0xfffffe00f9fbfac8)
  frame 7: 0xfffffff700139af8 handle_interrupt+0x270/0x278 (sp
0xfffffe00f9fbfc00)
  <interrupt 17 while in kernel mode>
  frame 8: 0xfffffff7002fc488 worker_enter_idle+0x1c8/0x2e8 (sp
0xfffffe00f9fbfe78)
  frame 9: 0xfffffff7002750c8 worker_thread+0x4c8/0x898 (sp 0xfffffe00f9fbfea0)
  frame 10: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe00f9fbff80)
  frame 11: 0xfffffff7000bab38 start_kernel_thread+0x18/0x20 (sp
0xfffffe00f9fbffe8)
Stack dump complete
Fixing recursive fault but reboot is needed!

The first exception is platform specific and should be a hardware error:
fffffff7002fc480:       180906cfc0128d82        { addi r2, sp, 40 ;
addi r31, sp, 32 }
fffffff7002fc488:       87b886ca04218d95        { addi r21, sp, 24 ;
addi r20, sp, 16 ; ld lr, r2 }
While 'ld lr, r2' executed, r2 should be sp+40, but it value is 2.
I've analysis the execute
snap shot and:
1. r2 should be 2 before 'addi r2, sp, 40' executed.
2. r0's value is sp+40 when exception ocurred, but it shouldn't be
that value following
    executing flow in that function.
So it seems while 'addi r2, sp 40' be executed, what it really
executed is 'addi r0, sp, 40',
maybe the instruction was load with a bit reverted for memory error,
or cache error or
problem of CPU? I'm not sure since it never occurred again.

What I thought maybe a kernel bug is that second exception. I've
simulated it try to
generate a exception in kworker, and it occurred again. Then I checked
the code and
it's the execute flow I've described in the first mail cause that
problem. Then I checked
the newest kernel and it seems should have the same issue.
I only tested it on Gx platform from Tilera, but that second exception
should occur on
any platform if kworker got exception and can't be recovered.



On Thu, Nov 8, 2012 at 12:28 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Cyberman.
>
> On Sat, Nov 03, 2012 at 04:03:21PM +0800, Cyberman Wu wrote:
>> Recent days we got a exception in kernel thread [kworker/n:m], but
>> exception handler
>
> Can you please post kernel messages for the initial exception?
>
> Thanks.
>
> --
> tejun



-- 
Cyberman Wu
