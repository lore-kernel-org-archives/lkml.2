Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0JYPsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:48:30 -0400
Received: from canuck.infradead.org ([134.117.69.58]:34767 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0JYPs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:48:29 -0400
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <1288009103.15336.58.camel@twins>
References: <20101021110925.GA27219@elte.hu>
	 <20101022175845.GF6498@redhat.com> <20101022182433.GA24637@elte.hu>
	 <20101022183900.GG6498@redhat.com> <20101023200216.GA19324@elte.hu>
	 <1287881618.16971.657.camel@gandalf.stny.rr.com>
	 <20101024112540.GA21267@elte.hu> <20101025085927.GA11025@elte.hu>
	 <20101025093045.GA21997@elte.hu> <20101025114501.GA2000@elte.hu>
	 <20101025121059.GA3063@elte.hu>  <1288009103.15336.58.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 25 Oct 2010 17:47:52 +0200
Message-ID: <1288021672.15336.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



So I can reproduce this using the .config provided a few emails ago:


[   22.945481] Testing event hrtimer_expire_entry: 
[   22.950013] Symbol: __run_hrtimer @ c103d3c2 0x105
[   22.954988] Ideal-NOP: 0f 1f 44 00 00 
[   22.958840] Transform: c103d429 -> e9 03 00 00 00 
[   22.963723] Code: 55 57 56 53 89 c3 83 ec 08 89 54 24 04 8b 68 20 8b 7d 00 9c 58 8d 74 26 00 f6 c4 02 74 0f ba bd 0
4 00 00 b8 02 0f 36 c1 e8 0b 89 fe ff 0f 1f 44 00 00 eb 19 8b 35 b0 ad 40 c1 85 f6 74 0f 8b 46 04 89 da ff 16 83 c6 08
 83 3e 00 eb ef 89 d8 b9 02 00 00 00 89 ea 6a 00 e8 b7 fe ff ff 8b 43 1c 89 44 24 04 f0 fe 07 <0f> 1f 44 00 00 58 eb 1
d 8b 35 70 ad 40 c1 85 f6 74 13 8b 46 04 89 da 8b 4c 24 04 ff 16 83 c6 08 83 3e 00 eb eb 89 d8 ff 14 24 89 04 24 0f 1f
 44 00 00 eb 19 8b 35 90 ad 40 c1 85 f6 74 0f 8b 46 04 89 da ff 16 83 c6 08 83 3e 00 eb ef 89 f8 e8 56 04 28 00 83 3c 
24 00 74 13 83 7b 24 02 74 04 0f 0b eb fe 89 ea 89 d8 e8 a8 fe ff ff f6 43 24 02 75 1f 80 3d c8 8c 59 c1 01 74 16 ba d
9 04 00 00 b8 02 0f 36 c1 e8 46 88 fe ff c6 05 c8 8c 59 c1 01 83 63 24 fd 83 c4 08 5b 5e 5f 5d c3 
[   23.038297] Symbol: __run_hrtimer @ c103d3c2 0x105
[   23.043082] Ideal-NOP: 
[   23.044942] BUG: unable to handle kernel NULL pointer dereference at (null)
[   23.044944] IP: [<(null)>] (null)
[   23.044946] *pde = 00000000 
[   23.044948] Oops: 0000 [#1] SMP 
[   23.044950] last sysfs file: 
[   23.044951] Modules linked in:
[   23.044952] 
[   23.044954] Pid: 0, comm: kworker/0:1 Not tainted 2.6.36-tip-05833-g9db2fad-dirty #14 X8DTN/X8DTN
[   23.044957] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 2
[   23.044958] EIP is at 0x0
[   23.044960] EAX: f5906a94 EBX: f5906a94 ECX: 00010000 EDX: 00000092
[   23.044962] ESI: f4938e90 EDI: f5906a00 EBP: f5906a30 ESP: f54b1ec4
[   23.044964]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   23.044966] Process kworker/0:1 (pid: 0, ti=f54b0000 task=f543b3a0 task.ti=f54b0000)
[   23.044967] Stack:
[   23.044968]  c103d453 00000000 c104627d f54b1f0c 5459b2fd 00000005 ffffffff 7fffffff
[   23.044972]  c103d6e7 5459b2fd 00000005 5459b2fd 0000002c f5906a00 00000000 f5906a04
[   23.044975]  5459b2fd 00000005 5459b2fd 00000005 00000000 f5905dac 00000002 c141c3c8
[   23.044979] Call Trace:
[   23.044982]  [<c103d453>] ? __run_hrtimer+0x91/0x105
[   23.044984]  [<c104627d>] ? tick_sched_timer+0x0/0x1a1
[   23.044987]  [<c103d6e7>] ? hrtimer_interrupt+0x108/0x20a
[   23.044990]  [<c101244c>] ? smp_apic_timer_interrupt+0x66/0x75
[   23.044992]  [<c12be252>] ? apic_timer_interrupt+0x36/0x3c
[   23.044995]  [<c1007370>] ? mwait_idle+0x8d/0x9d
[   23.044998]  [<c10020f6>] ? cpu_idle+0x98/0xda
[   23.045000]  [<c144c13e>] ? start_secondary+0x200/0x205
[   23.045002] Code:  Bad EIP value.
[   23.045004] EIP: [<00000000>] 0x0 SS:ESP 0068:f54b1ec4
[   23.045006] CR2: 0000000000000000
[   23.045008] ---[ end trace 47e335b82ab98d21 ]---


Which using a bit of scrips/decodecode frobbing, yields:

[ warning,. very wide text ]

NOP'ed vs JMP'ed

   0:	55                   	push   %ebp                          55                   	push   %ebp                         
   1:	57                   	push   %edi                          57                   	push   %edi                            
   2:	56                   	push   %esi                          56                   	push   %esi
   3:	53                   	push   %ebx                          53                   	push   %ebx
   4:	89 c3                	mov    %eax,%ebx                     89 c3                	mov    %eax,%ebx
   6:	83 ec 08             	sub    $0x8,%esp                     83 ec 08             	sub    $0x8,%esp
   9:	89 54 24 04          	mov    %edx,0x4(%esp)                89 54 24 04          	mov    %edx,0x4(%esp)
   d:	8b 68 20             	mov    0x20(%eax),%ebp               8b 68 20             	mov    0x20(%eax),%ebp
  10:	8b 7d 00             	mov    0x0(%ebp),%edi                8b 7d 00             	mov    0x0(%ebp),%edi
  13:	9c                   	pushf                                9c                   	pushf  
  14:	58                   	pop    %eax                          58                   	pop    %eax
  15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi         8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  19:	f6 c4 02             	test   $0x2,%ah                      f6 c4 02             	test   $0x2,%ah
  1c:	74 0f                	je     0x2d                          74 0f                	je     0x2d
  1e:	ba bd 04 00 00       	mov    $0x4bd,%edx                   ba bd 04 00 00       	mov    $0x4bd,%edx
  23:	b8 02 0f 36 c1       	mov    $0xc1360f02,%eax              b8 02 0f 36 c1       	mov    $0xc1360f02,%eax
  28:	e8 0b 89 fe ff       	call   0xfffe8938                    e8 0b 89 fe ff       	call   0xfffe8938
  2d:	0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)              0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)
  32:	eb 19                	jmp    0x4d                          eb 19                	jmp    0x4d
  34:	8b 35 b0 ad 40 c1    	mov    0xc140adb0,%esi               8b 35 b0 ad 40 c1    	mov    0xc140adb0,%esi
  3a:	85 f6                	test   %esi,%esi                     85 f6                	test   %esi,%esi
  3c:	74 0f                	je     0x4d                          74 0f                	je     0x4d
  3e:	8b 46 04             	mov    0x4(%esi),%eax                8b 46 04             	mov    0x4(%esi),%eax
  41:	89 da                	mov    %ebx,%edx                     89 da                	mov    %ebx,%edx
  43:	ff 16                	call   *(%esi)                       ff 16                	call   *(%esi)
  45:	83 c6 08             	add    $0x8,%esi                     83 c6 08             	add    $0x8,%esi
  48:	83 3e 00             	cmpl   $0x0,(%esi)                   83 3e 00             	cmpl   $0x0,(%esi)
  4b:	eb ef                	jmp    0x3c                          eb ef                	jmp    0x3c
  4d:	89 d8                	mov    %ebx,%eax                     89 d8                	mov    %ebx,%eax
  4f:	b9 02 00 00 00       	mov    $0x2,%ecx                     b9 02 00 00 00       	mov    $0x2,%ecx
  54:	89 ea                	mov    %ebp,%edx                     89 ea                	mov    %ebp,%edx
  56:	6a 00                	push   $0x0                          6a 00                	push   $0x0
  58:	e8 b7 fe ff ff       	call   0xffffff14                    e8 b7 fe ff ff       	call   0xffffff14
  5d:	8b 43 1c             	mov    0x1c(%ebx),%eax               8b 43 1c             	mov    0x1c(%ebx),%eax
  60:	89 44 24 04          	mov    %eax,0x4(%esp)                89 44 24 04          	mov    %eax,0x4(%esp)
  64:	f0 fe 07             	lock incb (%edi)                     f0 fe 07             	lock incb (%edi)
  67:*	0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)              e9 03 00 00 00       	jmp    0x6f              <--- PATCHED INSN
  6c:	58                   	pop    %eax                          58                   	pop    %eax
  6d:	eb 1d                	jmp    0x8c                          eb 1d                	jmp    0x8c
  6f:	8b 35 70 ad 40 c1    	mov    0xc140ad70,%esi               8b 35 70 ad 40 c1    	mov    0xc140ad70,%esi
  75:	85 f6                	test   %esi,%esi                     85 f6                	test   %esi,%esi
  77:	74 13                	je     0x8c                          74 13                	je     0x8c
  79:	8b 46 04             	mov    0x4(%esi),%eax                8b 46 04             	mov    0x4(%esi),%eax
  7c:	89 da                	mov    %ebx,%edx                     89 da                	mov    %ebx,%edx
  7e:	8b 4c 24 04          	mov    0x4(%esp),%ecx                8b 4c 24 04          	mov    0x4(%esp),%ecx
  82:	ff 16                	call   *(%esi)                       ff 16                	call   *(%esi)
  84:	83 c6 08             	add    $0x8,%esi                     83 c6 08             	add    $0x8,%esi
  87:	83 3e 00             	cmpl   $0x0,(%esi)                   83 3e 00             	cmpl   $0x0,(%esi)
  8a:	eb eb                	jmp    0x77                          eb eb                	jmp    0x77
  8c:	89 d8                	mov    %ebx,%eax                     89 d8                	mov    %ebx,%eax
  8e:	ff 14 24             	call   *(%esp)                       ff 14 24             	call   *(%esp)
  91:	89 04 24             	mov    %eax,(%esp)                   89 04 24             	mov    %eax,(%esp)
  94:	0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)              0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)
  99:	eb 19                	jmp    0xb4                          eb 19                	jmp    0xb4
  9b:	8b 35 90 ad 40 c1    	mov    0xc140ad90,%esi               8b 35 90 ad 40 c1    	mov    0xc140ad90,%esi
  a1:	85 f6                	test   %esi,%esi                     85 f6                	test   %esi,%esi
  a3:	74 0f                	je     0xb4                          74 0f                	je     0xb4
  a5:	8b 46 04             	mov    0x4(%esi),%eax                8b 46 04             	mov    0x4(%esi),%eax
  a8:	89 da                	mov    %ebx,%edx                     89 da                	mov    %ebx,%edx
  aa:	ff 16                	call   *(%esi)                       ff 16                	call   *(%esi)
  ac:	83 c6 08             	add    $0x8,%esi                     83 c6 08             	add    $0x8,%esi
  af:	83 3e 00             	cmpl   $0x0,(%esi)                   83 3e 00             	cmpl   $0x0,(%esi)
  b2:	eb ef                	jmp    0xa3                          eb ef                	jmp    0xa3
  b4:	89 f8                	mov    %edi,%eax                     89 f8                	mov    %edi,%eax
  b6:	e8 56 04 28 00       	call   0x280511                      e8 56 04 28 00       	call   0x280511
  bb:	83 3c 24 00          	cmpl   $0x0,(%esp)                   83 3c 24 00          	cmpl   $0x0,(%esp)
  bf:	74 13                	je     0xd4                          74 13                	je     0xd4
  c1:	83 7b 24 02          	cmpl   $0x2,0x24(%ebx)               83 7b 24 02          	cmpl   $0x2,0x24(%ebx)
  c5:	74 04                	je     0xcb                          74 04                	je     0xcb
  c7:	0f 0b                	ud2                                  0f 0b                	ud2    
  c9:	eb fe                	jmp    0xc9                          eb fe                	jmp    0xc9
  cb:	89 ea                	mov    %ebp,%edx                     89 ea                	mov    %ebp,%edx
  cd:	89 d8                	mov    %ebx,%eax                     89 d8                	mov    %ebx,%eax
  cf:	e8 a8 fe ff ff       	call   0xffffff7c                    e8 a8 fe ff ff       	call   0xffffff7c
  d4:	f6 43 24 02          	testb  $0x2,0x24(%ebx)               f6 43 24 02          	testb  $0x2,0x24(%ebx)
  d8:	75 1f                	jne    0xf9                          75 1f                	jne    0xf9
  da:	80 3d c8 8c 59 c1 01 	cmpb   $0x1,0xc1598cc8               80 3d c8 8c 59 c1 01 	cmpb   $0x1,0xc1598cc8
  e1:	74 16                	je     0xf9                          74 16                	je     0xf9
  e3:	ba d9 04 00 00       	mov    $0x4d9,%edx                   ba d9 04 00 00       	mov    $0x4d9,%edx
  e8:	b8 02 0f 36 c1       	mov    $0xc1360f02,%eax              b8 02 0f 36 c1       	mov    $0xc1360f02,%eax
  ed:	e8 46 88 fe ff       	call   0xfffe8938                    e8 46 88 fe ff       	call   0xfffe8938
  f2:	c6 05 c8 8c 59 c1 01 	movb   $0x1,0xc1598cc8               c6 05 c8 8c 59 c1 01 	movb   $0x1,0xc1598cc8
  f9:	83 63 24 fd          	andl   $0xfffffffd,0x24(%ebx)        83 63 24 fd          	andl   $0xfffffffd,0x24(%ebx)
  fd:	83 c4 08             	add    $0x8,%esp                     83 c4 08             	add    $0x8,%esp
 100:	5b                   	pop    %ebx                          5b                   	pop    %ebx
 101:	5e                   	pop    %esi                          5e                   	pop    %esi
 102:	5f                   	pop    %edi                          5f                   	pop    %edi
 103:	5d                   	pop    %ebp                          5d                   	pop    %ebp
 104:	c3                   	ret                                  c3                   	ret    


The compiled version looks like:


00000442 <__run_hrtimer>:
 442:   55                      push   %ebp
 443:   57                      push   %edi
 444:   56                      push   %esi
 445:   53                      push   %ebx
 446:   89 c3                   mov    %eax,%ebx
 448:   83 ec 08                sub    $0x8,%esp
 44b:   89 54 24 04             mov    %edx,0x4(%esp)
 44f:   8b 68 20                mov    0x20(%eax),%ebp
 452:   8b 7d 00                mov    0x0(%ebp),%edi
 455:   ff 15 00 00 00 00       call   *0x0
 45b:   f6 c4 02                test   $0x2,%ah
 45e:   74 0f                   je     46f <__run_hrtimer+0x2d>
 460:   ba bd 04 00 00          mov    $0x4bd,%edx
 465:   b8 07 00 00 00          mov    $0x7,%eax
 46a:   e8 fc ff ff ff          call   46b <__run_hrtimer+0x29>
 46f:   e9 00 00 00 00          jmp    474 <__run_hrtimer+0x32>
 474:   eb 19                   jmp    48f <__run_hrtimer+0x4d>
 476:   8b 35 10 00 00 00       mov    0x10,%esi
 47c:   85 f6                   test   %esi,%esi
 47e:   74 0f                   je     48f <__run_hrtimer+0x4d>
 480:   8b 46 04                mov    0x4(%esi),%eax
 483:   89 da                   mov    %ebx,%edx
 485:   ff 16                   call   *(%esi)
 487:   83 c6 08                add    $0x8,%esi
 48a:   83 3e 00                cmpl   $0x0,(%esi)
 48d:   eb ef                   jmp    47e <__run_hrtimer+0x3c>
 48f:   89 d8                   mov    %ebx,%eax
 491:   b9 02 00 00 00          mov    $0x2,%ecx
 496:   89 ea                   mov    %ebp,%edx
 498:   6a 00                   push   $0x0
 49a:   e8 b7 fe ff ff          call   356 <__remove_hrtimer>
 49f:   8b 43 1c                mov    0x1c(%ebx),%eax
 4a2:   89 44 24 04             mov    %eax,0x4(%esp)
 4a6:   f0 fe 07                lock incb (%edi)
 4a9:   e9 00 00 00 00          jmp    4ae <__run_hrtimer+0x6c>
 4ae:   58                      pop    %eax
 4af:   eb 1d                   jmp    4ce <__run_hrtimer+0x8c>
 4b1:   8b 35 10 00 00 00       mov    0x10,%esi
 4b7:   85 f6                   test   %esi,%esi
 4b9:   74 13                   je     4ce <__run_hrtimer+0x8c>
 4bb:   8b 46 04                mov    0x4(%esi),%eax
 4be:   89 da                   mov    %ebx,%edx
 4c0:   8b 4c 24 04             mov    0x4(%esp),%ecx
 4c4:   ff 16                   call   *(%esi)
 4c6:   83 c6 08                add    $0x8,%esi
 4c9:   83 3e 00                cmpl   $0x0,(%esi)
 4cc:   eb eb                   jmp    4b9 <__run_hrtimer+0x77>
 4ce:   89 d8                   mov    %ebx,%eax
 4d0:   ff 14 24                call   *(%esp)
 4d3:   89 04 24                mov    %eax,(%esp)
 4d6:   e9 00 00 00 00          jmp    4db <__run_hrtimer+0x99>
 4db:   eb 19                   jmp    4f6 <__run_hrtimer+0xb4>
 4dd:   8b 35 10 00 00 00       mov    0x10,%esi
 4e3:   85 f6                   test   %esi,%esi
 4e5:   74 0f                   je     4f6 <__run_hrtimer+0xb4>
 4e7:   8b 46 04                mov    0x4(%esi),%eax
 4ea:   89 da                   mov    %ebx,%edx
 4ec:   ff 16                   call   *(%esi)
 4ee:   83 c6 08                add    $0x8,%esi
 4f1:   83 3e 00                cmpl   $0x0,(%esi)
 4f4:   eb ef                   jmp    4e5 <__run_hrtimer+0xa3>
 4f6:   89 f8                   mov    %edi,%eax
 4f8:   e8 fc ff ff ff          call   4f9 <__run_hrtimer+0xb7>
 4fd:   83 3c 24 00             cmpl   $0x0,(%esp)
 501:   74 13                   je     516 <__run_hrtimer+0xd4>
 503:   83 7b 24 02             cmpl   $0x2,0x24(%ebx)
 507:   74 04                   je     50d <__run_hrtimer+0xcb>
 509:   0f 0b                   ud2a   
 50b:   eb fe                   jmp    50b <__run_hrtimer+0xc9>
 50d:   89 ea                   mov    %ebp,%edx
 50f:   89 d8                   mov    %ebx,%eax
 511:   e8 a8 fe ff ff          call   3be <enqueue_hrtimer>
 516:   f6 43 24 02             testb  $0x2,0x24(%ebx)
 51a:   75 1f                   jne    53b <__run_hrtimer+0xf9>
 51c:   80 3d 00 00 00 00 01    cmpb   $0x1,0x0
 523:   74 16                   je     53b <__run_hrtimer+0xf9>
 525:   ba d9 04 00 00          mov    $0x4d9,%edx
 52a:   b8 07 00 00 00          mov    $0x7,%eax
 52f:   e8 fc ff ff ff          call   530 <__run_hrtimer+0xee>
 534:   c6 05 00 00 00 00 01    movb   $0x1,0x0
 53b:   83 63 24 fd             andl   $0xfffffffd,0x24(%ebx)
 53f:   83 c4 08                add    $0x8,%esp
 542:   5b                      pop    %ebx
 543:   5e                      pop    %esi
 544:   5f                      pop    %edi
 545:   5d                      pop    %ebp
 546:   c3                      ret 


Which is different due to PV_OPS alternatives.. will now start trying to
untangle the actual execution of all three code fragments...



---
 arch/x86/kernel/jump_label.c |   47 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 961b6b3..cd3cbca 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/jhash.h>
 #include <linux/cpu.h>
+#include <linux/kallsyms.h>
 #include <asm/kprobes.h>
 #include <asm/alternative.h>
 
@@ -24,6 +25,50 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
+static void print_sym(void *ptr, u8 *code, int len)
+{
+	unsigned long addr = (unsigned long)ptr;
+	unsigned long size, offset;
+	char buf[KSYM_NAME_LEN];
+	char *modname;
+	u8 *ip, c;
+	int i;
+
+	kallsyms_lookup(addr, &size, &offset, &modname, buf);
+
+	if (strcmp(buf, "__run_hrtimer"))
+		return;
+
+	ip = ptr - offset;
+
+	printk(KERN_ERR "Symbol: %s @ %p 0x%lx\n", buf, ip, size);
+
+	printk(KERN_ERR "Ideal-NOP: ");
+	for (i = 0; i < len; i++) {
+		printk(KERN_CONT "%02x ", (u8)ideal_nop5[i]);
+	}
+	printk(KERN_CONT "\n");
+
+	printk(KERN_ERR "Transform: %p -> ", ptr);
+	for (i = 0; i < len; i++) {
+		printk(KERN_CONT "%02x ", (u8)code[i]);
+	}
+	printk(KERN_CONT "\n");
+
+	printk(KERN_ERR "Code: ");
+	for (i = 0; i < size; i++, ip++) {
+		if (probe_kernel_address(ip, c)) {
+			printk(KERN_CONT "Fail!");
+			break;
+		}
+		if (ip == (u8 *)ptr)
+			printk(KERN_CONT "<%02x> ", c);
+		else
+			printk(KERN_CONT "%02x ", c);
+	}
+	printk(KERN_CONT "\n");
+}
+
 void arch_jump_label_transform(struct jump_entry *entry,
 			       enum jump_label_type type)
 {
@@ -37,7 +82,9 @@ void arch_jump_label_transform(struct jump_entry *entry,
 		memcpy(&code, ideal_nop5, JUMP_LABEL_NOP_SIZE);
 	get_online_cpus();
 	mutex_lock(&text_mutex);
+	print_sym((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
 	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	print_sym((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }

