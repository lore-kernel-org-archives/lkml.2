Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0JUIdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:33:46 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60757 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab0JUIdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:33:41 -0400
Subject: Re: [2.6.36-rc7, Power6] LTP Ftrace Stress tests causes KERNEL
	PANIC and brings the system to xmon
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: rostedt <rostedt@goodmis.org>
Cc: Linuxppc-dev <Linuxppc-dev@ozlabs.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ltp-list <ltp-list@lists.sf.net>
In-Reply-To: <1286998463.4893.26.camel@subratamodak.linux.ibm.com>
References: <1286998463.4893.26.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Thu, 21 Oct 2010 14:03:17 +0530
Message-Id: <1287649998.22128.1.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefen,

Can you please know your thoughts on this issue ?

Regards--
Subrata

On Thu, 2010-10-14 at 01:04 +0530, Subrata Modak wrote:
> Hi,
> 
> Executing LTP Ftrace Stress tests on 2.6.36-rc7, Power6 creates kernel
> Panic and xmon is invoked:
> 
> Ways to reproduce the problem:
> 
> Download latest LTP git via:
>         git://ltp.git.sourceforge.net/gitroot/ltp/ltp
>         cd ltp
>         ./configure
>         make
>         make install
>         cd /opt/ltp
>         ./runltp -f tracing
> 
> You will notice the following kernel panic. Other information from xmon
> debugger is also provided. Please note that this was originally discovered in
> stable 2.6.35.4. And then again reproduced on 2.6.36-rc7:
> ================================================
> Running tests.......
> <<<test_start>>>
> tag=ftrace-stress-test stime=1286980645
> cmdline="ftrace_stress_test.sh 90"
> contacts=""
> analysis=exit
> <<<test_output>>>
> incrementing stop
> mkdir: cannot create directory `/opt/ltp/testcases/bin/debugfs': File
> exists
> Ftrace Stress Test Begin
> Unable to handle kernel paging request for data at address
> 0xbffffffe0175b688
> Unable to handle kernel paging request for data at address
> 0xbffffffe0175b688
> Faulting instruction address: 0xc000000000101414
> cpu 0Faulting instrucxtion address: 0x1c000000000101414:
>  Vector: 300 (Data Access) at [c0000000d4a8ed10]
>     pc: c000000000101414: .update_curr+0x31c/0x410
>     lr: c0000000001013a4: .update_curr+0x2ac/0x410
>     sp: c0000000d4a8ef90
>    msr: 8000000000001032
>    dar: bffffffe0175b688
>  dsisr: 40000000
>   current = 0xc0000000d49c1b00
>   paca    = 0xc000000007fc8700
>     pid   = 1667, comm = ftrace_profile_
> enter ? for help
> [c0000000d4a8f040] c00000000010164c .task_tick_fair+0x88/0x30c
> [c0000000d4a8f0f0] c00000000011f3a0 .scheduler_tick+0x228/0x6f0
> [c0000000d4a8f1a0] c0000000001494e4 .update_process_times+0xd0/0x120
> [c0000000d4a8f240] c00000000018f7d4 .tick_sched_timer+0x114/0x194
> [c0000000d4a8f2f0] c000000000178678 .__run_hrtimer+0x28c/0x3d8
> [c0000000d4a8f3a0] c000000000178cd8 .hrtimer_interrupt+0x18c/0x3c8
> [c0000000d4a8f4b0] c0000000000448f0 .timer_interrupt+0x2b8/0x514
> [c0000000d4a8f550] c000000000003728 decrementer_common+0x128/0x180
> --- Exception: 901 (Decrementer) at
> c0000000000f99a4 .mutex_spin_on_owner+0x110/0x1bc
> [c0000000d4a8f8d0] c000000000bcf600 .__mutex_lock_slowpath+0xe0/0x3f0
> [c0000000d4a8f9c0] c000000000bd0520 .mutex_lock+0xb0/0xe4
> [c0000000d4a8fa50] c000000000211978 .tracepoint_probe_unregister
> +0x58/0x12c
> [c0000000d4a8fb00] c00000000021a078 .unregister_ftrace_graph+0xc4/0x114
> [c0000000d4a8fb90] c00000000021b864 .ftrace_profile_write+0x4b0/0x530
> [c0000000d4a8fcc0] c00000000031e35c .vfs_write+0x1ac/0x338
> [c0000000d4a8fd70] c000000000009794 .return_to_handler+0x0/0x34
> [c0000000d4a8fe30] c000000000009794 .return_to_handler+0x0/0x34
> --- Exception: c00 (System Call) at 000000000fecfc94
> SP (ffdcf9c0) is in userspace
> 1:mon> cpu 0x0: Vector: 300 (Data Access) at [c0000000cfa0f5f0]
>     pc: c000000000101414: .update_curr+0x31c/0x410
>     lr: c0000000001013a4: .update_curr+0x2ac/0x410
>     sp: c0000000cfa0f870
>    msr: 8000000000001032
>    dar: bffffffe0175b688
>  dsisr: 40000000
>   current = 0xc0000000d48cb600
>   paca    = 0xc000000007fc8000
>     pid   = 1909, comm = cat
> 
> 1:mon> 
> 1:mon> e
> cpu 0x1: Vector: 300 (Data Access) at [c0000000d4a8ed10]
>     pc: c000000000101414: .update_curr+0x31c/0x410
>     lr: c0000000001013a4: .update_curr+0x2ac/0x410
>     sp: c0000000d4a8ef90
>    msr: 8000000000001032
>    dar: bffffffe0175b688
>  dsisr: 40000000
>   current = 0xc0000000d49c1b00
>   paca    = 0xc000000007fc8700
>     pid   = 1667, comm = ftrace_profile_
> 
> 1:mon> dl
> 
> <4>------------[ cut here ]------------
> <4>WARNING: at kernel/trace/ring_buffer.c:2227
> <4>Modules linked in: sunrpc ipv6 uinput ehea ibmvscsic
> scsi_transport_srp scsi_tgt [last unloaded: scsi_wait_scan]
> <4>NIP: c000000000222b3c LR: c000000000222b1c CTR: 0000000000000001
> <4>REGS: c0000000d4a89670 TRAP: 0700   Not tainted  (2.6.36-rc7)
> <4>MSR: 8000000000021032 <ME,CE,IR,DR>  CR: 48242482  XER: 20000000
> <4>TASK = c0000000d49c1b00[1667] 'ftrace_profile_' THREAD:
> c0000000d4a8c000 CPU: 1
> <4>GPR00: 0000000000000001 c0000000d4a898f0 c0000000017354c0
> 0000000000000036 
> <4>GPR04: 0000000000000000 ffffffffffffffff 0000000000000007
> 0000000000f791ca 
> <4>GPR08: 0000000000f80c95 c00000000187d8a8 c0000000018803d0
> 0000000000000001 
> <4>GPR12: 0000000028242482 c000000007fc8700 0000000000000000
> 00000000100f0000 
> <4>GPR16: 00000000100f4a54 00000000100d3650 00000000100f4bfc
> 00000000100f4b6c 
> <4>GPR20: 000000000000001c 0000000000000001 c0000000d4a89e40
> c000000001879e88 
> <4>GPR24: 0000000000000000 0000000000000000 c000000001640248
> 0000000000000000 
> <4>GPR28: 0000000000000010 c00000000187d8a8 c0000000016a9400
> c0000000d4a898f0 
> <4>NIP [c000000000222b3c] .ring_buffer_lock_reserve+0x1a0/0x2a4
> <4>LR [c000000000222b1c] .ring_buffer_lock_reserve+0x180/0x2a4
> <4>Call Trace:
> <4>Instruction dump:
> <4>54c7014a 78c585a2 78c6c622 489c22a5 60000000 e93e8000 e95e8030
> e9691d90 
> <4>880a0013 396b0001 68000001 f9691d90 <0b000000> e93e8000 2fa00000
> e9691da0 
> <4>---[ end trace 54ff4f71b2972eb9 ]---
> <1>Unable to handle kernel paging request for data at address
> 0xbffffffe0175b688
> <1>Unable to handle kernel paging request for data at address
> 0xbffffffe0175b688
> <1>Faulting instruction address: 0xc000000000101414
> <1>Faulting instruction address: 0xc000000000101414
> 
> 1:mon> r
> R00 = 000000000003b578   R16 = c0000000d4a8f420
> R01 = c0000000d4a8ef90   R17 = c000000001c45688
> R02 = c0000000017354c0   R18 = c0000000d4a8f410
> R03 = 0000000000000000   R19 = 0000000000000000
> R04 = 0000000000000030   R20 = 0000000000000000
> R05 = 0000000000000030   R21 = c000000001817610
> R06 = 0000000000000000   R22 = 7fffffffffffffff
> R07 = 000000000003b5d2   R23 = 0000000000000001
> R08 = fffffffe00000000   R24 = c0000000017e0800
> R09 = c0000000de004580   R25 = 0000003c9482245c
> R10 = c00000000175b688   R26 = 000000038aa347f0
> R11 = c0000000017d0800   R27 = c0000000d49c1b00
> R12 = 0000000028242428   R28 = c0000000d087f820
> R13 = c000000007fc8700   R29 = 00000000008b9528
> R14 = 0000000000000000   R30 = c0000000016a3d48
> R15 = 00000000100f0000   R31 = c0000000d4a8ef90
> pc  = c000000000101414 .update_curr+0x31c/0x410
> lr  = c0000000001013a4 .update_curr+0x2ac/0x410
> msr = 8000000000001032   cr  = 28242428
> ctr = c0000000000fdbfc   xer = 0000000000000000   trap =  300
> dar = bffffffe0175b688   dsisr = 40000000
> 
> 1:mon> S
> msr  = 8000000000001032  sprg0= 0000000000000000
> pvr  = 00000000003e0400  sprg1= c000000007fc8700
> dec  = 0000000078006b92  sprg2= c000000007fc8700
> sp   = c0000000d4a8e680  sprg3= 0000000000000001
> toc  = c0000000017354c0  dar  = bffffffe0175b688
> 
> 1:mon> t
> [c0000000d4a8f040] c00000000010164c .task_tick_fair+0x88/0x30c
> [c0000000d4a8f0f0] c00000000011f3a0 .scheduler_tick+0x228/0x6f0
> [c0000000d4a8f1a0] c0000000001494e4 .update_process_times+0xd0/0x120
> [c0000000d4a8f240] c00000000018f7d4 .tick_sched_timer+0x114/0x194
> [c0000000d4a8f2f0] c000000000178678 .__run_hrtimer+0x28c/0x3d8
> [c0000000d4a8f3a0] c000000000178cd8 .hrtimer_interrupt+0x18c/0x3c8
> [c0000000d4a8f4b0] c0000000000448f0 .timer_interrupt+0x2b8/0x514
> [c0000000d4a8f550] c000000000003728 decrementer_common+0x128/0x180
> --- Exception: 901 (Decrementer) at
> c0000000000f99a4 .mutex_spin_on_owner+0x110/0x1bc
> [c0000000d4a8f8d0] c000000000bcf600 .__mutex_lock_slowpath+0xe0/0x3f0
> [c0000000d4a8f9c0] c000000000bd0520 .mutex_lock+0xb0/0xe4
> [c0000000d4a8fa50] c000000000211978 .tracepoint_probe_unregister
> +0x58/0x12c
> [c0000000d4a8fb00] c00000000021a078 .unregister_ftrace_graph+0xc4/0x114
> [c0000000d4a8fb90] c00000000021b864 .ftrace_profile_write+0x4b0/0x530
> [c0000000d4a8fcc0] c00000000031e35c .vfs_write+0x1ac/0x338
> [c0000000d4a8fd70] c000000000009794 .return_to_handler+0x0/0x34
> [c0000000d4a8fe30] c000000000009794 .return_to_handler+0x0/0x34
> --- Exception: c00 (System Call) at 000000000fecfc94
> SP (ffdcf9c0) is in userspace
> 
> 1:mon> u
> SLB contents of cpu 1
> 00 c000000008000000 40004f7ca3000500  1T  ESID=   c00000  VSID=
> 4f7ca3 LLP:100 
> 01 d000000008000000 4000eb71b0000400  1T  ESID=   d00000  VSID=
> eb71b0 LLP:  0 
> 14 0000000008000000 0000489b22861c80 256M ESID=        0  VSID=
> 489b22861 LLP:  0 
> 15 00000000f8000000 000053d29a3f6c80 256M ESID=        f  VSID=
> 53d29a3f6 LLP:  0 
> 16 0000000018000000 0000495a90e7cc80 256M ESID=        1  VSID=
> 495a90e7c LLP:  0 
> 17 f000000008000000 4000235bcc000500  1T  ESID=   f00000  VSID=
> 235bcc LLP:100 
> 18 bffffffe08000000 0000000000000c80 256M ESID=bffffffe0  VSID=
> 0 LLP:  0 
> 1:mon> 
> ================================================
> 
> However Peter Zijlstraś proposed patch did not fix this issue. The patch
> was
> posted to LTP:
> http://marc.info/?l=ltp-list&m=128696942432669&w=2
> 
> The Kernel paniked even after the patch. However this time th message was
> different. Other xmon output is also shown below:
> 
> ================================================
> Ftrace Stress Test Begin
> 
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc0000000002133f0
> cpu 0x2: Vector: 300 (Data Access) at [c0000000d9f8b560]
>     pc: c0000000002133f0: .trace_clock_global+0xb4/0x2a0
>     lr: c000000000213458: .trace_clock_global+0x11c/0x2a0
>     sp: c0000000d9f8b7e0
>    msr: 800000000200b032
>    dar: 0
>  dsisr: 40000000
>   current = 0xc0000000d9f7d100
>   paca    = 0xc000000007fc8e00
>     pid   = 1667, comm = ftrace_stack_tr
> Unrecoverable FP Unavailable Exception 800 at c0000000016a9540
> cpu 0x0: Vector: 8Unable to handle0 kernel paging r0 equest for data (at
> address 0xbffFffffe0175b688
> PU UnavaFaulting instruciltion address: 0xac0000000001017fcb
> le) at [c0000000d9f8a6a0]
> p   pc: c0000000016a9540: etnetre r?  ?f ofro rh ehlepl
> 
> 
>     lr: [c000000000016a9540: key_type_dns_resolver+0x15110/0x365f8
>     sp: c0000000018804e8
>    msr: 8000000000001032
>   current = 0xc0000000d838d100
>   paca    = 0xc000000007fc8000
>     pid   = 1668, comm = ftrace_stack_ma
>  pid   = 1668, cc0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8b9b0] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8ba40] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8baf0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8bb80] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8bc40] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8bcd0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8bd40] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8bdd0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8be90] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8bfa0] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8c030] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8c0e0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8c170] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8c230] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8c2c0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8c330] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8c3c0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8c480] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8c590] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8c620] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8c6d0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8c760] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8c820] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8c8b0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8c920] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8c9b0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8ca70] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8cb80] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8cc10] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8ccc0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8cd50] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8ce10] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8cea0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8cf10] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8cfa0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8d060] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8d170] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8d200] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8d2b0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8d340] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8d400] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8d490] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8d500] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8d590] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8d650] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8d760] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8d7f0] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8d8a0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8d930] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8d9f0] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8da80] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8daf0] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8db80] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8dc40] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8dd50] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8dde0] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8de90] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8df20] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8dfe0] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8e070] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8e0e0] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8e170] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8e230] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> 2:mon> cpu 0x1: Vector: 300 (Data Access) at [c0000000d9fab5f0]
>     pc: c0000000001017fc: .update_curr+0x31c/0x410
>     lr: c00000000010178c: .update_curr+0x2ac/0x410
>     sp: c0000000d9fab870
>    msr: 8000000000001032
>    dar: bffffffe0175b688
>  dsisr: 40000000
>   current = 0xc0000000d9fa0000
>   paca    = 0xc000000007fc8700
>     pid   = 1669, comm = ftrace_tracing_
> 
> 2:mon> e
> cpu 0x2: Vector: 300 (Data Access) at [c0000000d9f8b560]
>     pc: c0000000002133f0: .trace_clock_global+0xb4/0x2a0
>     lr: c000000000213458: .trace_clock_global+0x11c/0x2a0
>     sp: c0000000d9f8b7e0
>    msr: 800000000200b032
>    dar: 0
>  dsisr: 40000000
>   current = 0xc0000000d9f7d100
>   paca    = 0xc000000007fc8e00
>     pid   = 1667, comm = ftrace_stack_tr
> 
> 2:mon> dl
> 
> <4>------------[ cut here ]------------
> <4>WARNING: at kernel/trace/ring_buffer.c:2227
> <4>Modules linked in: sunrpc ipv6 uinput ehea ibmvscsic scsi_transport_srp
> scsi_tgt [last unloaded: scsi_wait_scan]
> <4>NIP: c0000000002230cc LR: c0000000002230ac CTR: 0000000000000001
> <4>REGS: c0000000d9f89f70 TRAP: 0700   Not tainted  (2.6.36-rc7)
> <4>MSR: 8000000000021032 <ME,CE,IR,DR>  CR: 48842482  XER: 20000000
> <4>TASK = c0000000d838d100[1668] 'ftrace_stack_ma' THREAD: c0000000d9f8c000
> CPU: 0
> <4>GPR00: 0000000000000001 c0000000d9f8a1f0 c000000001735590 0000000000000036 
> <4>GPR04: 0000000000000000 ffffffffffffffff 0000000000000007 0000000001d86c30 
> <4>GPR08: 0000000001d88a6b c00000000187d9a8 c0000000018804d0 0000000000000001 
> <4>GPR12: 0000000028842482 c000000007fc8000 0000000000000002 00000000100f765c 
> <4>GPR16: 00000000100d22f8 00000000100f9790 000000000000001e 0000000000000001 
> <4>GPR20: 000000000000001c 0000000000000001 c0000000d9f8a740 c000000001879f88 
> <4>GPR24: 0000000000000000 0000000000000000 c000000001640248 0000000000000000 
> <4>GPR28: 0000000000000010 c00000000187d9a8 c0000000016a9400 c0000000d9f8a1f0 
> <4>NIP [c0000000002230cc] .ring_buffer_lock_reserve+0x1a0/0x2a4
> <4>LR [c0000000002230ac] .ring_buffer_lock_reserve+0x180/0x2a4
> <4>Call Trace:
> <4>Instruction dump:
> <4>54c7014a 78c585a2 78c6c622 489c22c5 60000000 e93e8000 e95e8030 e9691d90 
> <4>880a0013 396b0001 68000001 f9691d90 <0b000000> e93e8000 2fa00000 e9691da0 
> <4>---[ end trace f749046f770eb249 ]---
> <1>Unable to handle kernel paging request for data at address 0x00000000
> <1>Faulting instruction address: 0xc0000000002133f0
> <0>Unrecoverable FP Unavailable Exception 800 at c0000000016a9540
> <1>Unable to handle kernel paging request for data at address
> 0xbffffffe0175b688
> <1>Faulting instruction address: 0xc0000000001017fc
> 2:mon> r
> R00 = 0000000000000377   R16 = c0000000d9f8b650
> R01 = c0000000d9f8b7e0   R17 = 0000000000000000
> R02 = c000000001735590   R18 = 0000000000000000
> R03 = 0000000000000000   R19 = c0000000ccc7d3b8
> R04 = 0000000000000020   R20 = 0000000000000000
> R05 = 0000000000000020   R21 = 00000000000000d0
> R06 = 0000000000000001   R22 = c0000000de004e00
> R07 = 0000000000000000   R23 = 0000000000000000
> R08 = 0000000000025420   R24 = c000000001879f00
> R09 = 0000000080000002   R25 = 0000000000000000
> R10 = 00000000e26ea160   R26 = c000000001879e00
> R11 = 000000000010c146   R27 = 0000003c5f642816
> R12 = 0000000000000002   R28 = c000000001879e00
> R13 = c000000007fc8e00   R29 = c000000001879e00
> R14 = 0000000000000000   R30 = c0000000016a9128
> R15 = 00000000100f0000   R31 = c0000000d9f8b7e0
> pc  = c0000000002133f0 .trace_clock_global+0xb4/0x2a0
> lr  = c000000000213458 .trace_clock_global+0x11c/0x2a0
> msr = 800000000200b032   cr  = 28842442
> ctr = c000000000011d24   xer = 0000000000000000   trap =  300
> dar = 0000000000000000   dsisr = 40000000
> 
> 2:mon> S
> msr  = 8000000000001032  sprg0= 0000000000000000
> pvr  = 00000000003e0400  sprg1= c000000007fc8e00
> dec  = 000000007b5e21d9  sprg2= c000000007fc8e00
> sp   = c0000000d9f8aed0  sprg3= 0000000000000002
> toc  = c000000001735590  dar  = 0000000000000000
> 
> 2:mon> t
> [c0000000d9f8b8a0] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8b9b0] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8ba40] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8baf0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8bb80] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8bc40] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8bcd0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8bd40] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8bdd0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8be90] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8bfa0] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8c030] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8c0e0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8c170] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8c230] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8c2c0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8c330] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8c3c0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8c480] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8c590] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8c620] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8c6d0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8c760] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8c820] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8c8b0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8c920] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8c9b0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8ca70] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8cb80] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8cc10] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8ccc0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8cd50] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8ce10] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8cea0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8cf10] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8cfa0] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8d060] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8d170] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8d200] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8d2b0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8d340] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8d400] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8d490] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8d500] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8d590] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8d650] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8d760] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8d7f0] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8d8a0] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8d930] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8d9f0] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8da80] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8daf0] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8db80] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8dc40] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> [c0000000d9f8dd50] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
> [c0000000d9f8dde0] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
> [c0000000d9f8de90] c00000000022ec9c
> .trace_current_buffer_lock_reserve+0x44/0x6c
> [c0000000d9f8df20] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
> [c0000000d9f8dfe0] c000000000096624 .__trace_hcall_entry+0xa0/0xec
> [c0000000d9f8e070] c00000000009786c .plpar_hcall_norets+0x50/0xd0
> [c0000000d9f8e0e0] c0000000000749c8 .__spin_yield+0x130/0x15c
> [c0000000d9f8e170] c000000000213458 .trace_clock_global+0x11c/0x2a0
> [c0000000d9f8e230] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
> 
> 2:mon> u
> SLB contents of cpu 2
> 00 c000000008000000 40004f7ca3000500  1T  ESID=   c00000  VSID=       4f7ca3
> LLP:100 
> 01 d000000008000000 4000eb71b0000400  1T  ESID=   d00000  VSID=       eb71b0
> LLP:  0 
> 28 f000000008000000 4000235bcc000500  1T  ESID=   f00000  VSID=       235bcc
> LLP:100 
> 38 0000000008000000 0000da39727a1c80 256M ESID=        0  VSID=    da39727a1
> LLP:  0 
> 39 00000000f8000000 0000e570ea336c80 256M ESID=        f  VSID=    e570ea336
> LLP:  0 
> 40 0000000018000000 0000daf8e0dbcc80 256M ESID=        1  VSID=    daf8e0dbc
> LLP:  0 
> ================================================
> 
> Regards--
> Subrata
> 

