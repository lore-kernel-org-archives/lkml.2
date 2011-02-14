Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab1BNFeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 00:34:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57900 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1BNFen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 00:34:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	<m1bp2ly41q.fsf@fess.ebiederm.org>
	<AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
	<AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
	<AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
	<m14o87wev8.fsf@fess.ebiederm.org>
	<AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
	<m1r5bbthan.fsf@fess.ebiederm.org>
Date: Sun, 13 Feb 2011 21:34:33 -0800
In-Reply-To: <m1r5bbthan.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Sun, 13 Feb 2011 19:40:32 -0800")
Message-ID: <m1fwrrtc0m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/LIF6hgTkw6FR/OpJRlopDWRG2zDlyHnU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And for completeness.  When I was rebooting v2.6.38-rc4 to start running
795abaf1e4e188c4171e3cd3dbb11a9fcacaf505  I hit this.

Sigh.  I wish crash worked on something besides redhats enterprise
kernels.  Then I could use the system core file I have to do more than
extract the dmesg.

Eric

<0>------------[ cut here ]------------
<2>kernel BUG at mm/filemap.c:125!
<0>invalid opcode: 0000 [#1] SMP 
<0>last sysfs file: /sys/devices/virtual/net/sit0/uevent
<4>CPU 5 
<4>Modules linked in: sit tunnel4 macvtap ipt_LOG xt_limit ipt_REJECT xt_hl xt_state dummy tulip xt_tcpudp iptable_filter inet_diag veth macvlan nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc dm_mirror dm_region_hash dm_log uinput bonding ipv6 kvm_intel kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q i5k_amb iTCO_wdt i5400_edac ioatdma iTCO_vendor_support edac_core i2c_i801 dca shpchp ghes hed microcode sg serio_raw pcspkr radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core ehci_hcd uhci_hcd sr_mod cdrom igb netxen_nic dm_mod [last unloaded: mperf]
<4>
<4>Pid: 2611, comm: umount Tainted: G    B       2.6.38-rc4-355739.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
<4>RIP: 0010:[<ffffffff810b0cd7>]  [<ffffffff810b0cd7>] __remove_from_page_cache+0x54/0xb9
<4>RSP: 0018:ffff880296397c28  EFLAGS: 00010046
<4>RAX: 0000000000000000 RBX: ffffea00086cf1b8 RCX: 00000000ffffffc8
<4>RDX: 0000000000000009 RSI: 0000000000000009 RDI: ffff8802affece00
<4>RBP: ffff880296397c38 R08: 0000000000000000 R09: de80000000000000
<4>R10: ffff88028a4f6aa8 R11: ffff8802affece00 R12: ffff8801a7588578
<4>R13: ffff8801a7588590 R14: ffff880296397cc8 R15: ffffffffffffffff
<4>FS:  00007fbde33db760(0000) GS:ffff8800cfd40000(0000) knlGS:0000000000000000
<4>CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>CR2: 0000003928271610 CR3: 0000000295e3b000 CR4: 00000000000006e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process umount (pid: 2611, threadinfo ffff880296396000, task ffff88007d62d960)
<0>Stack:
<4> ffffea00086cf1b8 0000000000000000 ffff880296397c68 ffffffff810b0d75
<4> ffff880296397cc8 ffffea00086cf1b8 ffff8801a7588578 ffff8801a7588578
<4> ffff880296397c88 ffffffff810b9b5e 0000000000000000 0000000000000005
<0>Call Trace:
<4> [<ffffffff810b0d75>] remove_from_page_cache+0x39/0x5c
<4> [<ffffffff810b9b5e>] truncate_inode_page+0x63/0x77
<4> [<ffffffff810b9c3c>] truncate_inode_pages_range+0xca/0x2e9
<4> [<ffffffff811876ae>] ? ext4_discard_preallocations+0x88/0x309
<4> [<ffffffff810b9e68>] truncate_inode_pages+0xd/0xf
<4> [<ffffffff8116716a>] ext4_evict_inode+0x4b/0x213
<4> [<ffffffff8110389d>] evict+0x1f/0x88
<4> [<ffffffff81103945>] dispose_list+0x3f/0xce
<4> [<ffffffff81104652>] ? evict_inodes+0xe4/0x124
<4> [<ffffffff8110467b>] evict_inodes+0x10d/0x124
<4> [<ffffffff810f1e2c>] generic_shutdown_super+0x60/0xf0
<4> [<ffffffff810f1ede>] kill_block_super+0x22/0x65
<4> [<ffffffff810f2139>] deactivate_locked_super+0x21/0x41
<4> [<ffffffff810f2c2d>] deactivate_super+0x35/0x39
<4> [<ffffffff81106fa3>] mntput_no_expire+0xcb/0xd0
<4> [<ffffffff81107ae4>] sys_umount+0x2e9/0x317
<4> [<ffffffff810f8afe>] ? path_put+0x1d/0x21
<4> [<ffffffff81002992>] system_call_fastpath+0x16/0x1b
<0>Code: be 09 00 00 00 48 89 df e8 5b 45 01 00 48 8b 03 a9 00 00 08 00 74 0d be 16 00 00 00 48 89 df e8 44 45 01 00 8b 43 0c 85 c0 78 02 <0f> 0b 48 8b 03 a8 10 74 57 49 8b 44 24 68 f6 40 20 01 75 4c 48 
<1>RIP  [<ffffffff810b0cd7>] __remove_from_page_cache+0x54/0xb9
<4> RSP <ffff880296397c28>

