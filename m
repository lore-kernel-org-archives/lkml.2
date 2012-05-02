Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2EBJS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:18:29 -0400
Received: from mail.mimuw.edu.pl ([193.0.96.6]:41862 "EHLO mail.mimuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2EBJS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:18:27 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 05:18:26 EDT
Date: Wed, 2 May 2012 11:12:26 +0200
From: Jan =?utf-8?Q?R=C4=99korajski?= <baggins@sith.mimuw.edu.pl>
To: linux-kernel@vger.kernel.org
Cc: Tobias Powalowski <tobias.powalowski@googlemail.com>
Subject: Re: Possible 32bit i686 kernel hard crash bug 3.3.4?
Message-ID: <20120502091226.GA1591@home.lan>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Tobias Powalowski <tobias.powalowski@googlemail.com>
References: <4FA0E485.80902@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FA0E485.80902@googlemail.com>
X-Operating-System: Linux 3.3.3.lxc-1 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2012, Tobias Powalowski wrote:

> Hi,
> since we bumped to 3.3.4 some users reported hard crashes:
> https://bugs.archlinux.org/task/29694
> I cannot exactly say what it triggers it happens for me randomly.
> This kernel version is not usable for my server anymore.
> Hope you can help us. x86_64 seems not to be affected.

What version of binutils you built that kernel with?
Is it by any chance 2.22.52.0.2?

I'm seeing similiar crashes on i686 when running 3.3.x built with that
version of binutils, and downgrade to 2.22.52.0.1 results in working
kernel.

An example bugs:

[  309.059679] BUG: unable to handle kernel paging request at 00100104
[  309.059986] IP: [<c01ea221>] isolate_lru_pages+0xc1/0x320
[  309.059986] *pdpt = 000000001dd4c001 *pde = 0000000000000000 
[  309.059986] Oops: 0002 [#1] SMP 
[  309.059986] Modules linked in: sch_sfq md_mod dm_round_robin dm_multipath scsi_dh dm_mod ohci_hcd ehci_hcd ssb mmc_core pcmcia pcmcia_core usbcore ppdev usb_common i2c_piix4 psmouse serio_raw i2c_core sr_mod cdrom pcnet32 mii evdev floppy pcspkr parport_pc parport button ac processor xfs scsi_wait_scan sd_mod crc_t10dif ata_piix libata scsi_mod
[  309.059986] 
[  309.059986] Pid: 18, comm: kswapd0 Tainted: G    B        3.3.4.bad-1 #8 innotek GmbH VirtualBox
[  309.059986] EIP: 0060:[<c01ea221>] EFLAGS: 00010002 CPU: 0
[  309.059986] EIP is at isolate_lru_pages+0xc1/0x320
[  309.059986] EAX: 00200200 EBX: df464474 ECX: dd4c7e08 EDX: 00100100
[  309.059986] ESI: dec344e0 EDI: df464460 EBP: dd4c7dd0 ESP: dd4c7d78
[  309.059986]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  309.059986] Process kswapd0 (pid: 18, ti=dd4c6000 task=dee14840 task.ti=dd4c6000)
[  309.059986] Stack:
[  309.059986]  dd4c7dcc c0204b63 dd4c7dbc dd4c7e20 dd68a910 dd4c7da0 00000001 ffffffff
[  309.059986]  dd4c7e14 00000000 dd4c7dcc 00000000 00000000 00000001 00000000 00000001
[  309.059986]  00000001 dd4c7e08 00000000 dd4c7f58 c06964c0 00000001 dd4c7e30 c01eb7a5
[  309.059986] Call Trace:
[  309.059986]  [<c0204b63>] ? page_referenced+0x233/0x2b0
[  309.059986]  [<c01eb7a5>] shrink_inactive_list+0xd5/0x420
[  309.059986]  [<c01ebed4>] shrink_mem_cgroup_zone+0x3e4/0x590
[  309.059986]  [<c021ff01>] ? mem_cgroup_iter+0xc1/0x210
[  309.059986]  [<c01ec0de>] shrink_zone+0x5e/0x80
[  309.059986]  [<c01ec4b0>] kswapd+0x3b0/0x8f0
[  309.059986]  [<c015c240>] ? abort_exclusive_wait+0x80/0x80
[  309.059986]  [<c01ec100>] ? shrink_zone+0x80/0x80
[  309.059986]  [<c015bbbd>] kthread+0x6d/0x80
[  309.059986]  [<c015bb50>] ? kthread_freezable_should_stop+0x60/0x60
[  309.059986]  [<c04f901e>] kernel_thread_helper+0x6/0x10
[  309.059986] Code: 10 8b 43 ec 89 f8 e8 4f fe ff ff 83 f8 f0 0f 84 2e 01 00 00 85 c0 0f 85 1e 01 00 00 89 f8 e8 27 75 03 00 8b 13 8b 43 04 8b 4d ec <89> 42 04 89 10 8b 01 8b 55 e0 89 58 04 89 03 89 4b 04 89 19 8b 
[  309.059986] EIP: [<c01ea221>] isolate_lru_pages+0xc1/0x320 SS:ESP 0068:dd4c7d78
[  309.059986] CR2: 0000000000100104
[  309.059986] ---[ end trace 56683a8dc0a40f2b ]---

[   41.600732] BUG: unable to handle kernel paging request at 00200200
[   41.603345] IP: [<c01ea224>] isolate_lru_pages+0xc4/0x320
[   41.603345] *pdpt = 0000000000091001 *pde = 0000000000000000 
[   41.603345] Oops: 0002 [#1] SMP 
[   41.603345] Modules linked in: sch_sfq md_mod dm_round_robin dm_multipath scsi_dh dm_mod ohci_hcd ehci_hcd ssb mmc_core pcmcia pcmcia_core usbcore usb_common sr_mod cdrom i2c_piix4 ppdev floppy psmouse serio_raw i2c_core evdev pcnet32 mii pcspkr processor parport_pc parport ac button xfs scsi_wait_scan sd_mod crc_t10dif ata_piix libata scsi_mod
[   41.603345] 
[   41.603345] Pid: 18, comm: kswapd0 Tainted: G    B        3.3.4.bad-1 #9 innotek GmbH VirtualBox
[   41.603345] EIP: 0060:[<c01ea224>] EFLAGS: 00010006 CPU: 0
[   41.603345] EIP is at isolate_lru_pages+0xc4/0x320
[   41.603345] EAX: 00200200 EBX: df4637b4 ECX: dd4c7ed8 EDX: dec344d8
[   41.603345] ESI: dec344d8 EDI: df4637a0 EBP: dd4c7ea0 ESP: dd4c7e48
[   41.603345]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   41.603345] Process kswapd0 (pid: 18, ti=dd4c6000 task=dee14840 task.ti=dd4c6000)
[   41.603345] Stack:
[   41.603345]  dd4c7e48 dd4c7e48 00000008 c06984c0 c06984c0 dd4c7e84 c01e5756 ffffffff
[   41.603345]  c01e4ef0 00000000 df204bc0 00000000 00000000 00000001 00000007 00000001
[   41.603345]  00000020 dd4c7ed8 00000007 dd4c7f58 00000002 dd4c7ed8 dd4c7f04 c01eaa7e
[   41.603345] Call Trace:
[   41.603345]  [<c01e5756>] ? pagevec_lru_move_fn+0xa6/0xc0
[   41.603345]  [<c01e4ef0>] ? update_page_reclaim_stat+0x50/0x50
[   41.603345]  [<c01eaa7e>] shrink_active_list.isra.54+0x9e/0x300
[   41.603345]  [<c019720d>] ? css_get_next+0x5d/0xa0
[   41.603345]  [<c01ec3ae>] kswapd+0x2ae/0x8f0
[   41.603345]  [<c04f0791>] ? __schedule+0x241/0x690
[   41.603345]  [<c015c240>] ? abort_exclusive_wait+0x80/0x80
[   41.603345]  [<c01ec100>] ? shrink_zone+0x80/0x80
[   41.603345]  [<c015bbbd>] kthread+0x6d/0x80
[   41.603345]  [<c015bb50>] ? kthread_freezable_should_stop+0x60/0x60
[   41.603345]  [<c04f901e>] kernel_thread_helper+0x6/0x10
[   41.603345] Code: ec 89 f8 e8 4f fe ff ff 83 f8 f0 0f 84 2e 01 00 00 85 c0 0f 85 1e 01 00 00 89 f8 e8 27 75 03 00 8b 13 8b 43 04 8b 4d ec 89 42 04 <89> 10 8b 01 8b 55 e0 89 58 04 89 03 89 4b 04 89 19 8b 43 ec 25 
[   41.603345] EIP: [<c01ea224>] isolate_lru_pages+0xc4/0x320 SS:ESP 0068:dd4c7e48
[   41.603345] CR2: 0000000000200200
[   41.603345] ---[ end trace c9a22c4036e832d4 ]---


-- 
Jan Rękorajski                                 | PLD/Linux
SysAdm                                         | http://www.pld-linux.org/
baggins<at>mimuw.edu.pl
baggins<at>pld-linux.org
