Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1F3Sf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:35:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34155 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1F3SfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:35:24 -0400
MIME-Version: 1.0
From: Jim Cromie <jim.cromie@gmail.com>
Date: Thu, 30 Jun 2011 12:34:52 -0600
Message-ID: <BANLkTi=OkgWYJz-29yALe=11L8_UEcBvfA@mail.gmail.com>
Subject: dma-debug report/error on natsemi eth0
To: LKML <linux-kernel@vger.kernel.org>, linux-netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since adding DMA-debug to my config, Ive been seeing these.
I suspect it goes back a ways..

its on my list to do some investigating,
but I figured Id report in the meantime.

------------[ cut here ]------------
WARNING: at /home/jimc/projects/lx/linux-2.6/lib/dma-debug.c:820
check_unmap+0x1fe/0x56a()
natsemi 0000:00:06.0: DMA-API: device driver frees DMA memory with
different size [device address=0x0000000006ef0040] [map size=1538
bytes] [unmap size=1522 bytes]
Modules linked in: pc8736x_gpio pc87360 hwmon_vid scx200_gpio nsc_gpio
scx200_hrt scx200_acb i2c_core arc4 rtl8180 mac80211 eeprom_93cx6
cfg80211 pcspkr rfkill scx200 ide_gd_mod ide_pci_generic ohci_hcd
usbcore sc1200 ide_core
Pid: 870, comm: collector Not tainted 3.0.0-rc5-sk-00080-gca56a95 #1
Call Trace:
 [<c011a556>] warn_slowpath_common+0x4a/0x5f
 [<c02565cb>] ? check_unmap+0x1fe/0x56a
 [<c011a5cf>] warn_slowpath_fmt+0x26/0x2a
 [<c02565cb>] check_unmap+0x1fe/0x56a
 [<c0256aaa>] debug_dma_unmap_page+0x53/0x5b
 [<c029d6cd>] pci_unmap_single+0x4d/0x57
 [<c029ea0a>] natsemi_poll+0x343/0x5ca
 [<c0116f41>] ? try_to_wake_up+0xea/0xfc
 [<c0122416>] ? spin_unlock_irq.clone.28+0x18/0x23
 [<c02d4667>] net_rx_action+0x3f/0xe5
 [<c011e35e>] __do_softirq+0x5b/0xd1
 [<c011e303>] ? local_bh_enable+0xa/0xa
 <IRQ>  [<c011e54b>] ? irq_exit+0x34/0x75
 [<c01034b9>] ? do_IRQ+0x66/0x79
 [<c034e869>] ? common_interrupt+0x29/0x30
 [<c0115ed0>] ? finish_task_switch.clone.118+0x31/0x72
 [<c034cb92>] ? schedule+0x3b2/0x3f1
 [<c012f4b0>] ? hrtimer_start_range_ns+0x10/0x12
 [<c012f4ce>] ? hrtimer_start_expires+0x1c/0x24
 [<c034d5aa>] ? schedule_hrtimeout_range_clock+0x8e/0xb4
 [<c012ed27>] ? update_rmtp+0x68/0x68
 [<c034d5da>] ? schedule_hrtimeout_range+0xa/0xc
 [<c017a913>] ? poll_schedule_timeout+0x27/0x3e
 [<c017b051>] ? do_select+0x488/0x4cd
 [<c0115ee2>] ? finish_task_switch.clone.118+0x43/0x72
 [<c01157ad>] ? need_resched+0x14/0x1e
 [<c017a99e>] ? poll_freewait+0x74/0x74
 [<c01157ad>] ? need_resched+0x14/0x1e
 [<c034cbc1>] ? schedule+0x3e1/0x3f1
 [<c011e55e>] ? irq_exit+0x47/0x75
 [<c01157ad>] ? need_resched+0x14/0x1e
 [<c034cf8a>] ? preempt_schedule_irq+0x44/0x4a
 [<c034dd1e>] ? need_resched+0x17/0x19
 [<c024bc12>] ? put_dec_full+0x7b/0xaa
 [<c0240060>] ? blkdev_ioctl+0x434/0x618
 [<c024bc70>] ? put_dec+0x2f/0x6d
 [<c024c6a5>] ? number.clone.1+0x10b/0x1d0
 [<c034cf8a>] ? preempt_schedule_irq+0x44/0x4a
 [<c034dd1e>] ? need_resched+0x17/0x19
 [<c024d046>] ? vsnprintf+0x225/0x264
 [<c024cea0>] ? vsnprintf+0x7f/0x264
 [<c018346f>] ? seq_printf+0x22/0x40
 [<c01a2fcc>] ? do_task_stat+0x582/0x5a3
 [<c017a913>] ? poll_schedule_timeout+0x27/0x3e
 [<c017b1b5>] ? core_sys_select+0x11f/0x1a3
 [<c017a913>] ? poll_schedule_timeout+0x27/0x3e
 [<c01a34a1>] ? proc_tgid_stat+0xd/0xf
 [<c012357c>] ? recalc_sigpending+0x32/0x35
 [<c0123b9c>] ? __set_task_blocked+0x64/0x6a
 [<c011dfb0>] ? timespec_add_safe+0x24/0x48
 [<c0123449>] ? spin_unlock_irq.clone.16+0x18/0x23
 [<c017b3a1>] ? sys_pselect6+0xe5/0x13e
 [<c034dd65>] ? syscall_call+0x7/0xb
 [<c0340000>] ? rpc_clntdir_depopulate+0x26/0x30
---[ end trace 180dcac41a50938b ]---
