Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab1HDGe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:34:59 -0400
Received: from smtp4.Stanford.EDU ([171.67.219.84]:37303 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849Ab1HDGev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:34:51 -0400
Message-ID: <4E3A3D7C.6050403@localhost>
Date: Wed, 03 Aug 2011 23:34:36 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: Re: [ANNOUNCE] 3.0-rt6
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
In-Reply-To: <alpine.LFD.2.02.1107282213000.31246@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2011 02:43 PM, Thomas Gleixner wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.0-rt6 release.

Thanks, here's some feedback from a user of Planet CCRMA (running an 
unreleased build of rt6 on x86_64 which I have not had a chance to test 
yet). See below for some details...

-- Fernando


-------- Original Message --------
Subject: More grist for the RT mill
Date: Wed, 3 Aug 2011 03:39:46 -0700
From: Tracey Hytry

After a lot of work I've managed to install Feodra15 on one of the 
machines...
just to be able to test the x86_64 version of the new builds.

Enclosed is info from just after boot.
I didn't have anything set up to test it, but there were no more errors 
afterwards;
starting x and transferring some files via nfs.
You can pass this along to linux-rt-users if needed.

----------------------------------------------
dmesg:

[  117.025914]
[  117.025916] =================================
[  117.025918] [ INFO: inconsistent lock state ]
[  117.025920] 3.0.0-1.rt6.1.fc15.ccrma.x86_64.rt #1
[  117.025922] ---------------------------------
[  117.025924] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[  117.025927] posixcputmr/0/6 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  117.025929]  (&sig->cputimer.lock){?.....}, at: [<ffffffff8107b6f1>] 
__run_posix_cpu_timers+0x8f/0x353
[  117.025936] {IN-HARDIRQ-W} state was registered at:
[  117.025938]   [<ffffffff8108c8df>] __lock_acquire+0x2ce/0xd0c
[  117.025943]   [<ffffffff8108d820>] lock_acquire+0xf3/0x13e
[  117.025946]   [<ffffffff814ef322>] _raw_spin_lock+0x45/0x79
[  117.025949]   [<ffffffff8104a617>] __account_system_time+0x4a/0x81
[  117.025952]   [<ffffffff8104e9c7>] account_system_time+0xa1/0xa8
[  117.025955]   [<ffffffff8104ec1e>] account_process_tick+0x78/0x86
[  117.025957]   [<ffffffff81068ff1>] update_process_times+0x2f/0x54
[  117.025961]   [<ffffffff81088c6b>] tick_sched_timer+0xff/0x128
[  117.025964]   [<ffffffff8107c5f6>] __run_hrtimer+0xed/0x1db
[  117.025967]   [<ffffffff8107d008>] hrtimer_interrupt+0x1a1/0x2af
[  117.025969]   [<ffffffff814f719c>] smp_apic_timer_interrupt+0x77/0x8a
[  117.025973]   [<ffffffff814f6053>] apic_timer_interrupt+0x13/0x20
[  117.025976]   [<ffffffff814ef64c>] _raw_spin_unlock_irqrestore+0x4d/0x73
[  117.025978]   [<ffffffff8107a943>] thread_group_cputimer+0xae/0xbd
[  117.025981]   [<ffffffff8107a97d>] cpu_timer_sample_group+0x2b/0x75
[  117.025984]   [<ffffffff8107bc04>] set_process_cpu_timer+0x36/0xdf
[  117.025987]   [<ffffffff8107bcf1>] update_rlimit_cpu+0x44/0x63
[  117.025989]   [<ffffffff81206305>] 
selinux_bprm_committing_creds+0xd3/0xd8
[  117.025994]   [<ffffffff811fd99c>] 
security_bprm_committing_creds+0x13/0x15
[  117.025998]   [<ffffffff8114279e>] install_exec_creds+0x13/0x52
[  117.026001]   [<ffffffff811816d2>] load_elf_binary+0xf40/0x175e
[  117.026004]   [<ffffffff81143630>] search_binary_handler+0xad/0x25d
[  117.026007]   [<ffffffff81144600>] do_execve_common+0x186/0x283
[  117.026009]   [<ffffffff81144740>] do_execve+0x43/0x45
[  117.026009]   [<ffffffff810114e4>] sys_execve+0x43/0x5a
[  117.026009]   [<ffffffff814f5adc>] stub_execve+0x6c/0xc0
[  117.026009] irq event stamp: 37
[  117.026009] hardirqs last  enabled at (37): [<ffffffff814ef69f>] 
_raw_spin_unlock_irq+0x2d/0x59
[  117.026009] hardirqs last disabled at (36): [<ffffffff814ef405>] 
_raw_spin_lock_irq+0x1d/0x82
[  117.026009] softirqs last  enabled at (0): [<ffffffff8105838a>] 
copy_process+0x6c1/0x14a0
[  117.026009] softirqs last disabled at (0): [<          (null)>] 
      (null)
[  117.026009]
[  117.026009] other info that might help us debug this:
[  117.026009]  Possible unsafe locking scenario:
[  117.026009]
[  117.026009]        CPU0
[  117.026009]        ----
[  117.026009]   lock(&sig->cputimer.lock);
[  117.026009]   <Interrupt>
[  117.026009]     lock(&sig->cputimer.lock);
[  117.026009]
[  117.026009]  *** DEADLOCK ***
[  117.026009]
[  117.026009] no locks held by posixcputmr/0/6.
[  117.026009]
[  117.026009] stack backtrace:
[  117.026009] Pid: 6, comm: posixcputmr/0 Not tainted 
3.0.0-1.rt6.1.fc15.ccrma.x86_64.rt #1
[  117.026009] Call Trace:
[  117.026009]  [<ffffffff814e6278>] print_usage_bug+0x1e3/0x1f4
[  117.026009]  [<ffffffff810154e5>] ? save_stack_trace+0x2c/0x49
[  117.026009]  [<ffffffff8108be73>] ? check_usage_forwards+0xa6/0xa6
[  117.026009]  [<ffffffff8108c4f7>] mark_lock+0x106/0x220
[  117.026009]  [<ffffffff8108c956>] __lock_acquire+0x345/0xd0c
[  117.026009]  [<ffffffff8108a020>] ? trace_hardirqs_off+0xd/0xf
[  117.026009]  [<ffffffff8108a5f5>] ? 
lock_release_holdtime.part.10+0x59/0x62
[  117.026009]  [<ffffffff814ef69f>] ? _raw_spin_unlock_irq+0x2d/0x59
[  117.026009]  [<ffffffff8107b6f1>] ? __run_posix_cpu_timers+0x8f/0x353
[  117.026009]  [<ffffffff8108d820>] lock_acquire+0xf3/0x13e
[  117.026009]  [<ffffffff8107b6f1>] ? __run_posix_cpu_timers+0x8f/0x353
[  117.026009]  [<ffffffff8104aacd>] ? finish_task_switch+0x7c/0xf5
[  117.026009]  [<ffffffff8104aa90>] ? finish_task_switch+0x3f/0xf5
[  117.026009]  [<ffffffff814ef322>] _raw_spin_lock+0x45/0x79
[  117.026009]  [<ffffffff8107b6f1>] ? __run_posix_cpu_timers+0x8f/0x353
[  117.026009]  [<ffffffff8107b6f1>] __run_posix_cpu_timers+0x8f/0x353
[  117.026009]  [<ffffffff81049045>] ? need_resched+0x23/0x2d
[  117.026009]  [<ffffffff8107ba6c>] posix_cpu_timers_thread+0xb7/0x14b
[  117.026009]  [<ffffffff8107b9b5>] ? __run_posix_cpu_timers+0x353/0x353
[  117.026009]  [<ffffffff810785da>] kthread+0x99/0xa1
[  117.026009]  [<ffffffff8108a020>] ? trace_hardirqs_off+0xd/0xf
[  117.026009]  [<ffffffff8108dc5b>] ? trace_hardirqs_on+0xd/0xf
[  117.026009]  [<ffffffff814f67a4>] kernel_thread_helper+0x4/0x10
[  117.026009]  [<ffffffff814efa58>] ? retint_restore_args+0x13/0x13
[  117.026009]  [<ffffffff81078541>] ? __init_kthread_worker+0x8c/0x8c
[  117.026009]  [<ffffffff814f67a0>] ? gs_change+0x13/0x13

----------------------------------------------
lsmod:

Module                  Size  Used by
fuse                   70197  3
sunrpc                222384  1
powernow_k8            29079  1
nf_conntrack_ipv4      14700  1
nf_defrag_ipv4         12673  1 nf_conntrack_ipv4
xt_state               12578  1
nf_conntrack           81796  2 nf_conntrack_ipv4,xt_state
snd_ice1712            63535  0
snd_ice17xx_ak4xxx     13128  1 snd_ice1712
snd_ak4xxx_adda        18480  2 snd_ice1712,snd_ice17xx_ak4xxx
snd_cs8427             14054  1 snd_ice1712
snd_ac97_codec        121717  1 snd_ice1712
snd_seq                61755  0
snd_pcm                85387  2 snd_ice1712,snd_ac97_codec
xfs                   763810  1
snd_timer              29239  2 snd_seq,snd_pcm
snd_page_alloc         14039  1 snd_pcm
ac97_bus               12682  1 snd_ac97_codec
snd_i2c                14050  2 snd_ice1712,snd_cs8427
snd_mpu401_uart        14244  1 snd_ice1712
ppdev                  17712  0
snd_rawmidi            25881  1 snd_mpu401_uart
snd_seq_device         14209  2 snd_seq,snd_rawmidi
nv_tco                 13564  0
snd                    71052  11 
snd_ice1712,snd_ak4xxx_adda,snd_cs8427,snd_ac97_codec,snd_seq,snd_pcm,snd_timer,snd_i2c,snd_mpu401_uart,snd_rawmidi,snd_seq_device
parport_pc             28208  0
edac_core              48073  0
forcedeth              55667  0
edac_mce_amd           18786  0
parport                40931  2 ppdev,parport_pc
asus_atk0110           18767  0
k8temp                 13123  0
i2c_nforce2            13166  0
soundcore              14562  1 snd
firewire_ohci          36465  0
uas                    17919  0
firewire_core          62263  1 firewire_ohci
usb_storage            52308  0
ata_generic            12899  0
crc_itu_t              12579  1 firewire_core
pata_jmicron           12747  0
pata_acpi              13027  0
sata_nv                27864  6
pata_amd               18256  1
nouveau               556740  3
ttm                    65945  1 nouveau
drm_kms_helper         36330  1 nouveau
drm                   206243  5 nouveau,ttm,drm_kms_helper
i2c_algo_bit           13246  1 nouveau
i2c_core               34149  5 
i2c_nforce2,nouveau,drm_kms_helper,drm,i2c_algo_bit
mxm_wmi                12823  1 nouveau
wmi                    18697  1 mxm_wmi
video                  19210  1 nouveau

----------------------------------------------
lspci:

00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
00:01.2 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1)
00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2)
00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2)
00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:09.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:07.0 Multimedia audio controller: VIA Technologies Inc. ICE1712 
[Envy24] PCI Multi-Channel I/O Controller (rev 02)
01:0b.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A 
IEEE-1394a-2000 Controller (PHY/Link)
02:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial 
ATA Controller (rev 03)
02:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA 
Controller (rev 03)
03:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce 8400 
GS] (rev a1)
