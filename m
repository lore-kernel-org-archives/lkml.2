Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1DGNLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:11:22 -0400
Received: from buffalo.tchmachines.com ([208.76.86.16]:41159 "EHLO
	buffalo.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1DGNLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:11:20 -0400
X-Greylist: delayed 2793 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Apr 2011 09:11:20 EDT
Subject: aynchronous scan fails to boot
From: raz ben yehuda <raz@scalemp.com>
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 15:23:47 +0300
Message-ID: <1302179027.11185.15.camel@raz.scalemp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - buffalo.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan Hello

I am trying to boot a machine with 7 LSI disks instances so you
obviously understand that your new feature of asynchronous scsi probe
was more than appealing. 
Two problems:

1. Somehow, if the machine is boot all its cpus the boot hangs[1]. It
succeeds only when maxcpus=1 [2]. 

2. async scsi probing does not seem to speed things at all[3].


Thank you

raz

[1]
[    1.540000] Pid: 1, comm: swapper Not tainted 2.6.38-2.vSMP #1
[    1.540000] Call Trace:
[    1.540000]  <NMI>  [<ffffffff81045c31>] ? intel_pmu_handle_irq
+0x471/0x480
[    1.540000]  [<fffffgfff81045c31>] ? intel_pmu_handle_irq+0x471/0x480
[    1.540000]  [<ffffffff81074bec>] ? warn_slowpath_common+0x8c/0xc0
[    1.540000]  [<ffffffff81074cf6>] ? warn_slowpath_fmt+0x56/0x60
[    1.540000]  [<ffffffff81041cca>] ? x86_perf_event_update+0x5a/0xc0
[    1.540000]  [<ffffffff81043093>] ? x86_perf_event_set_period
+0xe3/0x180
[    1.540000]  [<ffffffff81045c31>] ? intel_pmu_handle_irq+0x471/0x480
[    1.540000]  [<ffffffff81044d31>] ? perf_event_nmi_handler+0x41/0xb0
[    1.540000]  [<ffffffff81092315>] ? notifier_call_chain+0x45/0x90
[    1.540000]  [<ffffffff810923ed>] ? notify_die+0x2d/0x40
[    1.540000]  [<ffffffff81035a94>] ?  do_nmi+0x64/0x220
[    1.540000]  [<ffffffff815eafb0>] ? nmi+0x20/0x30
[    1.540000]  [<ffffffff812d6810>] ? delay_tsc+0x0/0x80
[    1.540000]  [<ffffffff8103c570>] ? native_read_tsc+0x0/0x20
[    1.540000]  <<EOE>>  [<ffffffff812d685a>] ? delay_tsc+0x4a/0x80
[    1.540000]  [<ffffffff815e4625>] ? native_cpu_up+0x495/0x770
[    1.540000]  [<ffffffff815e3b80>] ? do_fork_idle+0x0/0x20
[    1.540000]  [<ffffffff815e62a7>] ? cpu_up+0xf7/0x140
[    1.540000]  [<ffffffff81b57b58>] ? kernel_init+0x238/0x350
[    1.540000]  [<ffffffff810350e4>] ? kernel_thread_helper+0x4/0x10
[    1.540000]  [<ffffffff81b57920>] ? kernel_init+0x0/0x350
[    1.540000]  [<ffffffff810350e0>] ? kernel_thread_helper+0x0/0x10
[    1.540000] ---[ end trace 4eaa2a86a8e2da22 ]---

[2] This machine has 84 processors.

[3] each disk boots about 30 seconds. entire boot take is allways over
210 seconds.The bellow is a snippet of boot dmesg.

[  162.243568] sd 4:0:1:0: [sdj] Attached SCSI disk
[  163.600064] ioc5: LSISAS1068E B3: Capabilities={Initiator}
[  163.606298] mptsas 0000:52:00.0: setting latency timer to 64
[  193.544630] scsi5 : ioc5: LSISAS1068E B3, FwRev=00192f00h, Ports=1,
MaxQ=266, IRQ=48
[  193.596180] mptsas: ioc5: attaching ssp device: fw_channel 0, fw_id
0, phy 0, sas_addr 0x5000c5001735fbb5
[  193.607870] scsi 5:0:0:0: Direct-Access     SEAGATE  ST9146803SS
FS04 PQ: 0 ANSI: 5
[  193.618903] sd 5:0:0:0: Attached scsi generic sg10 type 0
[  193.625086] sd 5:0:0:0: [sdk] 286749480 512-byte logical blocks: (146
GB/136 GiB)
[  193.634607] mptsas: ioc5: attaching ssp device: fw_channel 0, fw_id
1, phy 1, sas_addr 0x5000c50017360b61
[  193.645609] sd 5:0:0:0: [sdk] Write Protect is off
[  193.650740] sd 5:0:0:0: [sdk] Mode Sense: b3 00 10 08
[  193.651233] scsi 5:0:1:0: Direct-Access     SEAGATE  ST9146803SS
FS04 PQ: 0 ANSI: 5
[  193.660595] sd 5:0:0:0: [sdk] Write cache: disabled, read cache:
enabled, supports DPO and FUA
[  193.671527] sd 5:0:1:0: Attached scsi generic sg11 type 0
[  193.677776] sd 5:0:1:0: [sdl] 286749480 512-byte logical blocks: (146
GB/136 GiB)
[  193.687686] mptsas 0000:62:00.0: PCI INT A -> GSI 53 (level, low) ->
IRQ 53
[  193.695322] mptbase: ioc6: Initiating bringup
[  193.700204] sd 5:0:1:0: [sdl] Write Protect is off
[  193.705304] sd 5:0:1:0: [sdl] Mode Sense: b3 00 10 08
[  193.705355]  sdk: sdk1 sdk2 sdk3



