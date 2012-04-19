Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2DSRY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:24:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab2DSRYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:24:24 -0400
Date: Thu, 19 Apr 2012 13:24:19 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org
Subject: 3.4-rc3: kernel BUG at mm/memory.c:1228!
Message-ID: <20120419172419.GA18471@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My system call fuzzer just provoked this..

kernel BUG at mm/memory.c:1228!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 0 
Modules linked in: ipt_ULOG bnep scsi_transport_iscsi nfnetlink l2tp_ppp l2tp_netlink l2tp_core hidp nfs fscache auth_rpcgss nfs_acl binfmt_misc rfcomm sctp libcrc32c dccp_ipv6 dccp_ipv4 dccp caif_socket caif af_802154 phonet bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose ax25 x25 atm appletalk ipx p8022 psnap llc p8023 fuse lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter ip6_tables xt_state nf_conntrack xts gf128mul dm_crypt arc4 iwlwifi dell_wmi mac80211 sparse_keymap uvcvideo videobuf2_core videodev media cdc_ether videobuf2_vmalloc usbnet videobuf2_memops cdc_wdm mii cdc_acm snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device joydev snd_pcm cfg80211 coretemp microcode i2c_i801 pcspkr snd_timer iTCO_wdt tg3 rfkill iTCO_vendor_support snd soundcore snd_page_alloc wmi sunrpc i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]

Pid: 13948, comm: trinity Not tainted 3.4.0-rc3+ #86 Dell Inc. Adamo 13   /0N70T0
RIP: 0010:[<ffffffff8117ea02>]  [<ffffffff8117ea02>] unmap_single_vma+0x752/0x7c0
RSP: 0018:ffff88011877fc68  EFLAGS: 00010246
RAX: ffff88011059f380 RBX: ffff880112a093b0 RCX: 00000000f0000fff
RDX: 00003ffffffff000 RSI: 00000000f0001000 RDI: ffff88011877fdb8
RBP: ffff88011877fd48 R08: ffff88011877fe20 R09: 0000000000000000
R10: 0000000000000036 R11: 0000000000000000 R12: 00000000f0000000
R13: 00000000f0001000 R14: 0000000000000000 R15: ffff880102664c00
FS:  0000000000000000(0000) GS:ffff88013b200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000035de206cc4 CR3: 0000000105697000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity (pid: 13948, threadinfo ffff88011877e000, task ffff880117b84d40)
Stack:
 ffff88011877fce8 ffffffff81164996 ffff88013ffd9e00 0000000000000046
 000000001877fcb8 00000000f0000fff 00000000f0000fff 00000000f0001000
 ffff880105697000 00000000f0000fff ffff8801029d1018 8000000101a0d067
Call Trace:
 [<ffffffff81164996>] ? release_pages+0x1d6/0x230
 [<ffffffff8117f220>] unmap_vmas+0x60/0xb0
 [<ffffffff81186ea6>] exit_mmap+0x96/0x140
 [<ffffffff81060aa3>] mmput+0x73/0x110
 [<ffffffff81068fb8>] exit_mm+0x108/0x130
 [<ffffffff81069142>] do_exit+0x162/0xb90
 [<ffffffff813388a4>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff81069ebf>] do_group_exit+0x4f/0xc0
 [<ffffffff81069f47>] sys_exit_group+0x17/0x20
 [<ffffffff816a8469>] system_call_fastpath+0x16/0x1b
Code: 90 e9 ee fc ff ff 48 8b 95 78 ff ff ff 48 8b 7d a0 4c 89 e9 4c 89 e6 e8 6d de ff ff e9 f7 fc ff ff 4c 89 e6 e8 40 ac 01 00 eb b1 <0f> 0b 48 8b 45 a0 4c 89 fe 48 8b 38 e8 4d 58 03 00 e9 26 fb ff 
RIP  [<ffffffff8117ea02>] unmap_single_vma+0x752/0x7c0
 RSP <ffff88011877fc68>
---[ end trace 608233bdac605fbe ]---


That's this in zap_pmd_range...

	VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));

	Dave

