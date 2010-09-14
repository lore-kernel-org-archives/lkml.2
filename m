Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0INOjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:39:44 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:48373 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab0INOjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:39:42 -0400
Date: Tue, 14 Sep 2010 16:39:41 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: 1000_clean_tx_irq: Detected Tx Unit Hang / sch_generic.c:261
  dev_watchdog+0xbd/0x15d()
Message-ID: <20100914143941.GA3979@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Using virtualbox w/ kernel 2.6.32-trunk-686-bigmem there was this msg in the logs:

[    0.000000] Linux version 2.6.32-trunk-686-bigmem (Debian 2.6.32-5) (ben@decadent.org.uk) (gcc version 4.3.4 (Debian 4.3.4-6) ) #1 SMP Sun Jan 10 07:12:17 UTC 2010
[    3.800101] e1000 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.800101] e1000 0000:00:08.0: setting latency timer to 64
[    4.721091] e1000: 0000:00:08.0: e1000_probe: (PCI:33MHz:32-bit) 08:00:27:aa:bb:cc
[    4.792100] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[   21.776125] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   22.153115] eth0: link up, 100Mbps, full-duplex
[   32.460164] eth1: no IPv6 routers present
[  324.004821] e1000: eth1: e1000_clean_tx_irq: Detected Tx Unit Hang
[  324.004821]   Tx Queue             <0>
[  324.004821]   TDH                  <ff>
[  324.004821]   TDT                  <1>
[  324.004821]   next_to_use          <1>
[  324.004821]   next_to_clean        <ff>
[  324.004821] buffer_info[next_to_clean]
[  324.004821]   time_stamp           <1528>
[  324.004821]   next_to_watch        <0>
[  324.004821]   jiffies              <1771>
[  324.004821]   next_to_watch.status <0>
[  326.004767] e1000: eth1: e1000_clean_tx_irq: Detected Tx Unit Hang
[  326.004767]   Tx Queue             <0>
[  326.004767]   TDH                  <ff>
[  326.004767]   TDT                  <1>
[  326.004767]   next_to_use          <1>
[  326.004767]   next_to_clean        <ff>
[  326.004767] buffer_info[next_to_clean]
[  326.004767]   time_stamp           <1528>
[  326.004767]   next_to_watch        <0>
[  326.004767]   jiffies              <1965>
[  326.004767]   next_to_watch.status <0>
[  327.004048] ------------[ cut here ]------------
[  327.004048] WARNING: at /tmp/buildd/linux-2.6-2.6.32/debian/build/source_i386_none/net/sched/sch_generic.c:261 dev_watchdog+0xbd/0x15d()
[  327.004048] Hardware name: VirtualBox
[  327.004048] NETDEV WATCHDOG: eth1 (e1000): transmit queue 0 timed out
[  327.004048] Modules linked in: vboxvideo drm agpgart ppdev lp vboxvfs nls_base fuse loop dm_crypt dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm parport_pc i2c_piix4 snd_timer psmouse parport snd ac battery i2c_core pcspkr serio_raw processor evdev soundcore snd_page_alloc vboxguest ext3 jbd mbcache ide_gd_mod ata_generic libata scsi_mod ide_pci_generic floppy piix e1000 button ide_core pcnet32 mii thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[  327.004048] Pid: 0, comm: swapper Not tainted 2.6.32-trunk-686-bigmem #1
[  327.004048] Call Trace:
[  327.004048]  [<c1036af1>] ? warn_slowpath_common+0x5e/0x8a
[  327.004048]  [<c11e76d0>] ? dev_watchdog+0x0/0x15d
[  327.004048]  [<c1036b4f>] ? warn_slowpath_fmt+0x26/0x2a
[  327.004048]  [<c11e778d>] ? dev_watchdog+0xbd/0x15d
[  327.004048]  [<c1026a98>] ? enqueue_task+0x68/0x73
[  327.004048]  [<c1033994>] ? try_to_wake_up+0x25d/0x269
[  327.004048]  [<c1034631>] ? scheduler_tick+0xd3/0x1ec
[  327.004048]  [<c10417cc>] ? run_timer_softirq+0x16a/0x1eb
[  327.004048]  [<c103bbd0>] ? __do_softirq+0xaa/0x151
[  327.004048]  [<c103bca8>] ? do_softirq+0x31/0x3c
[  327.004048]  [<c103bd7e>] ? irq_exit+0x26/0x58
[  327.004048]  [<c1019b28>] ? smp_apic_timer_interrupt+0x6c/0x76
[  327.004048]  [<c1008995>] ? apic_timer_interrupt+0x31/0x38
[  327.004048]  [<c10400e0>] ? ftrace_profile_timer_start+0x1a/0xab
[  327.004048]  [<c10202ec>] ? native_safe_halt+0x2/0x3
[  327.004048]  [<c100decb>] ? default_idle+0x3c/0x5a
[  327.004048]  [<c10071e8>] ? cpu_idle+0x89/0xa5
[  327.004048]  [<c13b4811>] ? start_kernel+0x30c/0x311
[  327.004048] ---[ end trace de6e4e7bd967f783 ]---
[  327.092180] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[  937.503622] hrtimer: interrupt too slow, forcing clock min delta to 42884154 ns


                Cheers,

                      Nils

