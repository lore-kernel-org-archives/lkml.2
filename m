Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0LADJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 22:09:28 -0500
Received: from smtp108.rog.mail.re2.yahoo.com ([68.142.225.206]:35837 "HELO
	smtp108.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753948Ab0LADJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 22:09:26 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 22:09:26 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:Organization:X-KMail-Transport:X-KMail-Fcc:X-KMail-Drafts:X-KMail-Templates:User-Agent:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=VifvOBGp6zraF3h8bk3al1GbYHfU0QLc8ICaSpfv8YfT2RcwCqmcPkePdTsx0qi7+tHHYsd5b0kPW0UZK6xvIz/tPZZEZ6lDbfvMkmIa4CfUOURSY0hGWczVdPbFw8o9jjLDX+U04m/NJcdvpQPxIxDTXQUFvWUJPbJy6xIibSk=  ;
Message-ID: <227948.41215.qm@smtp108.rog.mail.re2.yahoo.com>
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: V6Gm_uIVM1kiYfq7lAsdN6DLeUOK3_UI.FoHKvwJC3afb0n
 ho9QBAjWAanJnTW20t7bJ7D6.5vAK31Tn3uzr1h9HDCt.CIQ4mVRP6P2twrv
 Qnhc0RWSrGZytSjjxghXjc6xRyO5.xj80rrZFMc_sQjtSB64K9fRMd6I81.o
 o87cnW8eu9SSeCWA9VS.0qmfsuTKmLOtPEUMbohoytdI4lH.xhcSSkaynYvI
 wZHugR7CUeg--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [via_rhine][NET][2.6.35.6] - Transmit queue 0 timed out during load maybe broken in recent kernels too?
Date: Tue, 30 Nov 2010 22:02:36 -0500
Organization: sh0n.net
X-KMail-Transport: Shawn Starr
X-KMail-Fcc: 14
X-KMail-Drafts: 6
X-KMail-Templates: 15
User-Agent: KMail/4.6 pre (Linux/2.6.37-0.1.rc2.git0.fc15.x86_64; KDE/4.5.80; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello folks,

On my production internet services box (inappropriately named :) running Fedora 14 (kernel 2.6.35.6-4X-fc14) when using the onboard VIA Rhine II ethernet controller, I am getting timeouts when doing higher bandwidth downloads (such as yum 
rpm downloads). I also had issues with .34 as well.

For now, I've switched to use an PCI 3c980C card (which probably better anyway)

If anyone would like me to throw .37-rc4 I can do that and see what we get.

Dump below:

Nov  8 21:28:04 coredump kernel: [ 4593.708019] ------------[ cut here ]------------
Nov  8 21:28:04 coredump kernel: [ 4593.708035] WARNING: at net/sched/sch_generic.c:258 dev_watchdog+0xf3/0x167()
Nov  8 21:28:04 coredump kernel: [ 4593.708038] Hardware name:
Nov  8 21:28:04 coredump kernel: [ 4593.708041] NETDEV WATCHDOG: eth1 (via-rhine): transmit queue 0 timed out
Nov  8 21:28:04 coredump kernel: [ 4593.708043] Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs hwmon_vid sunrpc cpufreq_ondemand powernow_k8 freq_table mperf bridge stp llc ipv6 xt_recent snd_via82xx gameport snd_ac97_codec 
ac97_bus snd_seq snd_pcm ppdev snd_timer parport_pc parport snd_page_alloc snd_mpu401_uart shpchp k8temp 3c59x edac_core via_rhine snd_rawmidi microcode i2c_viapro snd_seq_device edac_mce_amd snd soundcore mii pata_acpi ata_generic 
sata_via pata_via radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Nov  8 21:28:04 coredump kernel: [ 4593.708085] Pid: 2407, comm: applydeltarpm Not tainted 2.6.35.6-45.fc14.x86_64 #1
Nov  8 21:28:04 coredump kernel: [ 4593.708088] Call Trace:
Nov  8 21:28:04 coredump kernel: [ 4593.708091]  <IRQ>  [<ffffffff8104d7c1>] warn_slowpath_common+0x85/0x9d
Nov  8 21:28:04 coredump kernel: [ 4593.708103]  [<ffffffff8104d87c>] warn_slowpath_fmt+0x46/0x48
Nov  8 21:28:04 coredump kernel: [ 4593.708107]  [<ffffffff813d4f5e>] ? netif_tx_lock+0x44/0x6d
Nov  8 21:28:04 coredump kernel: [ 4593.708111]  [<ffffffff813d50c8>] dev_watchdog+0xf3/0x167
Nov  8 21:28:04 coredump kernel: [ 4593.708118]  [<ffffffff8101057c>] ? native_sched_clock+0x35/0x37
Nov  8 21:28:04 coredump kernel: [ 4593.708123]  [<ffffffff8106826f>] ? run_posix_cpu_timers+0x2a/0x5bb
Nov  8 21:28:04 coredump kernel: [ 4593.708128]  [<ffffffff81069971>] ? hrtimer_run_pending+0x17/0xc7
Nov  8 21:28:04 coredump kernel: [ 4593.708132]  [<ffffffff8104022f>] ? task_tick_fair+0x2e/0xf7
Nov  8 21:28:04 coredump kernel: [ 4593.708138]  [<ffffffff81059c28>] run_timer_softirq+0x1d6/0x2a3
Nov  8 21:28:04 coredump kernel: [ 4593.708143]  [<ffffffff813d4fd5>] ? dev_watchdog+0x0/0x167
Nov  8 21:28:04 coredump kernel: [ 4593.708147]  [<ffffffff81021fee>] ? apic_write+0x16/0x18
Nov  8 21:28:04 coredump kernel: [ 4593.708154]  [<ffffffff81053839>] __do_softirq+0xdd/0x199
Nov  8 21:28:04 coredump kernel: [ 4593.708159]  [<ffffffff810724ac>] ? tick_dev_program_event+0x36/0xf4
Nov  8 21:28:04 coredump kernel: [ 4593.708164]  [<ffffffff81072594>] ? tick_program_event+0x2a/0x2c
Nov  8 21:28:04 coredump kernel: [ 4593.708168]  [<ffffffff8100abdc>] call_softirq+0x1c/0x30
Nov  8 21:28:04 coredump kernel: [ 4593.708171]  [<ffffffff8100c338>] do_softirq+0x46/0x82
Nov  8 21:28:04 coredump kernel: [ 4593.708175]  [<ffffffff81053999>] irq_exit+0x3b/0x7d
Nov  8 21:28:04 coredump kernel: [ 4593.708180]  [<ffffffff8146f08a>] smp_apic_timer_interrupt+0x7e/0x8c
Nov  8 21:28:04 coredump kernel: [ 4593.708184]  [<ffffffff8100a693>] apic_timer_interrupt+0x13/0x20
Nov  8 21:28:04 coredump kernel: [ 4593.708186]  <EOI>
Nov  8 21:28:04 coredump kernel: [ 4593.708189] ---[ end trace 001dfbef831948c5 ]---
Nov  8 21:28:04 coredump kernel: [ 4593.708334] eth1: Transmit timed out, status 1003, PHY status 786d, resetting...
Nov  8 21:28:04 coredump kernel: [ 4593.709012] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1

Thanks,
 Shawn


