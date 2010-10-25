Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0JYQJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:09:41 -0400
Received: from fep19.mx.upcmail.net ([62.179.121.39]:56364 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab0JYQJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:09:39 -0400
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <20101025155541.GA2884@redhat.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
	 <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu>
	 <20101020164324.GC7348@redhat.com> <20101020183329.GA12666@elte.hu>
	 <20101021110925.GA27219@elte.hu> <20101022175845.GF6498@redhat.com>
	 <20101022182433.GA24637@elte.hu> <20101022183900.GG6498@redhat.com>
	 <20101023200216.GA19324@elte.hu>  <20101025155541.GA2884@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 18:09:25 +0200
Message-ID: <1288022965.15336.68.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=XCVXOBqlCPU5N10w5kBzDuedWCKZPpIJSEs1endkdVI= c=1 sm=0 a=LuwKl7ggZIAA:10 a=IkcTkHD0fZMA:10 a=s7qDZAmBq_FmnZoE-AUA:9 a=jL2xicNNtDfLtH_jUDoA:7 a=fxc2Gn2VKGAfVH1dsX7LeaV21x8A:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 11:55 -0400, Jason Baron wrote:

> but it would be
> interesting to test a 4.5 version in the failure cases - I will look at
> that shortly. 

4.5.1 explodes in a very similar and very reproducable manner for me:

[   22.660537] Testing event hrtimer_expire_entry: 
[   22.665071] Symbol: __run_hrtimer @ c103bfc5 0x103
[   22.670061] Ideal-NOP: 0f 1f 44 00 00 
[   22.673907] Transform: c103c02c -> e9 03 00 00 00 
[   22.678793] Code: 55 57 56 53 89 c3 83 ec 08 8b 68 20 89 54 24 04 8b 7d 00 9c 58 8d 74 26 00 f6 c4 02 74 0f ba bd 04 00 00 b8 0b 8e 35 c1 e8 e0 94 fe ff 0f 1f 44 00 00 eb 19 8b 35 f0 2c 40 c1 85 f6 74 0f 8b 46 04 89 da ff 16 83 c6 08 83 3e 00 eb ef 89 d8 b9 02 00 00 00 89 ea 6a 00 e8 b5 fe ff ff 8b 43 1c 89 44 24 04 f0 fe 07 <0f> 1f 44 00 00 59 eb 1d 8b 35 b0 2c 40 c1 85 f6 74 13 8b 46 04 89 da 8b 4c 24 04 ff 16 83 c6 08 83 3e 00 eb eb 89 d8 ff 14 24 89 04 24 0f 1f 44 00 00 eb 19 8b 35 d0 2c 40 c1 85 f6 74 0f 8b 46 04 89 da ff 16 83 c6 08 83 3e 00 eb ef 89 f8 e8 ab 7c 27 00 83 3c 24 00 74 11 83 7b 24 02 74 02 0f 0b 89 ea 89 d8 e8 a8 fe ff ff f6 43 24 02 75 1f 80 3d d4 ec 58 c1 01 74 16 ba d9 04 00 00 b8 0b 8e 35 c1 e8 1d 94 fe ff c6 05 d4 ec 58 c1 01 83 63 24 fd 83 c4 08 5b 5e 5f 5d c3 
[   22.752911] Symbol: __run_hrtimer @ c103bfc5 0x103
[   22.757695] Ideal-NOP: 0f 
[   22.760000] BUG: unable to handle kernel NULL pointer dereference at (null)
[   22.760002] IP: [<(null)>] (null)
[   22.760005] *pde = 00000000 
[   22.760006] Oops: 0000 [#1] SMP 
[   22.760008] last sysfs file: 
[   22.760010] Modules linked in:
[   22.760011] 
[   22.760013] Pid: 0, comm: swapper Not tainted 2.6.36-tip-05833-g9db2fad-dirty #15 X8DTN/X8DTN
[   22.760015] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 0
[   22.760017] EIP is at 0x0
[   22.760019] EAX: f5806a94 EBX: f5806a94 ECX: 00010000 EDX: 00000092
[   22.760021] ESI: f4859e90 EDI: f5806a00 EBP: f5806a30 ESP: c13d3f24
[   22.760023]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   22.760025] Process swapper (pid: 0, ti=c13d2000 task=c13d6f20 task.ti=c13d2000)
[   22.760025] Stack:
[   22.760025]  c103c056 00000000 c1044ac0 c13d3f60 ffffffff 7fffffff 0000002c f5806a04
[   22.760025]  c103c7d7 f5806a00 00000000 4c9a11f7 00000005 4c9a11f7 00000005 4c9a11f7
[   22.760025]  00000005 00000000 f5805dac 00000000 c1414308 c1011b20 c13d2000 00000000
[   22.760025] Call Trace:
[   22.760025]  [<c103c056>] ? __run_hrtimer+0x91/0x103
[   22.760025]  [<c1044ac0>] ? tick_sched_timer+0x0/0x1a1
[   22.760025]  [<c103c7d7>] ? hrtimer_interrupt+0xd6/0x1b4
[   22.760025]  [<c1011b20>] ? smp_apic_timer_interrupt+0x66/0x75
[   22.760025]  [<c12b46aa>] ? apic_timer_interrupt+0x36/0x3c
[   22.760025]  [<c10070d1>] ? mwait_idle+0x8d/0x9d
[   22.760025]  [<c1001c20>] ? cpu_idle+0x8a/0xcb
[   22.760025]  [<c14166c8>] ? start_kernel+0x2d5/0x2da
[   22.760025] Code:  Bad EIP value.
[   22.760025] EIP: [<00000000>] 0x0 SS:ESP 0068:c13d3f24
[   22.760025] CR2: 0000000000000000
[   22.760025] ---[ end trace b2ee13bd16d5c929 ]---


All code
========
   0:	55                   	push   %ebp
   1:	57                   	push   %edi
   2:	56                   	push   %esi
   3:	53                   	push   %ebx
   4:	89 c3                	mov    %eax,%ebx
   6:	83 ec 08             	sub    $0x8,%esp
   9:	8b 68 20             	mov    0x20(%eax),%ebp
   c:	89 54 24 04          	mov    %edx,0x4(%esp)
  10:	8b 7d 00             	mov    0x0(%ebp),%edi
  13:	9c                   	pushf  
  14:	58                   	pop    %eax
  15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  19:	f6 c4 02             	test   $0x2,%ah
  1c:	74 0f                	je     0x2d
  1e:	ba bd 04 00 00       	mov    $0x4bd,%edx
  23:	b8 0b 8e 35 c1       	mov    $0xc1358e0b,%eax
  28:	e8 e0 94 fe ff       	call   0xfffe950d
  2d: 	0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)  
  32:	eb 19                	jmp    0x4d
  34:	8b 35 f0 2c 40 c1    	mov    0xc1402cf0,%esi
  3a:	85 f6                	test   %esi,%esi
  3c:	74 0f                	je     0x4d
  3e:	8b 46 04             	mov    0x4(%esi),%eax
  41:	89 da                	mov    %ebx,%edx
  43:	ff 16                	call   *(%esi)
  45:	83 c6 08             	add    $0x8,%esi
  48:	83 3e 00             	cmpl   $0x0,(%esi)
  4b:	eb ef                	jmp    0x3c
  4d:	89 d8                	mov    %ebx,%eax
  4f:	b9 02 00 00 00       	mov    $0x2,%ecx
  54:	89 ea                	mov    %ebp,%edx
  56:	6a 00                	push   $0x0
  58:	e8 b5 fe ff ff       	call   0xffffff12
  5d:	8b 43 1c             	mov    0x1c(%ebx),%eax
  60:	89 44 24 04          	mov    %eax,0x4(%esp)
  64:	f0 fe 07             	lock incb (%edi)
  67:*	0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)     <-- trapping instruction
  6c:	59                   	pop    %ecx
  6d:	eb 1d                	jmp    0x8c
  6f:	8b 35 b0 2c 40 c1    	mov    0xc1402cb0,%esi
  75:	85 f6                	test   %esi,%esi
  77:	74 13                	je     0x8c
  79:	8b 46 04             	mov    0x4(%esi),%eax
  7c:	89 da                	mov    %ebx,%edx
  7e:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  82:	ff 16                	call   *(%esi)
  84:	83 c6 08             	add    $0x8,%esi
  87:	83 3e 00             	cmpl   $0x0,(%esi)
  8a:	eb eb                	jmp    0x77
  8c:	89 d8                	mov    %ebx,%eax
  8e:	ff 14 24             	call   *(%esp)
  91:	89 04 24             	mov    %eax,(%esp)
  94: 	0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)   
  99:	eb 19                	jmp    0xb4
  9b:	8b 35 d0 2c 40 c1    	mov    0xc1402cd0,%esi
  a1:	85 f6                	test   %esi,%esi
  a3:	74 0f                	je     0xb4
  a5:	8b 46 04             	mov    0x4(%esi),%eax
  a8:	89 da                	mov    %ebx,%edx
  aa:	ff 16                	call   *(%esi)
  ac:	83 c6 08             	add    $0x8,%esi
  af:	83 3e 00             	cmpl   $0x0,(%esi)
  b2:	eb ef                	jmp    0xa3
  b4:	89 f8                	mov    %edi,%eax
  b6:	e8 ab 7c 27 00       	call   0x277d66
  bb:	83 3c 24 00          	cmpl   $0x0,(%esp)
  bf:	74 11                	je     0xd2
  c1:	83 7b 24 02          	cmpl   $0x2,0x24(%ebx)
  c5:	74 02                	je     0xc9
  c7:	0f 0b                	ud2    
  c9:	89 ea                	mov    %ebp,%edx
  cb:	89 d8                	mov    %ebx,%eax
  cd:	e8 a8 fe ff ff       	call   0xffffff7a
  d2:	f6 43 24 02          	testb  $0x2,0x24(%ebx)
  d6:	75 1f                	jne    0xf7
  d8:	80 3d d4 ec 58 c1 01 	cmpb   $0x1,0xc158ecd4
  df:	74 16                	je     0xf7
  e1:	ba d9 04 00 00       	mov    $0x4d9,%edx
  e6:	b8 0b 8e 35 c1       	mov    $0xc1358e0b,%eax
  eb:	e8 1d 94 fe ff       	call   0xfffe950d
  f0:	c6 05 d4 ec 58 c1 01 	movb   $0x1,0xc158ecd4
  f7:	83 63 24 fd          	andl   $0xfffffffd,0x24(%ebx)
  fb:	83 c4 08             	add    $0x8,%esp
  fe:	5b                   	pop    %ebx
  ff:	5e                   	pop    %esi
 100:	5f                   	pop    %edi
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    


