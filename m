Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1HXNCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:02:42 -0400
Received: from frankvm.xs4all.nl ([83.163.148.79]:40042 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751090Ab1HXNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:02:40 -0400
Date: Wed, 24 Aug 2011 15:02:38 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: 3.0.3 kernel BUG at kernel/timer.c:1035
Message-ID: <20110824130238.GA24543@janus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got several of these (logged via netconsole):

 kernel BUG at kernel/timer.c:1035!
 invalid opcode: 0000 [#1]
 PREEMPT
 SMP

 Modules linked in:
  [last unloaded: scsi_wait_scan]


 Pid: 0, comm: swapper Not tainted 3.0.3-x263 #1
  Dell Inc.                 OptiPlex GX620
 /0F8098

 EIP: 0060:[<c107adfe>] EFLAGS: 00010812 CPU: 0
 EIP is at cascade+0x6e/0x70
 EAX: 6b6b6b6a EBX: c1bbb480 ECX: c1ac2d50 EDX: f541335c
 ESI: c1ac2d50 EDI: f600bf60 EBP: f600bf74 ESP: f600bf5c
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 Process swapper (pid: 0, ti=f600a000 task=c1aba320 task.ti=c1a94000)
 Stack:
  00000034
  f541335c
  c1ac2d50
  c1bbb480
  00000000
  f600bfac
  f600bfc0
  c107af48

  00000004
  00000000
  f600bfb8
  c1069265
  00000000
  f600bfa8
  c1bbc29c
  c1bbc09c

  c1bbbe9c
  c106a28b
  00000100
  c1bbbc9c
  c106a28b
  00000100
  00000041
  c1a99a84

 Call Trace:
  [<c107af48>] run_timer_softirq+0x148/0x1e0
  [<c1069265>] ? rebalance_domains+0x135/0x160
  [<c106a28b>] ? get_parent_ip+0xb/0x40
  [<c106a28b>] ? get_parent_ip+0xb/0x40
  [<c1075098>] __do_softirq+0x78/0x100
  [<c1075020>] ? local_bh_enable+0xa0/0xa0
  <IRQ>

  [<c10753ad>] ? irq_exit+0x5d/0x70
  [<c104df53>] ? smp_apic_timer_interrupt+0x53/0x90
  [<c178fa22>] ? apic_timer_interrupt+0x2a/0x30
  [<c103d3ed>] ? mwait_idle+0x4d/0x80
  [<c1034b0a>] ? cpu_idle+0x3a/0x80
  [<c176dc3b>] ? rest_init+0x7b/0x80
  [<c1b1471b>] ? start_kernel+0x2e2/0x2e8
  [<c1b141c1>] ? loglevel+0x1a/0x1a
  [<c1b140b3>] ? i386_start_kernel+0xb3/0xbb


Got one stack trace on 64 bit:

 kernel BUG at kernel/timer.c:1035!
 invalid opcode: 0000 [#1]
 PREEMPT
 SMP

 CPU 1

 Modules linked in:
  vmthrottle
  radeon
  [last unloaded: scsi_wait_scan]


 Pid: 4312, comm: qemu Not tainted 3.0.3-x263lm #1
  Dell Inc.                 Dell DXP051
 /0FJ030

 RIP: 0010:[<ffffffff8109438b>]
  [<ffffffff8109438b>] cascade+0x9b/0xa0
 RSP: 0018:ffff8800dfc83e40  EFLAGS: 00210096
 RAX: 6b6b6b6b6b6b6b6a RBX: ffff8800dfc83e40 RCX: ffff8800df0ad080
 RDX: ffff8800dfc83e40 RSI: ffff8800daa7c838 RDI: ffff8800df0ac000
 RBP: ffff8800dfc83e70 R08: ffff8800dfc8c640 R09: ffff8800dfc90df8
 R10: 0000000000000001 R11: ffffffff8189c230 R12: ffff8800df0ac000
 R13: ffff8800dfc83e40 R14: 0000000000000005 R15: 0000000000000001
 FS:  0000000000000000(0000) GS:ffff8800dfc80000(0063) knlGS:00000000f760b770
 CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
 CR2: 00000000080582b8 CR3: 00000000d1b44000 CR4: 00000000000026e0
 DR0: 0000000000000001 DR1: 0000000000000002 DR2: 0000000000000001
 DR3: 000000000000000a DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process qemu (pid: 4312, threadinfo ffff8800c6052000, task ffff8800d1ae9c80)
 Stack:
  ffff8800daa7c838
  ffff8800daa7c838
  0000000000000000
  ffff8800df0ac000

  0000000000000101
  ffff8800dfc83eb0
  ffff8800dfc83ef0
  ffffffff81094653

  ffff8800c6053fd8
  ffff8800c6053fd8
  ffff8800df0adc30
  ffff8800df0ad830

 Call Trace:
  <IRQ>

  [<ffffffff81094653>] run_timer_softirq+0x183/0x250
  [<ffffffff81058398>] ? lapic_next_event+0x18/0x20
  [<ffffffff810b35f7>] ? clockevents_program_event+0x57/0xa0
  [<ffffffff8108d9da>] __do_softirq+0x9a/0x150
  [<ffffffff8188625c>] call_softirq+0x1c/0x30
  [<ffffffff8103ebe5>] do_softirq+0x65/0xa0
  [<ffffffff8108d72d>] irq_exit+0x7d/0xa0
  [<ffffffff81058c99>] smp_apic_timer_interrupt+0x69/0xa0
  [<ffffffff81885d13>] apic_timer_interrupt+0x13/0x20
  <EOI>

  [<ffffffff810a4b99>] ? add_wait_queue+0x49/0x60
  [<ffffffff81884914>] ? _raw_spin_unlock_irqrestore+0x44/0x50
  [<ffffffff810a4b99>] ? add_wait_queue+0x49/0x60
  [<ffffffff81132f2a>] __pollwait+0x7a/0x100
  [<ffffffff8115eb97>] eventfd_poll+0x27/0x70
  [<ffffffff81133ce6>] do_select+0x3d6/0x730
  [<ffffffff81132eb0>] ? poll_freewait+0xc0/0xc0
  [<ffffffff81132fb0>] ? __pollwait+0x100/0x100
 last message repeated 5 times
  [<ffffffff8108239d>] ? sub_preempt_count+0x9d/0xd0
  [<ffffffff81081111>] ? get_parent_ip+0x11/0x50
  [<ffffffff8108239d>] ? sub_preempt_count+0x9d/0xd0
  [<ffffffff81882d53>] ? __mutex_lock_slowpath+0x2a3/0x350
  [<ffffffff811663bc>] compat_core_sys_select+0x1fc/0x280
  [<ffffffff81120ce1>] ? do_sync_read+0xd1/0x120
  [<ffffffff81081111>] ? get_parent_ip+0x11/0x50
  [<ffffffff81043ef6>] ? read_tsc+0x16/0x40
  [<ffffffff810ae732>] ? ktime_get_ts+0xb2/0xe0
  [<ffffffff811666fa>] compat_sys_select+0x4a/0x120
  [<ffffffff810c382b>] ? compat_sys_gettimeofday+0xbb/0xd0
  [<ffffffff8188631c>] sysenter_dispatch+0x7/0x32


In all these cases the issue was triggered by unplugging a mounted ext3
USB stick + an automated umount -l -f afterwards by udev using something
like the script below. A few seconds after the unplug+umount the system
crashed with the above traces, followed by a secondary

  Kernel panic - not syncing: Fatal exception in interrupt

Unfortunately I'm unable to reproduce the issue right now so there must
be some unknown precondition or it is a race. Script:

--------
#!/bin/sh
#
# /etc/udev/rules.d/99-local.rules:
#	SUBSYSTEM=="block", ACTION=="add|remove",	RUN+="/usr/local/sbin/plugdev"

media_add()
{
	mkdir -p /media/$dev
	mount -t "$1" -o "$2" /dev/$dev /media/$dev
}

media_remove()
{
	umount -f -l /media/$dev
	rmdir /media/* 2>/dev/null
}

dev=`echo $DEVNAME|sed 's/.*\///'`
case "$ID_FS_TYPE.$ACTION.$dev" in
ext[234].add.?*)
	media_add $ID_FS_TYPE nodev,nosuid
	;;
vfat.add.?*)
	media_add vfat umask=0
	;;
*.remove.?*)
	media_remove
	;;
esac
--------

-- 
Frank
