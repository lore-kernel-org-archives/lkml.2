Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2LKRBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:01:03 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33533 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2LKRBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:01:00 -0500
Date: Tue, 11 Dec 2012 17:00:53 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, alexander.deucher@amd.com
Subject: Re: null dereference at r100_debugfs_cp_ring_info+0x115/0x140
Message-ID: <20121211170053.GA18760@gmail.com>
References: <20121211150706.GA11956@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211150706.GA11956@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:07:06AM -0500, Dave Jones wrote:
> (Taint comes from previous r600 bug reported here https://lkml.org/lkml/2012/12/8/131)
> 
> [35662.070628] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [35662.071719] IP: [<ffffffff814761e5>] r100_debugfs_cp_ring_info+0x115/0x140
> [35662.072652] PGD b4c17067 PUD b69d1067 PMD 0 
> [35662.073243] Oops: 0000 [#1] PREEMPT SMP 
> [35662.073809] Modules linked in: nfnetlink ipt_ULOG binfmt_misc sctp libcrc32c scsi_transport_iscsi nfc caif_socket caif phonet bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 nfsv3 nfs_acl nfs fscache lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek microcode snd_hda_intel snd_hda_codec usb_debug serio_raw pcspkr snd_pcm snd_page_alloc edac_core snd_timer snd i2c_piix4 soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm
> [35662.082589] CPU 0 
> [35662.082852] Pid: 28200, comm: trinity-child1 Tainted: G        W    3.7.0-rc8+ #10 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
> [35662.084465] RIP: 0010:[<ffffffff814761e5>]  [<ffffffff814761e5>] r100_debugfs_cp_ring_info+0x115/0x140
> [35662.085656] RSP: 0018:ffff8800b6b27e58  EFLAGS: 00010202
> [35662.086343] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> [35662.087252] RDX: 0000000000000000 RSI: ffffffff81a504ee RDI: ffff8800af0936c0
> [35662.088163] RBP: ffff8800b6b27e88 R08: 0000000000001000 R09: 000000000000fffe
> [35662.089071] R10: 0000000000000000 R11: 000000000000000f R12: ffff8800af0936c0
> [35662.089980] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88012444c000
> [35662.090891] FS:  00007f1baff14740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
> [35662.091918] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [35662.092656] CR2: 0000000000000000 CR3: 00000000b6be9000 CR4: 00000000000007f0
> [35662.093567] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [35662.094475] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [35662.095383] Process trinity-child1 (pid: 28200, threadinfo ffff8800b6b26000, task ffff8800b05a48a0)
> [35662.096525] Stack:
> [35662.096782]  0000000000000000 ffff8800b2b0f180 0000000000000000 ffff8800b6b27f50
> [35662.097768]  0000000000000001 ffff8800af0936c0 ffff8800b6b27ef8 ffffffff811ddbdc
> [35662.098826]  ffff8800b6b27ec8 0000000000da2c90 ffff8800af0936f8 0000000000000001
> [35662.099882] Call Trace:
> [35662.100221]  [<ffffffff811ddbdc>] seq_read+0xcc/0x450
> [35662.100884]  [<ffffffff811b821c>] vfs_read+0xac/0x180
> [35662.101545]  [<ffffffff811b8345>] sys_read+0x55/0xa0
> [35662.102195]  [<ffffffff81742e82>] system_call_fastpath+0x16/0x1b
> [35662.102969] Code: 1f 80 00 00 00 00 41 8d 14 1e 41 23 97 3c 13 00 00 49 8b 87 e0 12 00 00 48 c7 c6 ee 04 a5 81 4c 89 e7 48 ff c3 89 d1 48 8d 04 88 <8b> 08 31 c0 e8 b2 71 d6 ff 41 39 dd 73 cd 48 83 c4 08 31 c0 5b 
> [35662.106677] RIP  [<ffffffff814761e5>] r100_debugfs_cp_ring_info+0x115/0x140
> [35662.107602]  RSP <ffff8800b6b27e58>
> [35662.108065] CR2: 0000000000000000
> [35662.108837] ---[ end trace 77a9a4397cec5a9d ]---
> (09:57:30:davej@demonseed:~)$ 
rdev->irq.installed is checked outside rs600_irq_set before patch f9aee25 (if
not installed, it doesn't call rs600_irq_set), and checked again in
rs600_irq_set (if not installed, return -EINVAL). The check of
rdev->irq.installed outside rs600_irq_set is removed by patch f9aee25, and
then the "no handler installed" failure thrown out by rdev->irq.installed
check in rs600_irq_set.
