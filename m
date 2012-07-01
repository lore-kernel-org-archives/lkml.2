Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2GAHTC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 03:19:02 -0400
Received: from trent.utfs.org ([94.185.90.103]:51063 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab2GAHSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 03:18:34 -0400
Date: Sun, 1 Jul 2012 00:18:31 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: linuxppc-dev@lists.ozlabs.org
cc: LKML <linux-kernel@vger.kernel.org>
Subject: 3.5.0-rc5: BUG: soft lockup - CPU#0 stuck for 22s
Message-ID: <alpine.DEB.2.01.1207010009270.5568@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while trying to upgrade from 3.4.0 to 3.5.0-rc5 on this Powerbook G4 
(powerpc 32 bit), this happens during booting:

--------------
usb 2-1: new full-speed USB device number 4 using ohci_hcd
SCSI subsystem initialized
scsi0 : SBP-2 IEEE-1394
scsi1 : SBP-2 IEEE-1394
firewire_sbp2 fw1.0: logged in to LUN 0000 (0 retries)
scsi 0:0:0:0: Direct-Access     Ext Hard  Disk            PQ: 0 ANSI: 4

[25 seconds later]

BUG: soft lockup - CPU#0 stuck for 22s! [modprobe:695]
Modules linked in: sd_mod arc4 firewire_sbp2 scsi_mod b43 mac80211 cfg80211
irq event stamp: 56975532
hardirqs last  enabled at (56975531): <c053aea8>] _raw_spin_unlock_irqrestore+0x40/0x9c
hardirqs last disabled at (56975532): <c0011688>] reenable_mmu+0x40/0x98
softirqs last  enabled at (56966080): <c000f3f0>] call_do_softirq+0x14/0x24
softirqs last disabled at (56966073): <c000f3f0>] call_do_softirq+0x14/0x24
NIP: c053aeac LR: c053aea8 CTR: c009d510
REGS: eed1fd40 TRAP: 0901   Not tainted  (3.5.0-rc5)
MSR: 00009032 ME IR DR RI > CR: 24042484  XER: 00000000
TASK = eece5c00[695] 'modprobe' THREAD: eed1e000 #012GPR00: 012GPR08: 
NIP [c053aeac] _raw_spin_unlock_irqrestore+0x44/0x9c
LR [c053aea8] _raw_spin_unlock_irqrestore+0x40/0x9c
Call Trace:
[eed1fdf0] [c053aea8] _raw_spin_unlock_irqrestore+0x40/0x9c (unreliable)
[eed1fe00] [c005fbd8] lowest_in_progress+0xa8/0xcc
[eed1fe20] [c005fc5c] async_synchronize_cookie_domain+0x60/0x1f4
[eed1fe70] [c005fe3c] async_synchronize_full+0x3c/0x74
[eed1fe90] [c0083908] sys_init_module+0x174/0x1168
[eed1ff40] [c00117e8] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xff5d694#012[   36.339234]     LR = 0x100041c0
Instruction dump:
38630010 
73e08000 
--------------

This is what netconsole was able to receive. I've made a screenshot from 
another boot with the same vanilla 3.5.0-rc5 (today's mainline) and put it 
(along with some more details) up here: 

  http://nerdbynature.de/bits/3.5.0-rc5/soft_lockup/

Any ideas?

Thanks,
Christian.
-- 
BOFH excuse #436:

Daemon escaped from pentagram
