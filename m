Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2C2IT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:19:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58552 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2C2ITT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:19:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvy+9eHbjsAm-FaV8ihXexGGLURbyDTd6X_pqE_mtOutcw@mail.gmail.com>
References: <CAFLxGvy+9eHbjsAm-FaV8ihXexGGLURbyDTd6X_pqE_mtOutcw@mail.gmail.com>
Date: Thu, 29 Mar 2012 10:19:19 +0200
Message-ID: <CAFLxGvw_-Xej9RyCBkYu5++MbmsHjL3nP-1WVYgvYR4D8kv84g@mail.gmail.com>
Subject: Re: BUG at fs/ocfs2/extent_map.c:476
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: ocfs2-users@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 10:50 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> Hi!
>
> Today one of my kvm hosts ran into this BUG.
> The host is member of y small ocfs2-cluster (3 hosts).
> CentOS 6.2, Kernel 3.1.1 (vanilla).
>
> [8138858.899066] ------------[ cut here ]------------
> [8138858.899156] kernel BUG at fs/ocfs2/extent_map.c:476!
> [8138858.899232] invalid opcode: 0000 [#1] SMP
> [8138858.899314] CPU 4
> [8138858.899324] Modules linked in: ip6table_filter ip6_tables
> iptable_filter ip_tables ebtable_nat ebtables netconsole ocfs2
> ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager
> ocfs2_stackglue configfs sunrpc scsi_dh_rdac bridge 8021q garp stp llc
> be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi cxgb3 mdio
> ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6
> iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_round_robin
> dm_multipath vhost_net macvtap macvlan tun kvm_intel kvm serio_raw
> pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma
> i7core_edac edac_core sg ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi
> ata_generic ata_piix 3w_sas igb dca dm_mod [last unloaded:
> scsi_wait_scan]
> [8138858.900430]
> [8138858.900500] Pid: 3044, comm: qemu-kvm Not tainted 3.1.1 #1
> Supermicro X8DT3/X8DT3
> [8138858.900656] RIP: 0010:[<ffffffffa04f5531>]  [<ffffffffa04f5531>]
> ocfs2_get_clusters_nocache+0x4d1/0x520 [ocfs2]
> [8138858.900836] RSP: 0018:ffff8803efa01688  EFLAGS: 00010287
> [8138858.900911] RAX: 000000000000002f RBX: ffff8802ebe79030 RCX:
> 0000000000062114
> [8138858.901048] RDX: 0000000000000300 RSI: 00000000000620ec RDI:
> ffff8802ebe79320
> [8138858.901183] RBP: ffff8803efa01708 R08: 0000000000062114 R09:
> 0000000000000000
> [8138858.901322] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffff8803efa01738
> [8138858.901458] R13: ffff8804d6095000 R14: 0000000000000000 R15:
> 0000000000000001
> [8138858.901595] FS:  00007fa10d5f9700(0000) GS:ffff88063fc00000(0000)
> knlGS:0000000000000000
> [8138858.901734] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [8138858.901809] CR2: 00000000006bdc5c CR3: 00000004cf670000 CR4:
> 00000000000026e0
> [8138858.901942] DR0: 0000000000000001 DR1: 0000000000000002 DR2:
> 0000000000000001
> [8138858.902075] DR3: 000000000000000a DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [8138858.902208] Process qemu-kvm (pid: 3044, threadinfo
> ffff8803efa00000, task ffff880349986080)
> [8138858.902343] Stack:
> [8138858.902408]  0000000000000000 ffff880300000000 ffff8802ebe79000
> ffff8803efa01754
> [8138858.902556]  ffff880505f9acb0 000620ec00000000 ffff8803efa01874
> ffff8803efa017c4
> [8138858.902706]  ffff880002557130 ffffffffa04fdade ffff88062a8f2000
> 00000000000620ec
> [8138858.902854] Call Trace:
> [8138858.902945]  [<ffffffffa04fdade>] ?
> ocfs2_read_inode_block_full+0x3e/0x60 [ocfs2]
> [8138858.903100]  [<ffffffffa04f5f83>] ocfs2_get_clusters+0x1f3/0x380 [ocfs2]
> [8138858.903197]  [<ffffffffa04f616d>]
> ocfs2_extent_map_get_blocks+0x5d/0x1a0 [ocfs2]
> [8138858.903337]  [<ffffffff810b1ebf>] ? __css_put+0x3f/0x90
> [8138858.903429]  [<ffffffffa04da6dd>] ocfs2_get_block+0xad/0x9a0 [ocfs2]
> [8138858.903512]  [<ffffffff8111fc79>] ? zone_statistics+0x99/0xc0
> [8138858.903595]  [<ffffffff81159f5c>] ? __mem_cgroup_commit_charge+0x6c/0xc0
> [8138858.903679]  [<ffffffff811986b2>] do_mpage_readpage+0x492/0x630
> [8138858.903758]  [<ffffffff8111fcd5>] ? __inc_zone_page_state+0x35/0x40
> [8138858.903841]  [<ffffffff811029f1>] ? add_to_page_cache_locked+0xd1/0x140
> [8138858.903921]  [<ffffffff811989c2>] mpage_readpages+0x102/0x160
> [8138858.904015]  [<ffffffffa04da630>] ?
> ocfs2_map_page_blocks+0x3b0/0x3b0 [ocfs2]
> [8138858.904170]  [<ffffffffa04da630>] ?
> ocfs2_map_page_blocks+0x3b0/0x3b0 [ocfs2]
> [8138858.904331]  [<ffffffffa04f37aa>] ?
> ocfs2_inode_lock_full_nested+0x28a/0xad0 [ocfs2]
> [8138858.904484]  [<ffffffffa04d98e1>] ? ocfs2_readpages+0x41/0xe0 [ocfs2]
> [8138858.904583]  [<ffffffffa04d9967>] ocfs2_readpages+0xc7/0xe0 [ocfs2]
> [8138858.904662]  [<ffffffff8110dda2>] __do_page_cache_readahead+0x1b2/0x260
> [8138858.904740]  [<ffffffff8110de71>] ra_submit+0x21/0x30
> [8138858.904815]  [<ffffffff8110e225>] ondemand_readahead+0x115/0x240
> [8138858.904894]  [<ffffffff8110e3d8>] page_cache_async_readahead+0x88/0xb0
> [8138858.904974]  [<ffffffff811043eb>] generic_file_aio_read+0x48b/0x740
> [8138858.905074]  [<ffffffffa04f8f93>] ocfs2_file_aio_read+0xe3/0x380 [ocfs2]
> [8138858.905155]  [<ffffffff8116026a>] do_sync_read+0xda/0x120
> [8138858.905233]  [<ffffffff811ee9fb>] ? security_file_permission+0x8b/0x90
> [8138858.905315]  [<ffffffff811609b5>] vfs_read+0xc5/0x190
> [8138858.905391]  [<ffffffff81160b22>] sys_pread64+0xa2/0xb0
> [8138858.905469]  [<ffffffff814e1042>] system_call_fastpath+0x16/0x1b
> [8138858.905545] Code: c0 90 56 a0 bb e2 ff ff ff 48 8b 42 28 48 8b 4a
> 40 48 c7 c2 78 2e 57 a0 48 89 c7 31 c0 e8 18 b1 04 00 48 8b 7d b8 e9
> 37 fe ff ff <0f> 0b eb fe 65 48 8b 34 25 40 c4 00 00 8b 96 8c 04 00 00
> 48 63
> [8138858.906011] RIP  [<ffffffffa04f5531>]
> ocfs2_get_clusters_nocache+0x4d1/0x520 [ocfs2]
> [8138858.906174]  RSP <ffff8803efa01688>
> [8138858.906541] ---[ end trace 5b1e50f0d8b3c799 ]---
>
> Is this a known/fixed bug?

*ping*

-- 
Thanks,
//richard
