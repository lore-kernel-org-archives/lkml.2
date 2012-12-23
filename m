Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab2LWPND (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 10:13:03 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:41747 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2LWPNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 10:13:00 -0500
Message-ID: <50D71F79.5010601@xs4all.nl>
Date: Sun, 23 Dec 2012 16:12:57 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.6.8. jfs issue?
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Found this one on one of the boxes:

BUG: unable to handle kernel paging request at 0000000000003b1c
IP: [<ffffffff810a9a73>] find_get_page+0x33/0x80
PGD 115a8a067 PUD 11901f067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: vfat msdos fat nls_utf8 isofs fuse binfmt_misc
cpufreq_ondemand f71882fg tda1004x budget_av saa7146_vv
snd_hda_codec_hdmi v4l2_common videodev hid_generic videobuf_dma_sg
snd_hda_codec_realtek videobuf_core budget_core fbcon snd_hda_intel
radeon bitblit snd_hda_codec snd_seq snd_seq_device softcursor
ttpci_eeprom cfbfillrect font snd_pcm saa7146 cfbimgblt cfbcopyarea
snd_page_alloc backlight drm_kms_helper snd_timer dvb_core ttm
powernow_k8 evdev mperf i2c_piix4 snd microcode processor button k10temp
nfsd exportfs auth_rpcgss nfs_acl lockd sunrpc autofs4 usbhid hid
ata_generic ehci_hcd ohci_hcd sr_mod cdrom
CPU 0
Pid: 1112, comm: TFWWrite Not tainted 3.6.8 #9 To Be Filled By O.E.M. To
Be Filled By O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff810a9a73>]  [<ffffffff810a9a73>] find_get_page+0x33/0x80
RSP: 0018:ffff8800ccee7ad8  EFLAGS: 00010246
RAX: ffff8801153a2680 RBX: 0000000000003b00 RCX: ffff8801153a2680
RDX: 0000000000000001 RSI: 000000000008f4f7 RDI: 0000000000003b00
RBP: ffff8801023fb440 R08: ffff8801153a2680 R09: ffff8801153a24b0
R10: 0000000000000039 R11: 0000000000000000 R12: 000000000008f4f7
R13: 00000000010200da R14: 00000000000000d0 R15: 0000000000001000
FS:  00007f7aca586700(0000) GS:ffff88011fc00000(0000) knlGS:00000000f773a6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000003b1c CR3: 000000011947a000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process TFWWrite (pid: 1112, threadinfo ffff8800ccee6000, task
ffff88004e3d12a0)
Stack:
 ffff8801023fb438 000000000008f4f7 000000000008f4f7 ffffffff810a9cdf
 0000000000001000 ffffffff81111c28 00000000010200da 000000000000000c
 ffff8801023fb438 ffffffff810aa4bb 0000000000000000 0000000000001000
Call Trace:
 [<ffffffff810a9cdf>] ? find_lock_page+0x1f/0x80
 [<ffffffff81111c28>] ? alloc_buffer_head+0x18/0xa0
 [<ffffffff810aa4bb>] ? grab_cache_page_write_begin+0x6b/0x110
 [<ffffffff81115077>] ? nobh_write_begin+0x37/0x440
 [<ffffffff811117d5>] ? __set_page_dirty+0x65/0xd0
 [<ffffffff811bdef2>] ? jfs_write_begin+0x42/0x80
 [<ffffffff811bdc80>] ? jfs_writepage+0x10/0x10
 [<ffffffff810a9555>] ? generic_file_buffered_write+0x115/0x2c0
 [<ffffffff810aada9>] ? __generic_file_aio_write+0x1e9/0x3f0
 [<ffffffff810e8bcc>] ? __sb_start_write+0x6c/0x130
 [<ffffffff810ab02e>] ? generic_file_aio_write+0x7e/0x100
 [<ffffffff810e6812>] ? do_sync_write+0x92/0xd0
 [<ffffffff810e7033>] ? vfs_write+0xa3/0x170
 [<ffffffff810e7347>] ? sys_write+0x47/0xa0
 [<ffffffff814018a2>] ? system_call_fastpath+0x16/0x1b
Code: 89 fb 48 8d 6b 08 e8 cd 9e fa ff 4c 89 e6 48 89 ef e8 02 2a 17 00
48 85 c0 49 89 c0 74 3a 48 8b 18 48 85 db 74 1f f6 c3 03 75 35 <8b> 53
1c 85 d2 74 d9 8d 72 01 89 d0 f0 0f b1 73 1c 39 c2 75 1c
RIP  [<ffffffff810a9a73>] find_get_page+0x33/0x80
 RSP <ffff8800ccee7ad8>
CR2: 0000000000003b1c
---[ end trace 96c276384a508cf6 ]---

Linux 3.6.8


Is this a kernel issue? Or a stray particle?


Kind regards,
Udo
