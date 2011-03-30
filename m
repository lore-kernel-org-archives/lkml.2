Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab1C3RjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:39:07 -0400
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:47405 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755278Ab1C3RjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:39:05 -0400
X-Greylist: delayed 1751 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Mar 2011 13:39:05 EDT
Date: Wed, 30 Mar 2011 18:09:50 +0100
From: Mike Keehan <Mike@Keehan.net>
To: linux-kernel@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org
Subject: Bug in 2.6.29-rc1 using NILFS
Message-ID: <20110330180950.5f4fcfc4@Keehan.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My laptop threw a bug when I opened claws-mail in 2.6.39-rc1.
My home partition uses a Nilfs2 filesystem.

The operating system continued working after a long pause, 
which could have been 30 seconds I guess.  I didn't try to do
anything else, just re-booted back into .38.

This is what the log captured:-

Mar 30 17:48:40 localhost kernel: BUG: unable to handle kernel NULL pointer dereference at 00000024
Mar 30 17:48:40 localhost kernel: IP: [<c1088bd9>] try_to_release_page+0x26/0x3e
Mar 30 17:48:40 localhost kernel: *pdpt = 000000003389c001 *pde = 0000000000000000 
Mar 30 17:48:40 localhost kernel: Oops: 0000 [#1] PREEMPT SMP 
Mar 30 17:48:40 localhost kernel: last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
Mar 30 17:48:40 localhost kernel: Modules linked in: nilfs2 video dvb_pll mt2060 dell_wmi dvb_usb_nova_t_usb2 dvb_usb_dibusb_common dib3000mc sparse_keymap radeon dibx000_common dvb_usb dvb_core ttm wmi drm_kms_helper sdhci_pci sdhci iwlagn i2c_i801 dell_laptop dcdbas cfbcopyarea mmc_core iTCO_wdt iTCO_vendor_support cfbimgblt cfbfillrect backlight
Mar 30 17:48:40 localhost kernel: 
Mar 30 17:48:40 localhost kernel: Pid: 5365, comm: claws-mail Not tainted 2.6.39-rc1 #129 Dell Inc. Studio XPS 1640/0U785D
Mar 30 17:48:40 localhost kernel: EIP: 0060:[<c1088bd9>] EFLAGS: 00210282 CPU: 1
Mar 30 17:48:40 localhost kernel: EIP is at try_to_release_page+0x26/0x3e
Mar 30 17:48:40 localhost kernel: EAX: f55a5b20 EBX: ccd34c94 ECX: 00000000 EDX: 000000d0
Mar 30 17:48:40 localhost kernel: ESI: 00000000 EDI: ccd34c94 EBP: cebdfc3c ESP: cebdfc34
Mar 30 17:48:40 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Mar 30 17:48:40 localhost kernel: Process claws-mail (pid: 5365, ti=cebde000 task=cd426940 task.ti=cebde000)
Mar 30 17:48:40 localhost kernel: Stack:
Mar 30 17:48:40 localhost kernel: f55a5b20 00000000 cebdfcb4 c1091716 ccd34c94 00000000 004dac09 004dac0a
Mar 30 17:48:40 localhost kernel: 00000000 00000000 ffffffff f461d9fc ccd34c94 00000001 00000000 f55a5b20
Mar 30 17:48:40 localhost kernel: 00200286 cebdfc90 c108ed9c cebdfc90 cdc277a8 00000002 cebdfc9c c10463a5
Mar 30 17:48:40 localhost kernel: Call Trace:
Mar 30 17:48:40 localhost kernel: [<c1091716>] invalidate_inode_pages2_range+0x151/0x233
Mar 30 17:48:40 localhost kernel: [<c108ed9c>] ? clear_page_dirty_for_io+0x7f/0xab
Mar 30 17:48:40 localhost kernel: [<c10463a5>] ? wake_up_bit+0x57/0x5b
Mar 30 17:48:40 localhost kernel: [<f8de1b94>] nilfs_btnode_delete+0x90/0x96 [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8de3c5b>] nilfs_btree_shrink+0x5e/0x6f [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8de469c>] nilfs_btree_delete+0x31f/0x35e [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8de532c>] nilfs_direct_delete_and_convert+0x17/0xc4 [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8de2cc5>] ? nilfs_btree_gather_data+0xeb/0xf5 [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8de2117>] nilfs_bmap_do_delete+0x5f/0x89 [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8de2175>] nilfs_bmap_truncate+0x34/0x87 [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8de2175>] ? nilfs_bmap_truncate+0x34/0x87 [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8de2237>] ? nilfs_bmap_last_key+0x2e/0x54 [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8ddcac0>] nilfs_truncate_bmap+0x4f/0x9b [nilfs2]
Mar 30 17:48:40 localhost kernel: [<f8ddce3e>] nilfs_evict_inode+0x84/0xe7 [nilfs2]
Mar 30 17:48:40 localhost kernel: [<c102a4db>] ? sub_preempt_count+0x27/0x34
Mar 30 17:48:40 localhost kernel: [<c10c9821>] evict+0x5d/0xf6
Mar 30 17:48:40 localhost kernel: [<c10c9b95>] iput+0x121/0x126
Mar 30 17:48:40 localhost kernel: [<c10c7556>] dentry_kill+0xf8/0x110
Mar 30 17:48:40 localhost kernel: [<c10c7b61>] dput+0xb0/0xba
Mar 30 17:48:40 localhost kernel: [<c10c2709>] sys_renameat+0x18b/0x1de
Mar 30 17:48:40 localhost kernel: [<c10a1195>] ? handle_mm_fault+0x144/0x15a
Mar 30 17:48:40 localhost kernel: [<c101d89f>] ? do_page_fault+0x2b2/0x2df
Mar 30 17:48:40 localhost kernel: [<c10c81a4>] ? d_move+0x62/0x17f
Mar 30 17:48:40 localhost kernel: [<c10c276e>] sys_rename+0x12/0x14
Mar 30 17:48:40 localhost kernel: [<c140c5cc>] sysenter_do_call+0x12/0x27
Mar 30 17:48:40 localhost kernel: Code: 5b 5e 5f c9 c3 55 89 e5 56 53 8b 08 8b 58 10 80 e1 01 75 04 0f 0b eb fe 8b 30 31 c9 81 e6 00 20 00 00 75 19 85 db 74 0e 8b 4b 38 <8b> 49 24 85 c9 74 04 ff d1 eb 05 e8 95 e5 04 00 89 c1 5b 89 c8 
Mar 30 17:48:40 localhost kernel: EIP: [<c1088bd9>] try_to_release_page+0x26/0x3e SS:ESP 0068:cebdfc34
Mar 30 17:48:40 localhost kernel: CR2: 0000000000000024
Mar 30 17:48:40 localhost kernel: ---[ end trace 5f1f2e30dd9be2ef ]---

Mike.

