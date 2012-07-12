Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab2GLAyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:54:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650Ab2GLAyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:54:16 -0400
Date: Wed, 11 Jul 2012 20:54:05 -0400
From: Dave Jones <davej@redhat.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
Message-ID: <20120712005405.GA1613@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Kay Sievers <kay@vrfy.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartmann <greg@kroah.com>
References: <20120709180328.GA4105@redhat.com>
 <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
 <1341859731.801.0.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1341859731.801.0.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 08:48:51PM +0200, Kay Sievers wrote:
 > On Mon, 2012-07-09 at 20:27 +0200, Kay Sievers wrote:
 > > On Mon, Jul 9, 2012 at 8:03 PM, Dave Jones <davej@redhat.com> wrote:
 > > > I noticed that the format of the oom-killer output seems to have changed, and
 > > > now it spews stuff like..
 > > >
 > > > [49461.758070] lowmem_reserve[]:
 > > > [49461.758071]  0
 > > > [49461.758071]  2643
 > > > [49461.758071]  3878
 > > > [49461.758072]  3878
 > > > [49461.758072]
 > > > [49461.758072] Node 0
 > > 
 > > > Does the oom-killer code need modifying, or the printk code ?
 > > > I know there's been some regressions in this area recently, but this is still
 > > > happening on the current tree (8c84bf4166a4698296342841a549bbee03860ac0)
 > > 
 > > This likely fixes it:
 > >   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-merge-cont.patch;hb=HEAD
 > > 
 > > Let me check if it does, and if I can reproduce it.
 > 
 > It looks fine here with the above mentioned patch:

Now that that patch is in Linus tree, I've hit what's probably a different case.
Look at the modules list in this oops..

[10016.460020] BUG: soft lockup - CPU#1 stuck for 22s! [trinity-child1:24295]
[10016.470008]  rose<4>[10016.470008]  ip_set_bitmap_ipmac<4>[10016.470008]  nf_conntrack_h323<4>[10016.470008]  girbil_sir<4>[10016.470008]  ath9k_common<4>[10016.470008]  hdlcdrv<4>[10016.470008]  tun<4>[10016.470008]  spcp8x5<4>[10016.470008]  rc_streamzap<4>[10016.470008]  rc_medion_x10<4>[10016.470008]  gspca_mr97310a<4>[10016.470008]  hid_multitouch<4>[10016.470008]  fam15h_power<4>[10016.470008]  sym53c8xx<4>[10016.470008]  gunze<4>[10016.470008]  pata_ns87410<4>[10016.470008]  snd_ymfpci<4>[10016.470008]  michael_mic<4>[10016.470008]  blocklayoutdriver nfs_layout_nfsv41_files nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables dm_mirror dm_region_hash dm_log btrfs zlib_deflate libcrc32c raid0 iTCO_wdt iTCO_vendor_support ppdev dcdbas coretemp kvm_intel kvm microcode snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device serio_raw snd_pcm lpc_ich mfd_core tg3 i2c_i801 pcspkr snd_timer i5000_edac edac_core snd i5k_amb soundcore snd_page_alloc parport_pc parport shpchp sunrpc firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
[10016.470008] irq event stamp: 82066
[10016.470008] hardirqs last  enabled at (82065): [<ffffffff816b8cf0>] restore_args+0x0/0x30
[10016.470008] hardirqs last disabled at (82066): [<ffffffff816c236a>] apic_timer_interrupt+0x6a/0x80
[10016.470008] softirqs last  enabled at (82064): [<ffffffff8106ef8c>] __do_softirq+0x13c/0x3e0
[10016.470008] softirqs last disabled at (82055): [<ffffffff816c2d6c>] call_softirq+0x1c/0x30
[10016.470008] CPU 1 
[10016.470008] Modules linked in:<4>[10016.470008]  unix_diag<4>[10016.470008]  ip_set_bitmap_ipmac<4>[10016.470008]  nf_conntrack_h323<4>[10016.470008]  girbil_sir<4>[10016.470008]  ath9k_common<4>[10016.470008]  hdlcdrv<4>[10016.470008]  tun<4>[10016.470008]  spcp8x5<4>[10016.470008]  rc_streamzap<4>[10016.470008]  rc_medion_x10<4>[10016.470008]  gspca_mr97310a<4>[10016.470008]  hid_multitouch<4>[10016.470008]  fam15h_power<4>[10016.470008]  sym53c8xx<4>[10016.470008]  gunze<4>[10016.470008]  pata_ns87410<4>[10016.470008]  snd_ymfpci<4>[10016.470008]  michael_mic<4>[10016.470008]  blocklayoutdriver nfs_layout_nfsv41_files nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables dm_mirror dm_region_hash dm_log btrfs zlib_deflate libcrc32c raid0 iTCO_wdt iTCO_vendor_support ppdev dcdbas coretemp kvm_intel kvm microcode snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device serio_raw snd_pcm lpc_ich mfd_core tg3 i2c_i801 pcspkr snd_timer i5000_edac edac_core snd i5k_amb soundcore snd_page_alloc parport_pc parport shpchp sunrpc firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
[10016.470008] 
[10016.470008] Pid: 24295, comm: trinity-child1 Tainted: G         C   3.5.0-rc6+ #80 Dell Inc.                 Precision WorkStation 490    /0DT031
[10016.470008] RIP: 0010:[<ffffffff810ce800>]  [<ffffffff810ce800>] match_held_lock+0x190/0x190
[10016.470008] RSP: 0018:ffff88016bdf1c10  EFLAGS: 00000202
[10016.470008] RAX: 0000000000000001 RBX: ffffffff81021d43 RCX: 000000000000000f
[10016.470008] RDX: ffff88016bdf1fd8 RSI: ffffffff81c2fb60 RDI: ffffffff81c2fb60
[10016.470008] RBP: ffff88016bdf1c38 R08: 000000000000000a R09: 0000000000000000
[10016.470008] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff81021db9
[10016.470008] R13: ffff88016bdf1b88 R14: ffffffff81021d43 R15: ffff88016bdf1b78
[10016.470008] FS:  00007fbad33ad700(0000) GS:ffff880226800000(0000) knlGS:0000000000000000
[10016.470008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10016.470008] CR2: 0000000000000001 CR3: 00000001413a1000 CR4: 00000000000007e0
[10016.470008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10016.470008] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10016.470008] Process trinity-child1 (pid: 24295, threadinfo ffff88016bdf0000, task ffff88016a244900)
[10016.470008] Stack:
[10016.470008]  ffffffff8132ef67 ffff88016bdf1c48 000000000000229c 00000000000034b2
[10016.470008]  ffffffff81c6c7c0 ffff88016bdf1c98 ffffffff812b319c ffff88016bdf1c98
[10016.470008]  0000000000000246 ffff88015a81d428 ffff88016bdf1cf0 13722bca39882609
[10016.470008] Call Trace:
[10016.470008]  [<ffffffff8132ef67>] ? idr_find+0xd7/0x150
[10016.470008]  [<ffffffff812b319c>] sysvipc_find_ipc+0x5c/0x170
[10016.470008]  [<ffffffff812b3374>] sysvipc_proc_next+0x54/0xf0
[10016.470008]  [<ffffffff811e8cd9>] traverse+0xc9/0x240
[10016.470008]  [<ffffffff811e91e0>] ? seq_lseek+0x120/0x120
[10016.470008]  [<ffffffff811e954d>] seq_read+0x36d/0x420
[10016.470008]  [<ffffffff811e91e0>] ? seq_lseek+0x120/0x120
[10016.470008]  [<ffffffff811e91e0>] ? seq_lseek+0x120/0x120
[10016.470008]  [<ffffffff8122f916>] proc_reg_read+0x86/0xc0
[10016.470008]  [<ffffffff8122f890>] ? proc_reg_write+0xc0/0xc0
[10016.470008]  [<ffffffff811c4649>] do_loop_readv_writev+0x59/0x90
[10016.470008]  [<ffffffff811c4966>] do_readv_writev+0x1b6/0x1d0
[10016.470008]  [<ffffffff810d462d>] ? trace_hardirqs_on+0xd/0x10
[10016.470008]  [<ffffffff816b8350>] ? _raw_spin_unlock_irq+0x30/0x50
[10016.470008]  [<ffffffff816c1855>] ? sysret_check+0x22/0x5d
[10016.470008]  [<ffffffff811c4a1c>] vfs_readv+0x3c/0x50
[10016.470008]  [<ffffffff811c4c6a>] sys_preadv+0xba/0xc0
[10016.470008]  [<ffffffff816c1829>] system_call_fastpath+0x16/0x1b
[10016.470008] Code: 80 3d dc 14 c1 00 01 74 a0 be cb 02 00 00 48 c7 c7 dc 94 9d 81 e8 81 63 f9 ff c6 05 c2 14 c1 00 01 eb 86 0f 1f 84 00 00 00 00 00 <55> 48 89 e5 41 56 41 55 49 89 fd 41 54 65 4c 8b 24 25 c0 c8 00 

Also, I have no idea how the hell the 'Modules linked in:' line (9th line) ended up being printed /after/ the
module listing began (2nd line).

Sidenote: Who maintains sysvipc ?

	Dave

