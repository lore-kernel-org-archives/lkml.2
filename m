Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab0LBVYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:24:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46580 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab0LBVYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:24:15 -0500
Date: Thu, 2 Dec 2010 16:23:46 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
Message-ID: <20101202212346.GK25668@bombadil.infradead.org>
References: <4CF52652.4030802@kernel.org>
 <20101130163150.GA25668@bombadil.infradead.org>
 <20101130175317.GB25668@bombadil.infradead.org>
 <20101130210938.GF25668@bombadil.infradead.org>
 <4CF62EE0.7040607@kernel.org>
 <20101201124445.GG25668@bombadil.infradead.org>
 <4CF6595A.6010104@kernel.org>
 <20101201155026.GH25668@bombadil.infradead.org>
 <20101201200907.GI25668@bombadil.infradead.org>
 <4CF77225.3040904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF77225.3040904@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 11:17:09AM +0100, Tejun Heo wrote:
> Hmmm... something is setting EH_PENDING while EH is in progress.
> Let's see what's doing it.  Can you please apply the following patch
> on top of the previous one and report the kernel log?
> 

This gets triggered a bunch on boot-up:

[   36.981370] ata1: XXX SET EH PENDING, fastdrain=0
[   36.981380] Pid: 0, comm: swapper Not tainted
2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[   36.981386] Call Trace:
[   36.981393]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[   36.981407]  [<ffffffff8131db36>] ata_do_link_abort+0x44/0x94
[   36.981412]  [<ffffffff8131dbac>] ata_port_abort+0x10/0x12
[   36.981421]  [<ffffffff8132b0ab>] ahci_interrupt+0x467/0x5a1
[   36.981428]  [<ffffffff810afbc1>] ?
check_for_new_grace_period.clone.21+0x8b/0x97
[   36.981434]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[   36.981440]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[   36.981447]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[   36.981452]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[   36.981458]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[   36.981463]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[   36.981468]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[   36.981470]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[   36.981480]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[   36.981485]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[   36.981489]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[   36.981493]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[   36.981498]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[   36.981503]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[   36.981507]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[   37.200683] ata1: XXX SET EH PENDING, fastdrain=1
[   37.200692] Pid: 1465, comm: ck-history Not tainted
2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[   37.200696] Call Trace:
[   37.200699]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[   37.200715]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[   37.200720]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[   37.200723]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[   37.200727]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[   37.200737]  [<ffffffff8105c784>] ? run_timer_softirq+0x28f/0x29e
[   37.200742]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[   37.200747]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[   37.200752]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[   37.200758]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[   37.200761]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[   37.200766]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[   37.200769]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[   37.200774]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[   37.200775]  <EOI>  [<ffffffff81117bd1>] ? lock_page_cgroup+0x19/0x21
[   37.200783]  [<ffffffff811198c2>]
__mem_cgroup_commit_charge+0x28/0x97
[   37.200786]  [<ffffffff8111b961>] mem_cgroup_charge_common+0x66/0x76
[   37.200789]  [<ffffffff8111bc89>] mem_cgroup_cache_charge+0xe4/0xf9
[   37.200794]  [<ffffffff810d8cf3>] add_to_page_cache_locked+0x42/0x113
[   37.200797]  [<ffffffff810d8dee>] add_to_page_cache_lru+0x2a/0x58
[   37.200802]  [<ffffffff8114a883>] mpage_readpages+0xa3/0x113
[   37.200805]  [<ffffffff81199b1a>] ? ext4_get_block+0x0/0x18
[   37.200808]  [<ffffffff81199b1a>] ? ext4_get_block+0x0/0x18
[   37.200811]  [<ffffffff810ee22b>] ? zone_statistics+0x65/0x6a
[   37.200816]  [<ffffffff8110991a>] ? alloc_pages_current+0xb2/0xc3
[   37.200821]  [<ffffffff811965ec>] ext4_readpages+0x1d/0x1f
[   37.200826]  [<ffffffff810e1145>]
__do_page_cache_readahead+0x105/0x176
[   37.200829]  [<ffffffff810e141b>] ra_submit+0x21/0x25
[   37.200831]  [<ffffffff810e15db>] ondemand_readahead+0x1bc/0x1cb
[   37.200834]  [<ffffffff810e1665>]
page_cache_async_readahead+0x7b/0xa3
[   37.200837]  [<ffffffff810d9bbc>] generic_file_aio_read+0x2a5/0x5b6
[   37.200840]  [<ffffffff810e1c10>] ? __lru_cache_add+0x34/0x5b
[   37.200844]  [<ffffffff8111f602>] do_sync_read+0xcb/0x108
[   37.200848]  [<ffffffff811ebbdb>] ? fsnotify_perm+0x64/0x70
[   37.200852]  [<ffffffff811ec327>] ?
security_file_permission+0x2e/0x33
[   37.200855]  [<ffffffff8111fce5>] vfs_read+0xa9/0xfc
[   37.200857]  [<ffffffff8111fd82>] sys_read+0x4a/0x6e
[   37.200860]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[   37.203575] ata1.00: configured for UDMA/100
[   37.203582] ata1: EH complete
[   37.239419] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[   38.145358] ata1: XXX SET EH PENDING, fastdrain=1
[   38.145367] Pid: 1489, comm: sata_alpm Not tainted
2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[   38.145371] Call Trace:
[   38.145384]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[   38.145391]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[   38.145400]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[   38.145406]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[   38.145413]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[   38.145422]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[   38.145430]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[   38.145436]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[   38.145444]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[   38.145710] ata2: XXX SET EH PENDING, fastdrain=1
[   38.145718] Pid: 1489, comm: sata_alpm Not tainted
2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[   38.145723] Call Trace:
[   38.145730]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[   38.145737]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[   38.145743]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[   38.145748]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[   38.145754]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[   38.145760]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[   38.145767]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[   38.145773]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[   38.145779]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b


My whole dmesg from bootup is available at:
http://kyle.fedorapeople.org/dmesg

There's nothing interesting in my kernel wrt ATA (no patches at all
touching it aside from the two from this thread.) Maybe systemd or
something during boot-up is poking sysfs, I'll take a look.

--Kyle
