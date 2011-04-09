Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1DIV2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 17:28:12 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:45633 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab1DIV2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 17:28:09 -0400
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel BUG at fs/namei.c:1904!
Date: Sat, 9 Apr 2011 23:27:57 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38; KDE/4.6.2; i686; ; )
Cc: linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104092327.57985.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this oops when deleting files/directories on a mp3 player with fat 
filesystem:

------------[ cut here ]------------
kernel BUG at fs/namei.c:1904!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: 
/sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/uevent
Modules linked in: nls_cp850 vfat fat usb_storage snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss fuse 
dm_crypt dm_mod usbhid snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm sr_mod 
cdrom sg uhci_hcd fschmd snd_timer snd e1000 i2c_i801 snd_page_alloc [last 
unloaded: microcode]

Pid: 3169, comm: kio_file Tainted: G        W   2.6.39-rc1-00263-gf32578c #32 
FUJITSU SIEMENS SCENIC P / SCENICO P/D1561
EIP: 0060:[<c108409e>] EFLAGS: 00010283 CPU: 0
EIP is at may_delete+0x21/0xfb
EAX: f3b0f168 EBX: f0cfe800 ECX: 00000001 EDX: f635e980
ESI: f3b0f168 EDI: f3a804e8 EBP: c537a000 ESP: c537bf18
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process kio_file (pid: 3169, ti=c537a000 task=f36e4000 task.ti=c537a000)
Stack:
 c108b9ed 00000001 f0cfe800 f3b0f168 bf9bd9f0 c537a000 c108514d f0cfe800
 00000000 bf9bd9f0 c108670a f3e0f300 f38fcf00 dae4ff60 00000011 c2afa01f
 00000000 f6021780 f3b0f168 00000000 00000000 00000000 00000000 f6802c80
Call Trace:
 [<c108b9ed>] ? dput+0x18/0x106
 [<c108514d>] ? vfs_rmdir+0x11/0x93
 [<c108670a>] ? do_rmdir+0x7c/0xb9
 [<c13cb490>] ? sysenter_do_call+0x12/0x26
Code: 05 b9 e2 ff ff ff 89 c8 5b c3 55 57 56 53 83 ec 08 89 d3 89 4c 24 04 83 7a 
20 00 0f 84 d5 00 00 00 8b 52 10 8b 7a 20 39 c7 74 02 <0f> 0b ba 03 00 00 00 
89 f8 e8 68 ff ff ff 89 c6 85 c0 0f 85 b8 
EIP: [<c108409e>] may_delete+0x21/0xfb SS:ESP 0068:c537bf18
---[ end trace 8d9e7d012ec2cf9e ]---

Kernel version was b2a8b4b81966094703088a7bc76a313af841924d with some btrfs 
fixes on top.

regards,
  Johannes
