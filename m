Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab1HDVyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:54:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40240 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab1HDVyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:54:01 -0400
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
	device
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>
In-Reply-To: <4E363DB9.70801@gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
	 <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
	 <4E325F98.5090308@gmail.com> <4E32F7F2.4080607@us.ibm.com>
	 <4E363DB9.70801@gmail.com>
Content-Type: text/plain
Date: Thu, 04 Aug 2011 14:58:52 -0700
Message-Id: <1312495132.9603.4.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu Yuan,

I started testing your patches. I applied your kernel patch to 3.0
and applied QEMU to latest git.

I passed 6 blockdevices from the host to guest (4 vcpu, 4GB RAM). 
I ran simple "dd" read tests from the guest on all block devices 
(with various blocksizes, iflag=direct).

Unfortunately, system doesn't stay up. I immediately get into
panic on the host. I didn't get time to debug the problem. Wondering
if you have seen this issue before and/or you have new patchset
to try ?

Let me know.

Thanks,
Badari

------------[ cut here ]------------
kernel BUG at mm/slab.c:3059!
invalid opcode: 0000 [#1] SMP 
CPU 7 
Modules linked in: vhost_blk ebtable_nat ebtables xt_CHECKSUM bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipt_REJECT ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log dm_round_robin scsi_dh_rdac dm_multipath vhost_net macvtap macvlan tun kvm_intel kvm cdc_ether usbnet mii microcode serio_raw pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sd_mod crc_t10dif qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: nf_defrag_ipv4]

Pid: 2744, comm: vhost-2698 Not tainted 3.0.0 #2 IBM  -[7870AC1]-/46M0761     
RIP: 0010:[<ffffffff8114932c>]  [<ffffffff8114932c>] cache_alloc_refill+0x22c/0x250
RSP: 0018:ffff880258c87d00  EFLAGS: 00010046
RAX: 0000000000000002 RBX: ffff88027f800040 RCX: dead000000200200
RDX: ffff880271128000 RSI: 0000000000000070 RDI: ffff88026eb6c000
RBP: ffff880258c87d50 R08: ffff880271128000 R09: 0000000000000003
R10: 000000021fffffff R11: ffff88026b5790c0 R12: ffff880272cd8c00
R13: ffff88027f822440 R14: 0000000000000002 R15: ffff88026eb6c000
FS:  0000000000000000(0000) GS:ffff88027fce0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000ecb100 CR3: 0000000270bfe000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process vhost-2698 (pid: 2744, threadinfo ffff880258c86000, task ffff8802703154c0)
Stack:
 ffff880200000002 000492d000000000 ffff88027f822460 ffff88027f822450
 ffff880258c87d60 ffff88027f800040 0000000000000000 00000000000080d0
 00000000000080d0 0000000000000246 ffff880258c87da0 ffffffff81149c82
Call Trace:
 [<ffffffff81149c82>] kmem_cache_alloc_trace+0x182/0x190
 [<ffffffffa0252f52>] handle_guest_kick+0x162/0x799 [vhost_blk]
 [<ffffffffa02514ab>] vhost_worker+0xcb/0x150 [vhost_blk]
 [<ffffffffa02513e0>] ? vhost_dev_set_owner+0x190/0x190 [vhost_blk]
 [<ffffffffa02513e0>] ? vhost_dev_set_owner+0x190/0x190 [vhost_blk]
 [<ffffffff81084c66>] kthread+0x96/0xa0
 [<ffffffff814d2f84>] kernel_thread_helper+0x4/0x10
 [<ffffffff81084bd0>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff814d2f80>] ? gs_change+0x13/0x13
Code: 48 89 df e8 07 fb ff ff 65 8b 14 25 58 dc 00 00 85 c0 48 63 d2 4c 8b 24 d3 74 16 41 83 3c 24 00 0f 84 fc fd ff ff e9 75 ff ff ff <0f> 0b 66 90 eb fc 31 c0 41 83 3c 24 00 0f 85 62 ff ff ff 90 e9 
RIP  [<ffffffff8114932c>] cache_alloc_refill+0x22c/0x250
 RSP <ffff880258c87d00>
---[ end trace e286566e512cba7b ]---







