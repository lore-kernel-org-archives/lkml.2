Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0KASjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:39:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56736 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0KASjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=OWH6o+dzpqb8J7ByHI4U9tvNtsNeConOnAhcLgJxXY5Kc4AwqVPiflh+gmZiXibBHU
         R6OygH+lHST2Z7zA9fSNqj6a56fmm1WLCBx1BBfHRtta4NIOmz+/HPH/wVP3kGQAQ6nd
         gYhrJJ+Gc2SBNcrhDAubKR1uc0FPbK0nxo2ls=
MIME-Version: 1.0
Date: Mon, 1 Nov 2010 18:39:08 +0000
Message-ID: <AANLkTi=kkW7ruOVp7mPsMDWRRkL2CqrOJCyZqxj_Vekm@mail.gmail.com>
Subject: 2.6.36 BUG: scheduling while atomic: rc.sysinit/1376/0x00000002
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(cc me as I'm not subscribed)

Upgraded to 2.6.36, now I receive a lot of errors during boot (and
while running):
BUG: scheduling while atomic: rc.sysinit/1376/0x00000002
Modules linked in: joydev hid_logitech ff_memless snd_hda_codec_nvhdmi
usbhid hid snd_hda_codec_realtek snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_hda_intel snd_hda_codec
snd_pcm_oss snd_hwdep ohci_hcd snd_pcm ehci_hcd evdev snd_mixer_oss
i2c_nforce2 snd_timer pcspkr psmouse usbcore shpchp sg forcedeth wmi
i2c_core snd processor button serio_raw thermal pci_hotplug
snd_page_alloc soundcore raid456 async_raid6_recov async_pq raid6_pq
async_xor xor async_memcpy async_tx uvesafb cn sd_mod
Pid: 1376, comm: rc.sysinit Not tainted 2.6.36-ARCH #1
Call Trace:
[<ffffffff810397ce>] __schedule_bug+0x5e/0x70
[<ffffffff81403110>] schedule+0x950/0xa70
[<ffffffff81060bad>] ? insert_work+0x7d/0x90
[<ffffffff81060fbd>] ? queue_work_on+0x1d/0x30
[<ffffffff81061127>] ? queue_work+0x37/0x60
[<ffffffff8140377d>] schedule_timeout+0x21d/0x360
[<ffffffff812031c3>] ? generic_make_request+0x2c3/0x540
[<ffffffff81402680>] wait_for_common+0xc0/0x150
[<ffffffff81041490>] ? default_wake_function+0x0/0x10
[<ffffffff812034bc>] ? submit_bio+0x7c/0x100
[<ffffffff810680a0>] ? wake_bit_function+0x0/0x40
[<ffffffff814027b8>] wait_for_completion+0x18/0x20
[<ffffffff8120a969>] blkdev_issue_discard+0x1b9/0x210
[<ffffffff811ba03e>] ext4_free_blocks+0x68e/0xb60
[<ffffffff811b1650>] ? __ext4_handle_dirty_metadata+0x110/0x120
[<ffffffff811b098c>] ext4_ext_truncate+0x8cc/0xa70
[<ffffffff810d713e>] ? pagevec_lookup+0x1e/0x30
[<ffffffff81191618>] ext4_truncate+0x178/0x5d0
[<ffffffff810eacbb>] ? unmap_mapping_range+0xab/0x280
[<ffffffff810d8976>] vmtruncate+0x56/0x70
[<ffffffff811925cb>] ext4_setattr+0x14b/0x460
[<ffffffff811319e4>] notify_change+0x194/0x380
[<ffffffff81117f80>] do_truncate+0x60/0x90
[<ffffffff811e08fa>] ? security_inode_permission+0x1a/0x20
[<ffffffff811eaec1>] ? tomoyo_path_truncate+0x11/0x20
[<ffffffff81127539>] do_last+0x5d9/0x770
[<ffffffff811278bd>] do_filp_open+0x1ed/0x680
[<ffffffff8140644f>] ? page_fault+0x1f/0x30
[<ffffffff81132bfc>] ? alloc_fd+0xec/0x140
[<ffffffff81118db1>] do_sys_open+0x61/0x120
[<ffffffff81118e8b>] sys_open+0x1b/0x20
[<ffffffff81002e6b>] system_call_fastpath+0x16/0x1b

Additional info:
dmesg is here: http://nopaste.info/cf4db3e9f9.html
config is here: http://nopaste.info/3ec80514fe.html
lspci is here: http://nopaste.info/fe289c947d.html
cpuinfo is here: http://nopaste.info/ccf5e02b42.html

2.6.35 works fine.

// Mathias
