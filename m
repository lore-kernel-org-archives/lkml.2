Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab0GAPoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:44:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:52715 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab0GAPoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:44:22 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: LKML <linux-kernel@vger.kernel.org>
Subject: Dynamic Debug broken on 2.6.35-rc3?
Date: Thu, 1 Jul 2010 17:44:19 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: jbaron@redhat.com, gnb@melbourne.sgi.com
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TfLLMLgdlsM+UsW"
Message-Id: <201007011744.19564.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_TfLLMLgdlsM+UsW
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

Doing:
echo "file ec.c +p" >/sys/kernel/debug/dynamic_debug/control

I got x
RIP: 0010:[<ffffffff81251267>]  [<ffffffff81251267>] 
ddebug_change+0x87/0x240

More output is in the attachment.

Thanks for any hints,

      Thomas

--Boundary-00=_TfLLMLgdlsM+UsW
Content-Type: text/plain;
  charset="UTF-8";
  name="screen-exchange"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="screen-exchange"

airey login: airey login: [  180.084952] BUG: unable to handle kernel paging request at ffffffffa01b6c38
[  180.151314] IP: [<ffffffff81251267>] ddebug_change+0x87/0x240
[  180.210203] PGD 1a06067 PUD 1a0a063 PMD 31d57f067 PTE 0
[  180.263859] Oops: 0000 [#1] SMP
[  180.297059] last sysfs file: /sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
[  180.376304] CPU 3
[  180.394951] Modules linked in: iptable_filter ip_tables x_tables autofs4 nfs lockd fscache nfs_acl auth_rpcgss sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave pcc_cpufreq mperf microcode fuse reiserfs loop dm_mod iTCO_wdt power_meter hpilo bnx2 tpm_tis hpwdt tpm i7core_edac iTCO_vendor_support edac_core serio_raw pcspkr tpm_bios joydev button container usbhid uhci_hcd ehci_hcd usbcore edd fan thermal processor thermal_sys hpsa cciss scsi_mod
[  180.820993]
[  180.835142] Pid: 4731, comm: bash Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1 /ProLiant DL380 G7
[  180.929285] RIP: 0010:[<ffffffff81251267>]  [<ffffffff81251267>] ddebug_change+0x87/0x240
[  181.019416] RSP: 0018:ffff88019e87fd08  EFLAGS: 00010282
[  181.081030] RAX: 0000000000000000 RBX: ffff88019e87feb8 RCX: 000000000000007b
[  181.155620] RDX: ffff88019e87fd6d RSI: ffffffffa00996f2 RDI: 0000000000000000
[  181.228453] RBP: 0000000000000001 R08: ffff88019e87fd74 R09: 00007f1e27b40e10
[  181.301645] R10: 00007f1e27b40e10 R11: 0000000000000246 R12: ffffffffa01b6c28
[  181.375301] R13: 0000000000000000 R14: ffff88031a29fb40 R15: 00000000ffffffff
[  181.462542] FS:  00007f1e28179700(0000) GS:ffff8801a5620000(0000) knlGS:0000000000000000
[  181.544493] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  181.603704] CR2: ffffffffa01b6c38 CR3: 000000019d580000 CR4: 00000000000006e0
[  181.692283] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.764272] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.837717] Process bash (pid: 4731, threadinfo ffff88019e87e000, task ffff88019d7be800)
[  181.914729] Stack:
[  181.933843]  ffff88019e87fd6d ffffffffa00996a9 ffff88031e89b6d8 000000000000000d
[  182.005775] <0> 000000000000000d ffff88019e87feb8 0000000000000002 ffff88019e87fe68
[  182.097157] <0> 0000000000000000 ffffffff81251892 0000000002aad70a ffff88019e87ff58
[  182.184155] Call Trace:
[  182.209545]  [<ffffffff81251892>] ddebug_proc_write+0x142/0x150
[  182.269894]  [<ffffffff8113aa86>] vfs_write+0xb6/0x190
[  182.320898]  [<ffffffff8113adce>] sys_write+0x4e/0x90
[  182.371449]  [<ffffffff81002ebb>] system_call_fastpath+0x16/0x1b
[  182.433219] DWARF2 unwinder stuck at system_call_fastpath+0x16/0x1b
[  182.498920]
[  182.514114] Leftover inexact backtrace:
[  182.514115]
[  182.570444] Code: 01 00 00 41 8b 4e 18 85 c9 0f 84 66 01 00 00 45 31 ed 66 90 49 63 c5 48 8b 13 4c 8d 24 80 49 c1 e4 03 4d 03 66 20 48 85 d2 74 50 <49> 8b 4c 24 10 48 89 d7 48 89 14 24 48 89 ce 48 89 4c 24 08 e8
[  182.756238] RIP  [<ffffffff81251267>] ddebug_change+0x87/0x240
[  182.812812]  RSP <ffff88019e87fd08>
[  182.845880] CR2: ffffffffa01b6c38
[  182.967417] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967423]
[  182.967427] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967430]
[  182.967433] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967436]
[  182.967440] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967443]
[  182.967446] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967449]
[  182.967453] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967456]
[  182.967459] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967462]
[  182.967465] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967468]
[  182.967471] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967473]
[  182.967476] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967479]
[  182.967482] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967484]
[  182.967487] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967490]
[  182.967493] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967495]
[  182.967498] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967501]
[  182.967504] Kernel panic - not syncing: An NMI occurred, please see the Integrated Management Log for details.
[  182.967507]
[  182.967511] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967516] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967520] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967525] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967530] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967535] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967539] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967544] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967548] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967553] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967557] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967561] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967566] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967570] Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  182.967574] Call Trace:
[  182.967576] Call Trace:
[  182.967578] Call Trace:
[  182.967580] Call Trace:
[  182.967582] Call Trace:
[  182.967584] Call Trace:
[  182.967587] Call Trace:
[  182.967589] Call Trace:
[  182.967591] Call Trace:
[  182.967594] Call Trace:
[  182.967596] Call Trace:
[  182.967598] Call Trace:
[  182.967600] Call Trace:
[  182.967602] Call Trace:
[  182.967616]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967624]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967631]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967637]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967643]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967649]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967654]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967659]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967664]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967669]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967674]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967678]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967684]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967693]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  182.967702]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967708]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967712]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967717]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967722]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967726]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967730]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967734]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967738]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967742]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967747]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967751]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967757]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967765]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  182.967770]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967774]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967778]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967782]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967787]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967791]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967796]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967800]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967803]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967807]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967811]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967816]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967822]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967830]  [<ffffffff8144d681>] panic+0x94/0x118
[  182.967837]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967847]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967855]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967862]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967869]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967877]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967884]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967890]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967897]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967904]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967911]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967918]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967927]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967936]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]
[  182.967944]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.967952]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.967957]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.967963]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.967968]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.967975]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.967980]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.967985]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.967990]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.967996]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.968001]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.968009]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.968016]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.968022]  [<ffffffff81453a15>] notifier_call_chain+0x45/0x60
[  182.968027]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968032]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968036]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968041]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968046]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968050]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968054]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968059]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968064]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968069]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968076]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968083]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968089]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968094]  [<ffffffff81453a8d>] notify_die+0x2d/0x40
[  182.968099]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968104]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968109]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968114]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968120]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968124]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968129]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968134]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968139]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968145]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968151]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968158]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968163]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968168]  [<ffffffff81450c4c>] default_do_nmi+0xcc/0x260
[  182.968173]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968177]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968182]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968187]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968191]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968196]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968201]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968205]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968211]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968217]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968224]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968229]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968233]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968238]  [<ffffffff81450fb8>] do_nmi+0x68/0x70
[  182.968242]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968246]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968251]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968255]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968259]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968264]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968268]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968274]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968279]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968284]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968288]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968292]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968296]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.968301]  [<ffffffff8145097a>] nmi+0x1a/0x20
[  182.970855] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.970857]
[  182.970858] Leftover inexact backtrace:
[  182.970859]
[  182.970861]  <NMI>  [<ffffffff81078490>] ? sched_clock_idle_sleep_event+0x10/0x20
[  182.970867]  <<EOE>>  [<ffffffffa007bed4>] ? acpi_idle_enter_bm+0x129/0x22f [processor]
[  182.970882]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.970887]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.971646] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.971648]
[  182.971649] Leftover inexact backtrace:
[  182.971650]
[  182.971652]  <NMI>  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.971660]  <<EOE>>  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.971675]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.971679]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972327] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972329]
[  182.972331] Leftover inexact backtrace:
[  182.972333]
[  182.972337]  <NMI> DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972341] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972346]
[  182.972349]
[  182.972354]  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972357] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972361] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972363] Leftover inexact backtrace:
[  182.972365]
[  182.972367] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972370] Leftover inexact backtrace:
[  182.972371]
[  182.972375]  <<EOE>>
[  182.972378]
[  182.972380]  <NMI>
[  182.972384]  <NMI> DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972389] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972392] Leftover inexact backtrace:
[  182.972393]
[  182.972396] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972399] Leftover inexact backtrace:
[  182.972400]
[  182.972402] Leftover inexact backtrace:
[  182.972404]
[  182.972406] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972409] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972412]
[  182.972414]
[  182.972416] DWARF2 unwinder stuck at nmi+0x1a/0x20
[  182.972418]  <NMI>
[  182.972426]  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972429]  <NMI>  <NMI>  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972438]
[  182.972443]  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972446]
[  182.972448] Leftover inexact backtrace:
[  182.972449]
[  182.972451] Leftover inexact backtrace:
[  182.972452]
[  182.972454]
[  182.972456] Leftover inexact backtrace:
[  182.972458]
[  182.972462]  <<EOE>> Leftover inexact backtrace:
[  182.972465]
[  182.972467]  <<EOE>> Leftover inexact backtrace:
[  182.972470]
[  182.972472]  <NMI>  <NMI> Leftover inexact backtrace:
[  182.972476]
[  182.972478]  <NMI>  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972488]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972493]  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972499]  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972503]  <NMI>  <NMI>  <NMI>  <<EOE>>  <<EOE>>  <<EOE>>  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972526]  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972531]  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972537]  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972543]  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972548]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972555]  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972559]  <<EOE>>  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972565]  <<EOE>>  [<ffffffff8100bc6e>] ? mwait_idle_with_hints+0x9e/0x110
[  182.972571]  <<EOE>>  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972585]  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972593]  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972598]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972601]  <<EOE>>  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972608]  <<EOE>>  <<EOE>>  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972627]  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972635]  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972641]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972646]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972651]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972656]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972662]  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972668]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972676]  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972683]  [<ffffffffa007bf52>] ? acpi_idle_enter_bm+0x1a7/0x22f [processor]
[  182.972692]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972696]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972701]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972707]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972712]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972717]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972721]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972727]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972733]  [<ffffffff8134c6bf>] ? cpuidle_idle_call+0x9f/0x130
[  182.972739]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972744]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972748]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972753]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972758]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  182.972763]  [<ffffffff8100125c>] ? cpu_idle+0x4c/0xa0
[  184.039785] Rebooting in 100 seconds..
[  184.039877] Rebooting in 100 seconds..
[  184.039884] Rebooting in 100 seconds..
[  184.039922] Rebooting in 100 seconds..
[  184.039941] Rebooting in 100 seconds..
[  184.039949] Rebooting in 100 seconds..
[  184.039952] Rebooting in 100 seconds..
[  184.039954] Rebooting in 100 seconds..
[  184.039958] Rebooting in 100 seconds..
[  184.039970] Rebooting in 100 seconds..
[  184.040115] Rebooting in 100 seconds..
[  184.040143] Rebooting in 100 seconds..
[  184.057651] Rebooting in 100 seconds..
[  184.070156] Rebooting in 100 seconds..Pid: 0, comm: swapper Not tainted 2.6.35-rc3-0.0.10.4cae135-default #1
[  199.102545] Call Trace:
[  199.126562]  [<ffffffff81005919>] dump_trace+0x69/0x2e0
[  199.179537]  [<ffffffff8144d5e7>] dump_stack+0x69/0x6f
[  199.230702]  [<ffffffff8144d681>] panic+0x94/0x118
[  199.280446]  [<ffffffffa02183f6>] hpwdt_pretimeout+0xb6/0xc0 [hpwdt]

--Boundary-00=_TfLLMLgdlsM+UsW--
