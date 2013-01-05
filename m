Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3AEPWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 10:22:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab3AEPWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 10:22:13 -0500
Date: Sat, 5 Jan 2013 10:22:08 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: oops in copy_page_rep()
Message-ID: <20130105152208.GA3386@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no idea what happened here, but this is the first time I've seen this one.
This was running a tree pulled yesterday afternoon.

BUG: unable to handle kernel paging request at ffff880100201000
IP: [<ffffffff81333235>] copy_page_rep+0x5/0x10
PGD 1c0c063 PUD cfbff067 PMD cfc01067 PTE 8000000100201160
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: nfnetlink_log hidp fuse bnep llc2 rose caif_socket caif af_rxrpc phonet netrom af_key binfmt_misc rfcomm l2tp_ppp l2tp_core pppoe pppox ppp_generic slhc ipt_ULOG scsi_transp
ort_iscsi can_raw nfnetlink ipx x25 p8023 p8022 nfc ax25 decnet rds can_bcm irda crc_ccitt can appletalk atm psnap llc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6ta
ble_filter ip6_tables snd_hda_codec_realtek btusb snd_hda_intel bluetooth snd_hda_codec usb_debug microcode rfkill snd_pcm serio_raw snd_page_alloc snd_timer pcspkr edac_core snd soundcore r8169 mii vhost_net
 tun macvtap macvlan kvm_amd kvm
CPU 0 
Pid: 3505, comm: trinity-child0 Not tainted 3.8.0-rc2+ #45 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff81333235>]  [<ffffffff81333235>] copy_page_rep+0x5/0x10
RSP: 0018:ffff88001ecabd00  EFLAGS: 00010286
RAX: 0000000100201000 RBX: 000000011d215000 RCX: 0000000000000200
RDX: cccccccccccccccd RSI: ffff880100201000 RDI: ffff88011d215000
RBP: ffff88001ecabd98 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000008
R13: 000000000500a050 R14: ffff8800916af080 R15: ffff880095435668
FS:  00007f48a2280740(0000) GS:ffff88012ee00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880100201000 CR3: 0000000054eda000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child0 (pid: 3505, threadinfo ffff88001ecaa000, task ffff8800a9628000)
Stack:
 ffffffff8119a9c7 ffff88001ecabd28 ffff8800a9628000 000000000157e088
 000000000157e088 000000000157e088 ffff880095435668 ffff8800a9077600
 ffff880095435668 80000001002000e5 ffff8800ba515050 0000000001400000
Call Trace:
 [<ffffffff8119a9c7>] ? do_huge_pmd_wp_page+0x707/0xc00
 [<ffffffff81165f1c>] handle_mm_fault+0x14c/0x590
 [<ffffffff810b35ce>] ? __lock_is_held+0x5e/0x90
 [<ffffffff816a280c>] __do_page_fault+0x15c/0x4e0
 [<ffffffff8100a1b6>] ? native_sched_clock+0x26/0x90
 [<ffffffff810b28e8>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff81334cbd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff816a2b9e>] do_page_fault+0xe/0x10
 [<ffffffff8169f822>] page_fault+0x22/0x30
Code: 90 90 90 90 90 90 9c fa 65 48 3b 06 75 14 65 48 3b 56 08 75 0d 65 48 89 1e 65 48 89 4e 08 9d b0 01 c3 9d 30 c0 c3 b9 00 02 00 00 <f3> 48 a5 c3 0f 1f 80 00 00 00 00 eb ee 66 66 66 90 66 66 66 90 
RIP  [<ffffffff81333235>] copy_page_rep+0x5/0x10
 RSP <ffff88001ecabd00>
CR2: ffff880100201000


