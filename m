Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab0JYQIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:08:00 -0400
Received: from canuck.infradead.org ([134.117.69.58]:36074 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab0JYQH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:07:59 -0400
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
In-Reply-To: <1288021672.15336.63.camel@twins>
References: <20101021110925.GA27219@elte.hu>
	 <20101022175845.GF6498@redhat.com> <20101022182433.GA24637@elte.hu>
	 <20101022183900.GG6498@redhat.com> <20101023200216.GA19324@elte.hu>
	 <1287881618.16971.657.camel@gandalf.stny.rr.com>
	 <20101024112540.GA21267@elte.hu> <20101025085927.GA11025@elte.hu>
	 <20101025093045.GA21997@elte.hu> <20101025114501.GA2000@elte.hu>
	 <20101025121059.GA3063@elte.hu>  <1288009103.15336.58.camel@twins>
	 <1288021672.15336.63.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 25 Oct 2010 18:07:26 +0200
Message-ID: <1288022846.15336.65.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 17:47 +0200, Peter Zijlstra wrote:
>    0:   55                      push   %ebp                          55                         push   %ebp                         
>    1:   57                      push   %edi                          57                         push   %edi                            
>    2:   56                      push   %esi                          56                         push   %esi
>    3:   53                      push   %ebx                          53                         push   %ebx
>    4:   89 c3                   mov    %eax,%ebx                     89 c3                      mov    %eax,%ebx
>    6:   83 ec 08                sub    $0x8,%esp                     83 ec 08                   sub    $0x8,%esp
>    9:   89 54 24 04             mov    %edx,0x4(%esp)                89 54 24 04                mov    %edx,0x4(%esp)
>    d:   8b 68 20                mov    0x20(%eax),%ebp               8b 68 20                   mov    0x20(%eax),%ebp
>   10:   8b 7d 00                mov    0x0(%ebp),%edi                8b 7d 00                   mov    0x0(%ebp),%edi
>   13:   9c                      pushf                                9c                         pushf  
>   14:   58                      pop    %eax                          58                         pop    %eax
>   15:   8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi         8d 74 26 00                lea    0x0(%esi,%eiz,1),%esi
>   19:   f6 c4 02                test   $0x2,%ah                      f6 c4 02                   test   $0x2,%ah
>   1c:   74 0f                   je     0x2d                          74 0f                      je     0x2d
>   1e:   ba bd 04 00 00          mov    $0x4bd,%edx                   ba bd 04 00 00             mov    $0x4bd,%edx
>   23:   b8 02 0f 36 c1          mov    $0xc1360f02,%eax              b8 02 0f 36 c1             mov    $0xc1360f02,%eax
>   28:   e8 0b 89 fe ff          call   0xfffe8938                    e8 0b 89 fe ff             call   0xfffe8938
>   2d:   0f 1f 44 00 00          nopl   0x0(%eax,%eax,1)              0f 1f 44 00 00             nopl   0x0(%eax,%eax,1)
>   32:   eb 19                   jmp    0x4d                          eb 19                      jmp    0x4d
>   34:   8b 35 b0 ad 40 c1       mov    0xc140adb0,%esi               8b 35 b0 ad 40 c1          mov    0xc140adb0,%esi
>   3a:   85 f6                   test   %esi,%esi                     85 f6                      test   %esi,%esi
>   3c:   74 0f                   je     0x4d                          74 0f                      je     0x4d
>   3e:   8b 46 04                mov    0x4(%esi),%eax                8b 46 04                   mov    0x4(%esi),%eax
>   41:   89 da                   mov    %ebx,%edx                     89 da                      mov    %ebx,%edx
>   43:   ff 16                   call   *(%esi)                       ff 16                      call   *(%esi)
>   45:   83 c6 08                add    $0x8,%esi                     83 c6 08                   add    $0x8,%esi
>   48:   83 3e 00                cmpl   $0x0,(%esi)                   83 3e 00                   cmpl   $0x0,(%esi)
>   4b:   eb ef                   jmp    0x3c                          eb ef                      jmp    0x3c
>   4d:   89 d8                   mov    %ebx,%eax                     89 d8                      mov    %ebx,%eax
>   4f:   b9 02 00 00 00          mov    $0x2,%ecx                     b9 02 00 00 00             mov    $0x2,%ecx
>   54:   89 ea                   mov    %ebp,%edx                     89 ea                      mov    %ebp,%edx
>   56:   6a 00                   push   $0x0                          6a 00                      push   $0x0
>   58:   e8 b7 fe ff ff          call   0xffffff14                    e8 b7 fe ff ff             call   0xffffff14
>   5d:   8b 43 1c                mov    0x1c(%ebx),%eax               8b 43 1c                   mov    0x1c(%ebx),%eax
>   60:   89 44 24 04             mov    %eax,0x4(%esp)                89 44 24 04                mov    %eax,0x4(%esp)
>   64:   f0 fe 07                lock incb (%edi)                     f0 fe 07                   lock incb (%edi)
>   67:*  0f 1f 44 00 00          nopl   0x0(%eax,%eax,1)              e9 03 00 00 00             jmp    0x6f              <--- PATCHED INSN
>   6c:   58                      pop    %eax                          58                         pop    %eax
>   6d:   eb 1d                   jmp    0x8c                          eb 1d                      jmp    0x8c
>   6f:   8b 35 70 ad 40 c1       mov    0xc140ad70,%esi               8b 35 70 ad 40 c1          mov    0xc140ad70,%esi
>   75:   85 f6                   test   %esi,%esi                     85 f6                      test   %esi,%esi
>   77:   74 13                   je     0x8c                          74 13                      je     0x8c
>   79:   8b 46 04                mov    0x4(%esi),%eax                8b 46 04                   mov    0x4(%esi),%eax
>   7c:   89 da                   mov    %ebx,%edx                     89 da                      mov    %ebx,%edx
>   7e:   8b 4c 24 04             mov    0x4(%esp),%ecx                8b 4c 24 04                mov    0x4(%esp),%ecx
>   82:   ff 16                   call   *(%esi)                       ff 16                      call   *(%esi)
>   84:   83 c6 08                add    $0x8,%esi                     83 c6 08                   add    $0x8,%esi
>   87:   83 3e 00                cmpl   $0x0,(%esi)                   83 3e 00                   cmpl   $0x0,(%esi)
>   8a:   eb eb                   jmp    0x77                          eb eb                      jmp    0x77
>   8c:   89 d8                   mov    %ebx,%eax                     89 d8                      mov    %ebx,%eax
>   8e:   ff 14 24                call   *(%esp)                       ff 14 24                   call   *(%esp)
>   91:   89 04 24                mov    %eax,(%esp)                   89 04 24                   mov    %eax,(%esp)

Is it me, or is this the first site where %esp is loaded with a value?,
which is _after_ the call that goes *bang*!

>   94:   0f 1f 44 00 00          nopl   0x0(%eax,%eax,1)              0f 1f 44 00 00             nopl   0x0(%eax,%eax,1)
>   99:   eb 19                   jmp    0xb4                          eb 19                      jmp    0xb4
>   9b:   8b 35 90 ad 40 c1       mov    0xc140ad90,%esi               8b 35 90 ad 40 c1          mov    0xc140ad90,%esi
>   a1:   85 f6                   test   %esi,%esi                     85 f6                      test   %esi,%esi
>   a3:   74 0f                   je     0xb4                          74 0f                      je     0xb4
>   a5:   8b 46 04                mov    0x4(%esi),%eax                8b 46 04                   mov    0x4(%esi),%eax
>   a8:   89 da                   mov    %ebx,%edx                     89 da                      mov    %ebx,%edx
>   aa:   ff 16                   call   *(%esi)                       ff 16                      call   *(%esi)
>   ac:   83 c6 08                add    $0x8,%esi                     83 c6 08                   add    $0x8,%esi
>   af:   83 3e 00                cmpl   $0x0,(%esi)                   83 3e 00                   cmpl   $0x0,(%esi)
>   b2:   eb ef                   jmp    0xa3                          eb ef                      jmp    0xa3
>   b4:   89 f8                   mov    %edi,%eax                     89 f8                      mov    %edi,%eax
>   b6:   e8 56 04 28 00          call   0x280511                      e8 56 04 28 00             call   0x280511
>   bb:   83 3c 24 00             cmpl   $0x0,(%esp)                   83 3c 24 00                cmpl   $0x0,(%esp)
>   bf:   74 13                   je     0xd4                          74 13                      je     0xd4
>   c1:   83 7b 24 02             cmpl   $0x2,0x24(%ebx)               83 7b 24 02                cmpl   $0x2,0x24(%ebx)
>   c5:   74 04                   je     0xcb                          74 04                      je     0xcb
>   c7:   0f 0b                   ud2                                  0f 0b                      ud2    
>   c9:   eb fe                   jmp    0xc9                          eb fe                      jmp    0xc9
>   cb:   89 ea                   mov    %ebp,%edx                     89 ea                      mov    %ebp,%edx
>   cd:   89 d8                   mov    %ebx,%eax                     89 d8                      mov    %ebx,%eax
>   cf:   e8 a8 fe ff ff          call   0xffffff7c                    e8 a8 fe ff ff             call   0xffffff7c
>   d4:   f6 43 24 02             testb  $0x2,0x24(%ebx)               f6 43 24 02                testb  $0x2,0x24(%ebx)
>   d8:   75 1f                   jne    0xf9                          75 1f                      jne    0xf9
>   da:   80 3d c8 8c 59 c1 01    cmpb   $0x1,0xc1598cc8               80 3d c8 8c 59 c1 01       cmpb   $0x1,0xc1598cc8
>   e1:   74 16                   je     0xf9                          74 16                      je     0xf9
>   e3:   ba d9 04 00 00          mov    $0x4d9,%edx                   ba d9 04 00 00             mov    $0x4d9,%edx
>   e8:   b8 02 0f 36 c1          mov    $0xc1360f02,%eax              b8 02 0f 36 c1             mov    $0xc1360f02,%eax
>   ed:   e8 46 88 fe ff          call   0xfffe8938                    e8 46 88 fe ff             call   0xfffe8938
>   f2:   c6 05 c8 8c 59 c1 01    movb   $0x1,0xc1598cc8               c6 05 c8 8c 59 c1 01       movb   $0x1,0xc1598cc8
>   f9:   83 63 24 fd             andl   $0xfffffffd,0x24(%ebx)        83 63 24 fd                andl   $0xfffffffd,0x24(%ebx)
>   fd:   83 c4 08                add    $0x8,%esp                     83 c4 08                   add    $0x8,%esp
>  100:   5b                      pop    %ebx                          5b                         pop    %ebx
>  101:   5e                      pop    %esi                          5e                         pop    %esi
>  102:   5f                      pop    %edi                          5f                         pop    %edi
>  103:   5d                      pop    %ebp                          5d                         pop    %ebp
>  104:   c3                      ret                                  c3                         ret    
