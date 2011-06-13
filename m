Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1FMPGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:06:50 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35197 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab1FMPGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:06:48 -0400
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, rostedt <rostedt@goodmis.org>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1307723232.3941.178.camel@twins>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307717156.3941.169.camel@twins>
	 <1307720081.17297.6.camel@atheurer-w510>  <1307723232.3941.178.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 10:06:54 -0500
Message-ID: <1307977614.17297.12.camel@atheurer-w510>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 18:27 +0200, Peter Zijlstra wrote:
> On Fri, 2011-06-10 at 10:34 -0500, Andrew Theurer wrote:
> > RIP: 0010:[<ffffffff8104e8c1>]  [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150
> 
> If you've still got the vmlinux around, could you find out where in
> find_lowest_rq that RIP is? 

Does this help?


from objdump -d -S

ffffffff8104e820 <find_lowest_rq>:
ffffffff8104e820:       55                      push   %rbp
ffffffff8104e821:       48 89 e5                mov    %rsp,%rbp
ffffffff8104e824:       48 83 ec 30             sub    $0x30,%rsp
ffffffff8104e828:       48 89 5d d8             mov    %rbx,-0x28(%rbp)
ffffffff8104e82c:       4c 89 65 e0             mov    %r12,-0x20(%rbp)
ffffffff8104e830:       4c 89 6d e8             mov    %r13,-0x18(%rbp)
ffffffff8104e834:       4c 89 75 f0             mov    %r14,-0x10(%rbp)
ffffffff8104e838:       4c 89 7d f8             mov    %r15,-0x8(%rbp)
ffffffff8104e83c:       e8 3f bf 48 00          callq  ffffffff814da780 <mcount>
ffffffff8104e841:       48 c7 c0 88 e8 00 00    mov    $0xe888,%rax
ffffffff8104e848:       65 48 03 04 25 50 dc    add    %gs:0xdc50,%rax
ffffffff8104e84f:       00 00
ffffffff8104e851:       65 44 8b 2c 25 58 dc    mov    %gs:0xdc58,%r13d
ffffffff8104e858:       00 00
ffffffff8104e85a:       83 bf bc 01 00 00 01    cmpl   $0x1,0x1bc(%rdi)
ffffffff8104e861:       4c 8b 20                mov    (%rax),%r12
ffffffff8104e864:       48 8b 47 08             mov    0x8(%rdi),%rax
ffffffff8104e868:       8b 58 18                mov    0x18(%rax),%ebx
ffffffff8104e86b:       75 23                   jne    ffffffff8104e890 <find_lowest_rq+0x70>
ffffffff8104e86d:       b8 ff ff ff ff          mov    $0xffffffff,%eax
ffffffff8104e872:       48 8b 5d d8             mov    -0x28(%rbp),%rbx
ffffffff8104e876:       4c 8b 65 e0             mov    -0x20(%rbp),%r12
ffffffff8104e87a:       4c 8b 6d e8             mov    -0x18(%rbp),%r13
ffffffff8104e87e:       4c 8b 75 f0             mov    -0x10(%rbp),%r14
ffffffff8104e882:       4c 8b 7d f8             mov    -0x8(%rbp),%r15
ffffffff8104e886:       c9                      leaveq
ffffffff8104e887:       c3                      retq
ffffffff8104e888:       0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
ffffffff8104e88f:       00
ffffffff8104e890:       89 d8                   mov    %ebx,%eax
ffffffff8104e892:       49 c7 c7 c0 2a 01 00    mov    $0x12ac0,%r15
ffffffff8104e899:       48 89 fe                mov    %rdi,%rsi
ffffffff8104e89c:       48 8b 04 c5 40 a3 bf    mov    -0x7e405cc0(,%rax,8),%rax
ffffffff8104e8a3:       81
ffffffff8104e8a4:       4c 89 e2                mov    %r12,%rdx
ffffffff8104e8a7:       49 8b 84 07 88 08 00    mov    0x888(%r15,%rax,1),%rax
ffffffff8104e8ae:       00
ffffffff8104e8af:       48 83 c0 38             add    $0x38,%rax
ffffffff8104e8b3:       48 89 c7                mov    %rax,%rdi
ffffffff8104e8b6:       e8 85 75 0a 00          callq  ffffffff810f5e40 <cpupri_find>
ffffffff8104e8bb:       85 c0                   test   %eax,%eax
ffffffff8104e8bd:       74 ae                   je     ffffffff8104e86d <find_lowest_rq+0x4d>
ffffffff8104e8bf:       89 d8                   mov    %ebx,%eax
ffffffff8104e8c1:       41 0f a3 1c 24          bt     %ebx,(%r12)
ffffffff8104e8c6:       19 d2                   sbb    %edx,%edx
ffffffff8104e8c8:       85 d2                   test   %edx,%edx
ffffffff8104e8ca:       75 a6                   jne    ffffffff8104e872 <find_lowest_rq+0x52>
ffffffff8104e8cc:       45 0f a3 2c 24          bt     %r13d,(%r12)
ffffffff8104e8d1:       19 c0                   sbb    %eax,%eax
ffffffff8104e8d3:       41 be ff ff ff ff       mov    $0xffffffff,%r14d
ffffffff8104e8d9:       85 c0                   test   %eax,%eax
ffffffff8104e8db:       48 63 db                movslq %ebx,%rbx
ffffffff8104e8de:       45 0f 45 f5             cmovne %r13d,%r14d
ffffffff8104e8e2:       4c 03 3c dd 40 a3 bf    add    -0x7e405cc0(,%rbx,8),%r15
ffffffff8104e8e9:       81
ffffffff8104e8ea:       49 8b 9f 90 08 00 00    mov    0x890(%r15),%rbx
ffffffff8104e8f1:       48 85 db                test   %rbx,%rbx
ffffffff8104e8f4:       74 4c                   je     ffffffff8104e942 <find_lowest_rq+0x122>
ffffffff8104e8f6:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
ffffffff8104e8fd:       00 00 00
ffffffff8104e900:       f6 43 4c 20             testb  $0x20,0x4c(%rbx)
ffffffff8104e904:       74 34                   je     ffffffff8104e93a <find_lowest_rq+0x11a>
ffffffff8104e906:       41 83 fe ff             cmp    $0xffffffffffffffff,%r14d
ffffffff8104e90a:       74 0e                   je     ffffffff8104e91a <find_lowest_rq+0xfa>
ffffffff8104e90c:       44 0f a3 b3 20 01 00    bt     %r14d,0x120(%rbx)
ffffffff8104e913:       00
ffffffff8104e914:       19 c0                   sbb    %eax,%eax
ffffffff8104e916:       85 c0                   test   %eax,%eax
ffffffff8104e918:       75 2e                   jne    ffffffff8104e948 <find_lowest_rq+0x128>
ffffffff8104e91a:       48 8d 93 20 01 00 00    lea    0x120(%rbx),%rdx
ffffffff8104e921:       4c 89 e6                mov    %r12,%rsi
ffffffff8104e924:       bf ff ff ff ff          mov    $0xffffffff,%edi
ffffffff8104e929:       e8 42 4e 1e 00          callq  ffffffff81233770 <cpumask_next_and>
ffffffff8104e92e:       3b 05 14 78 bb 00       cmp    0xbb7814(%rip),%eax        # ffffffff81c06148 <nr_cpu_ids>
ffffffff8104e934:       0f 8c 38 ff ff ff       jl     ffffffff8104e872 <find_lowest_rq+0x52>
ffffffff8104e93a:       48 8b 1b                mov    (%rbx),%rbx
ffffffff8104e93d:       48 85 db                test   %rbx,%rbx
ffffffff8104e940:       75 be                   jne    ffffffff8104e900 <find_lowest_rq+0xe0>
ffffffff8104e942:       41 83 fe ff             cmp    $0xffffffffffffffff,%r14d
ffffffff8104e946:       74 08                   je     ffffffff8104e950 <find_lowest_rq+0x130>
ffffffff8104e948:       44 89 f0                mov    %r14d,%eax
ffffffff8104e94b:       e9 22 ff ff ff          jmpq   ffffffff8104e872 <find_lowest_rq+0x52>
ffffffff8104e950:       48 63 35 f1 77 bb 00    movslq 0xbb77f1(%rip),%rsi        # ffffffff81c06148 <nr_cpu_ids>
ffffffff8104e957:       4c 89 e7                mov    %r12,%rdi
ffffffff8104e95a:       e8 d1 52 1e 00          callq  ffffffff81233c30 <find_first_bit>
ffffffff8104e95f:       3b 05 e3 77 bb 00       cmp    0xbb77e3(%rip),%eax        # ffffffff81c06148 <nr_cpu_ids>
ffffffff8104e965:       0f 8c 07 ff ff ff       jl     ffffffff8104e872 <find_lowest_rq+0x52>
ffffffff8104e96b:       e9 fd fe ff ff          jmpq   ffffffff8104e86d <find_lowest_rq+0x4d>

[    4.540584] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
[    4.548779] IP: [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150
[    4.554824] PGD 0
[    4.557044] Oops: 0000 [#1] SMP
[    4.560558] CPU 0
[    4.562457] Modules linked in:
[    4.566042]
[    4.567669] Pid: 1, comm: swapper Not tainted 3.0.0-rc2-00251-g7f45e5c #37 IBM  -[7145AC1]-/Node 1, Processor Card
[    4.578446] RIP: 0010:[<ffffffff8104e8c1>]  [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150
[    4.586988] RSP: 0018:ffff883732925ca0  EFLAGS: 00010002
[    4.592429] RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000050
[    4.599692] RDX: 00000000ffffffff RSI: 0000000000000050 RDI: 0000000000000050
[    4.606954] RBP: ffff883732925cd0 R08: ffff883732774d38 R09: 0000000000000000
[    4.614219] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[    4.621479] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000012ac0
[    4.628739] FS:  0000000000000000(0000) GS:ffff88387f800000(0000) knlGS:0000000000000000
[    4.637024] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.642897] CR2: 0000000000000004 CR3: 0000000001a03000 CR4: 00000000000006f0
[    4.650159] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.657421] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    4.664684] Process swapper (pid: 1, threadinfo ffff883732924000, task ffff8837329234c0)
[    4.672971] Stack:
[    4.675117]  ffff883732925cf0 0000000000000020 0000000000000020 ffff883732775300
[    4.683022]  0000000000000000 0000000000000286 ffff883732925cf0 ffffffff8104e9ea
[    4.690938]  ffff88373279cb00 ffff883732774b40 ffff883732925d40 ffffffff8105ac79
[    4.698851] Call Trace:
[    4.701437]  [<ffffffff8104e9ea>] select_task_rq_rt+0x7a/0x90
[    4.707320]  [<ffffffff8105ac79>] try_to_wake_up+0x119/0x2a0
[    4.713114]  [<ffffffff8105ae55>] wake_up_process+0x15/0x20
[    4.718818]  [<ffffffff814cc546>] rcu_cpu_notify+0xd6/0x196
[    4.724524]  [<ffffffff814d65a5>] notifier_call_chain+0x55/0x80
[    4.730577]  [<ffffffff8108a7be>] __raw_notifier_call_chain+0xe/0x10
[    4.737061]  [<ffffffff81064590>] __cpu_notify+0x20/0x40
[    4.742504]  [<ffffffff814caf05>] _cpu_up+0xc7/0x10e
[    4.747599]  [<ffffffff814cb023>] cpu_up+0xd7/0xea
[    4.752527]  [<ffffffff81c41dfa>] smp_init+0x41/0x96
[    4.757627]  [<ffffffff81c227d4>] kernel_init+0x1d6/0x262
[    4.763165]  [<ffffffff814dbb84>] kernel_thread_helper+0x4/0x10
[    4.769221]  [<ffffffff81c225fe>] ? do_basic_setup+0x5c/0x5c
[    4.775008]  [<ffffffff814dbb80>] ? gs_change+0x13/0x13
[    4.780360] Code: 2a 01 00 48 89 fe 48 8b 04 c5 40 a3 bf 81 4c 89 e2 49 8b 84 07 88 08 00 00 48 83 c0 38 48 89 c7 e8 85 75 0a 00 85 c0 74 ae 89 d8
[    4.796927]  0f a3 1c 24 19 d2 85 d2 75 a6 45 0f a3 2c 24 19 c0 41 be ff
[    4.805820] RIP  [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150
[    4.811946]  RSP <ffff883732925ca0>
[    4.815566] CR2: 0000000000000004
[    4.819019] ---[ end trace ca2ec1f2e8037d5f ]---

-Andrew




