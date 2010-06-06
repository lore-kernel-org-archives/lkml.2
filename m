Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab0FFLzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 07:55:37 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36277 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0FFLzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:55:35 -0400
Date: Sun, 6 Jun 2010 20:55:34 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: 2.6.35-rc2 completely hosed on intel gfx?
Message-ID: <20100606115534.GA9399@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear everyone,

(please cc)

I just switched from 2.6.35-rc1 to rc2 and that hosed several things,
all seemingly related to intel graphics card driver:
- suspend suddenly hangs completely on switch, no traces found, not
  even sysrq was working
- X often (not 100%) hangs wihth a fix cursor (not blinking) on the 
  to left corner, I got a stack trace in my syslog for that:

general protection fault: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/backlight/acpi_video0/uevent
CPU 0 
Modules linked in: sco bnep rfcomm l2cap crc16 hso binfmt_misc dm_crypt dm_mod isofs btrfs zlib_deflate crc32c libcrc32c vfat fat fuse vboxdrv loop uinput snd_hda_codec_realtek arc4 snd_hda_intel iwlagn snd_hda_codec snd_hwdep iwlcore snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq mac80211 btusb firewire_ohci snd_timer snd_seq_device firewire_core bluetooth snd cfg80211 sony_laptop tpm_infineon crc_itu_t rfkill joydev soundcore snd_page_alloc

Pid: 2758, comm: Xorg Not tainted 2.6.35-rc2 #14 VAIO/VGN-Z11VN_B
RIP: 0010:[<ffffffff810efe19>]  [<ffffffff810efe19>] sysfs_follow_link+0x57/0x170
RSP: 0018:ffff88012fd33df8  EFLAGS: 00010286
RAX: ffff88012fd33de8 RBX: ffff88013efa3730 RCX: ffff88012fd33fd8
RDX: ffff880000000000 RSI: 0000000000000000 RDI: ffffffff816282f0
RBP: ffff88012fd33e38 R08: 0000000000000000 R09: 0000000000000002
R10: 0000000000000281 R11: 000000000002e8c5 R12: 0720072007200720
R13: ffff88013eea2d20 R14: ffff88012fd57000 R15: ffff88012fd57000
FS:  00007fa9c98cb700(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000003d75048 CR3: 000000012fd22000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process Xorg (pid: 2758, threadinfo ffff88012fd32000, task ffff8801333cb990)
Stack:
 0000000003d5e200 ffff88012fd33e58 ffff88012fd33e28 ffff88013ba17900
<0> 00007fff82211140 ffff88012fd33e58 00007fff82211140 0000000003d5e9cb
<0> ffff88012fd33f18 ffffffff810ad2f4 ffff88012fd33eb8 ffffffff00000400
Call Trace:
 [<ffffffff810ad2f4>] generic_readlink+0x40/0xa3
 [<ffffffff81038179>] ? current_fs_time+0x22/0x29
 [<ffffffff810ba3ee>] ? mnt_drop_write+0x43/0x4e
 [<ffffffff810b67d8>] ? touch_atime+0x10a/0x125
 [<ffffffff810a8160>] sys_readlinkat+0x63/0x7f
 [<ffffffff810a8192>] sys_readlink+0x16/0x18
 [<ffffffff81001feb>] system_call_fastpath+0x16/0x1b
Code: ff 0f 84 1d 01 00 00 48 8b 83 98 00 00 00 48 c7 c7 f0 82 62 81 48 8b 58 08 4c 8b 68 28 4d 89 fe e8 d7 c2 27 00 eb 34 4d 8b 65 08 <49> 8b 44 24 08 4c 39 e3 74 0a 48 85 c0 74 05 49 89 c4 eb ec 4c 
RIP  [<ffffffff810efe19>] sysfs_follow_link+0x57/0x170
 RSP <ffff88012fd33df8>
---[ end trace da2e388f90243d4a ]---


2.6.35-rc1 says about intel:
[    0.517442] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.519672] agpgart-intel 0000:00:00.0: detected 65532K stolen memory
[    0.540521] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    2.537531] fb0: inteldrmfb frame buffer device

PLese let me know if you need more information, thanks a lot

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
QUABBS (pl.n.)
The substances which emerge when you squeeze a blackhead.
			--- Douglas Adams, The Meaning of Liff
