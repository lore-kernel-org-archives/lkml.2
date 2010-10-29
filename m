Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab0J2IF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:05:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35508 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab0J2IFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:05:48 -0400
MIME-Version: 1.0
Date: Fri, 29 Oct 2010 10:05:47 +0200
Message-ID: <AANLkTik5qVxkEGVAA1PSOGk2KTW+ekHpSwttsQEWzWj+@mail.gmail.com>
Subject: Kernel v2.6.36 trouble on USB disconnect
From: Ketil Froyn <ketil@froyn.name>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following trace when I disconnect USB devices. I'm running a
self-compiled 2.6.36 kernel from Linus' tree. It's on a Fujitsu
Lifebook P8110, as indicated in the trace. The system is a pretty
fresh install of Ubuntu 10.04.1.

Oct 29 09:50:35 ubuntu kernel: [61577.093493] usb 1-1: USB disconnect, address 2
Oct 29 09:50:35 ubuntu kernel: [61577.094154] *pdpt = 00000000114e8001
*pde = 0000000000000000
Oct 29 09:50:35 ubuntu kernel: [61577.094483] Modules linked in:
binfmt_misc ppdev fbcon snd_hda_codec_intelhdmi tileblit
snd_hda_codec_realtek font arc4 bit
blit softcursor iwlagn snd_hda_intel snd_hda_codec iwlcore i915
snd_hwdep snd_pcm_oss snd_mixer_oss mac80211 snd_pcm snd_seq_dummy
snd_seq_oss drm_kms_helper
 snd_seq_midi drm snd_rawmidi snd_seq_midi_event snd_seq snd_timer
cfg80211 snd_seq_device tpm_infineon uvcvideo snd psmouse tpm_tis
qcserial i2c_algo_bit in
tel_agp tpm fujitsu_laptop usb_wwan videodev soundcore agpgart video
tpm_bios usbserial lp serio_raw shpchp snd_page_alloc led_class output
v4l1_compat parpo
rt usb_storage ahci tg3 libahci
Oct 29 09:50:35 ubuntu kernel: [61577.095694]
Oct 29 09:50:35 ubuntu kernel: [61577.095727] Pid: 22, comm: khubd Not
tainted 2.6.36+ #1 FJNB203/LIFEBOOK P8110
Oct 29 09:50:35 ubuntu kernel: [61577.095842] EIP: 0060:[<c034efe9>]
EFLAGS: 00010282 CPU: 0
Oct 29 09:50:35 ubuntu kernel: [61577.095934] EIP is at
disk_replace_part_tbl+0x29/0x70
Oct 29 09:50:35 ubuntu kernel: [61577.096015] EAX: f3905e00 EBX:
f3b6cb20 ECX: 00000000 EDX: 00000000
Oct 29 09:50:35 ubuntu kernel: [61577.096115] ESI: 00000000 EDI:
00000000 EBP: f4d93d24 ESP: f4d93d1c
Oct 29 09:50:35 ubuntu kernel: [61577.096214]  DS: 007b ES: 007b FS:
00d8 GS: 00e0 SS: 0068
Oct 29 09:50:35 ubuntu kernel: [61577.096451]  f3905e00 c07ec3c8
f4d93d30 c034f0a0 00000000 f4d93d4c c04023fe f352c098
Oct 29 09:50:35 ubuntu kernel: [61577.096615] <0> f4c06880 f4d93d5c
00000002 f3905e58 f4d93d60 c035a4da f3905e74 c035a4a0
Oct 29 09:50:35 ubuntu kernel: [61577.096790] <0> f3bbd758 f4d93d70
c035b65d f3bbd740 00000286 f4d93d90 c035a3cd f3bbd71c
Oct 29 09:50:35 ubuntu kernel: [61577.097020]  [<c034f0a0>] ?
disk_release+0x20/0x40
Oct 29 09:50:35 ubuntu kernel: [61577.097104]  [<c04023fe>] ?
device_release+0x1e/0x80
Oct 29 09:50:35 ubuntu kernel: [61577.097190]  [<c035a4da>] ?
kobject_release+0x3a/0x80
Oct 29 09:50:35 ubuntu kernel: [61577.097274]  [<c035a4a0>] ?
kobject_release+0x0/0x80
Oct 29 09:50:35 ubuntu kernel: [61577.097357]  [<c035b65d>] ? kref_put+0x2d/0x60
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c035a3cd>] ?
kobject_put+0x1d/0x50
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c035a4a0>] ?
kobject_release+0x0/0x80
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c035b65d>] ? kref_put+0x2d/0x60
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c034f0d4>] ? put_disk+0x14/0x20
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c044272d>] ?
sg_device_destroy+0x4d/0x80
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c04426e0>] ?
sg_device_destroy+0x0/0x80
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c035b65d>] ? kref_put+0x2d/0x60
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c04426bb>] ?
sg_remove+0xeb/0x110
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0402bf5>] ?
device_del+0xa5/0x180
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0402ce0>] ?
device_unregister+0x10/0x20
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0429103>] ?
__scsi_remove_device+0x93/0xb0
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0425ce7>] ?
scsi_forget_host+0x67/0x70
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c041e39d>] ?
scsi_remove_host+0x5d/0xf0
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<f8725050>] ?
quiesce_and_remove_host+0x60/0xb0 [usb_storage]
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<f8725168>] ?
usb_stor_disconnect+0x18/0x30 [usb_storage]
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c04824b0>] ?
usb_unbind_interface+0x40/0x150
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0405821>] ?
__device_release_driver+0x51/0xb0
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0405945>] ?
device_release_driver+0x25/0x40
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0404bfb>] ?
bus_remove_device+0x7b/0xa0
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0402c47>] ?
device_del+0xf7/0x180
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c047f353>] ?
usb_disable_device+0x63/0x110
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0479206>] ?
usb_disconnect+0x86/0x110
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c047a66c>] ?
hub_thread+0x3ac/0xf50
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0170d70>] ?
autoremove_wake_function+0x0/0x50
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c047a2c0>] ?
hub_thread+0x0/0xf50
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c0170944>] ? kthread+0x74/0x80
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c01708d0>] ? kthread+0x0/0x80
Oct 29 09:50:35 ubuntu kernel: [61577.097415]  [<c010a306>] ?
kernel_thread_helper+0x6/0x10
Oct 29 09:50:35 ubuntu kernel: [61577.196096] ---[ end trace
c455b877519b36e5 ]---


-- 
Ketil Froyn
ketil@froyn.name
http://ketil.froyn.name/
