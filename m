Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2C1SSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:18:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411Ab2C1SSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:18:22 -0400
Date: Wed, 28 Mar 2012 14:18:20 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: BUG: sleeping function called from invalid context at
 fs/proc/task_mmu.c:826
Message-ID: <20120328181820.GB14224@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this on v3.3-7919-g6658a69

	Dave

BUG: sleeping function called from invalid context at fs/proc/task_mmu.c:826
in_atomic(): 1, irqs_disabled(): 0, pid: 15123, name: trinity
INFO: lockdep is turned off.
Pid: 15123, comm: trinity Not tainted 3.3.0+ #30
Call Trace:
 [<ffffffff8109bf75>] __might_sleep+0x145/0x200
 [<ffffffff8122ee77>] ? pagemap_pte_range+0x67/0x340
 [<ffffffff8122ef3f>] pagemap_pte_range+0x12f/0x340
 [<ffffffff811924b9>] walk_page_range+0x389/0x520
 [<ffffffff8122e9a2>] pagemap_read+0x282/0x350
 [<ffffffff8122ee10>] ? clear_refs_pte_range+0x180/0x180
 [<ffffffff8122d340>] ? get_vmalloc_info+0x110/0x110
 [<ffffffff8122e5c0>] ? pid_numa_maps_open+0x20/0x20
 [<ffffffff811c3a43>] vfs_read+0xb3/0x180
 [<ffffffff811c3b5d>] sys_read+0x4d/0x90
 [<ffffffff816c02a9>] system_call_fastpath+0x16/0x1b

BUG: scheduling while atomic: trinity/15123/0x10000002
INFO: lockdep is turned off.
Modules linked in: scsi_transport_iscsi ip6_queue ipt_ULOG nfnetlink dccp_ipv4 dccp bnep sctp l2tp_ppp l2tp_netlink l2tp_core binfmt_misc hidp can_bcm ip_queue rfcomm cmtp kernelcapi phonet bluetooth rfkill can_raw can pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose ax25 af_802154 appletalk ipx p8022 psnap llc p8023 atm nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables btrfs zlib_deflate libcrc32c dm_mirror dm_region_hash dm_log raid0 snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm coretemp snd_timer snd soundcore snd_page_alloc ppdev dcdbas microcode pcspkr serio_raw iTCO_wdt iTCO_vendor_support i2c_i801 tg3 parport_pc parport shpchp i5000_edac edac_core i5k_amb sunrpc firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
Pid: 15123, comm: trinity Not tainted 3.3.0+ #30
Call Trace:
 [<ffffffff816ab6f0>] __schedule_bug+0x80/0x85
 [<ffffffff816b63b9>] __schedule+0x969/0x9d0
 [<ffffffff810a3f28>] __cond_resched+0x18/0x30
 [<ffffffff816b6842>] _cond_resched+0x32/0x40
 [<ffffffff8122ef44>] pagemap_pte_range+0x134/0x340
 [<ffffffff811924b9>] walk_page_range+0x389/0x520
 [<ffffffff8122e9a2>] pagemap_read+0x282/0x350
 [<ffffffff8122ee10>] ? clear_refs_pte_range+0x180/0x180
 [<ffffffff8122d340>] ? get_vmalloc_info+0x110/0x110
 [<ffffffff8122e5c0>] ? pid_numa_maps_open+0x20/0x20
 [<ffffffff811c3a43>] vfs_read+0xb3/0x180
 [<ffffffff811c3b5d>] sys_read+0x4d/0x90
 [<ffffffff816c02a9>] system_call_fastpath+0x16/0x1b

BUG: soft lockup - CPU#2 stuck for 22s! [trinity:15123]
Modules linked in: tun scsi_transport_iscsi ip6_queue ipt_ULOG nfnetlink dccp_ipv4 dccp bnep sctp l2tp_ppp l2tp_netlink l2tp_core binfmt_misc hidp can_bcm ip_queue rfcomm cmtp kernelcapi phonet bluetooth rfkill can_raw can pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose ax25 af_802154 appletalk ipx p8022 psnap llc p8023 atm nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables btrfs zlib_deflate libcrc32c dm_mirror dm_region_hash dm_log raid0 snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm coretemp snd_timer snd soundcore snd_page_alloc ppdev dcdbas microcode pcspkr serio_raw iTCO_wdt iTCO_vendor_support i2c_i801 tg3 parport_pc parport shpchp i5000_edac edac_core i5k_amb sunrpc firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
irq event stamp: 0
hardirqs last  enabled at (0): [<          (null)>]           (null)
hardirqs last disabled at (0): [<ffffffff81063958>] copy_process+0x6e8/0x19a0
softirqs last  enabled at (0): [<ffffffff81063958>] copy_process+0x6e8/0x19a0
softirqs last disabled at (0): [<          (null)>]           (null)


(and then shit really hit the fan, with it spewing that CPU stuck message for
every CPU over and over)

