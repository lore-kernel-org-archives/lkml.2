Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0KHI4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:56:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43400 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0KHI4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 03:56:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sATvnrY7sCJ53LI1Wky5WSQk9f5AlkdLltGluOOKTSuD7CQdJhBJKwxhSbiNpFny6k
         jXGUHUdvbM0QB9VJ6nu5jdSpNLiaxonIx8BE/tFmr2l5B8fLSTH7j+RmoWib0gobTv5j
         eTcykxdWZcxRODdMwvKmbvOcYz+hV7TCTNoI4=
MIME-Version: 1.0
Date: Mon, 8 Nov 2010 16:56:30 +0800
Message-ID: <AANLkTi=BKkfWFt=Une0mggm_=X_VpfhT4g8Nt=cAnFqj@mail.gmail.com>
Subject: 2.6.36 oops in intel_ring_advance() (i915/DRM) when running opengl programs
From: Adrian Bono <adrian.bono@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tested 2.6.36 on an Asus laptop with an Intel GM965 chipset. I first
noticed the oops when i tried to run Virtualbox, which links to
opengl, and i tried reproducing it with glxgears, which it
consistently does.

I also noticed an earlier email on this oops, from august 16, 2010,
that didn't get any replies.
http://kerneltrap.org/mailarchive/linux-kernel/2010/8/16/4607090


Here's output from syslog:


Oct 27 21:49:02 subgenius kernel: Oops: 0000 [#1] PREEMPT SMP
Oct 27 21:49:02 subgenius kernel: last sysfs file:
/sys/devices/platform/coretemp.1/temp1_input
Oct 27 21:49:02 subgenius kernel: Modules linked in: vboxnetflt
vboxdrv coretemp hwmon usbhid usb_storage usb_libusual uhci_hcd
ehci_hcd usbcore snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_pcm snd_timer snd soundcore snd_page_alloc ath5k ath i915
drm_kms_helper drm fb fbdev i2c_algo_bit cfbcopyarea video backlight
output cfbimgblt cfbfillrect intel_agp agpgart
Oct 27 21:49:02 subgenius kernel:
Oct 27 21:49:02 subgenius kernel: Pid: 1846, comm: glxgears Not
tainted 2.6.36 #1 A8Le       /A8Le
Oct 27 21:49:02 subgenius kernel: EIP: 0060:[<00000000>] EFLAGS: 00210202 CPU: 1
Oct 27 21:49:02 subgenius kernel: EIP is at 0x0
Oct 27 21:49:02 subgenius kernel: EAX: f722a800 EBX: 00000001 ECX:
f6888014 EDX: f6888014
Oct 27 21:49:02 subgenius kernel: ESI: 00000002 EDI: f68aafd0 EBP:
f1f5fea8 ESP: f1f5fe4c
Oct 27 21:49:02 subgenius kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct 27 21:49:02 subgenius kernel: Process glxgears (pid: 1846,
ti=f1f5e000 task=f6564000 task.ti=f1f5e000)
Oct 27 21:49:02 subgenius kernel: Stack:
Oct 27 21:49:02 subgenius kernel:  f8365a73 f834af85 00000002 f722a800
f6888000 f802b898 00000000 f68aafc8
Oct 27 21:49:02 subgenius kernel: <0> 00000001 00000000 00000002
00000000 f1f5fea8 f722a800 00000018 f1e2c500
Oct 27 21:49:02 subgenius kernel: <0> f82302f0 bf882c08 4018644b
f8375534 00000018 f722a82c f834ac06 bf882c64
Oct 27 21:49:02 subgenius kernel: Call Trace:
Oct 27 21:49:02 subgenius kernel:  [<f8365a73>] ?
intel_ring_advance+0xe/0xf [i915]
Oct 27 21:49:02 subgenius kernel:  [<f834af85>] ?
i915_cmdbuffer+0x37f/0x413 [i915]
Oct 27 21:49:02 subgenius kernel:  [<f82302f0>] ? drm_ioctl+0x221/0x297 [drm]
Oct 27 21:49:02 subgenius kernel:  [<f834ac06>] ?
i915_cmdbuffer+0x0/0x413 [i915]
Oct 27 21:49:02 subgenius kernel:  [<c106514b>] ? do_wp_page+0x67d/0x6b3
Oct 27 21:49:02 subgenius kernel:  [<c11621b8>] ? pty_write+0x3d/0x43
Oct 27 21:49:02 subgenius kernel:  [<c1066698>] ? handle_mm_fault+0x79c/0x858
Oct 27 21:49:02 subgenius kernel:  [<c1023575>] ? __wake_up+0x29/0x39
Oct 27 21:49:02 subgenius kernel:  [<f82300cf>] ? drm_ioctl+0x0/0x297 [drm]
Oct 27 21:49:02 subgenius kernel:  [<c1082e42>] ? vfs_ioctl+0x16/0x2f
Oct 27 21:49:02 subgenius kernel:  [<c108334c>] ? do_vfs_ioctl+0x438/0x470
Oct 27 21:49:02 subgenius kernel:  [<c1018a26>] ? do_page_fault+0x31a/0x324
Oct 27 21:49:02 subgenius kernel:  [<c1044820>] ? sys_futex+0xfc/0x111
Oct 27 21:49:02 subgenius kernel:  [<c10833b0>] ? sys_ioctl+0x2c/0x42
Oct 27 21:49:02 subgenius kernel:  [<c12590f1>] ? syscall_call+0x7/0xb
Oct 27 21:49:02 subgenius kernel: Code:  Bad EIP value.
Oct 27 21:49:02 subgenius kernel: EIP: [<00000000>] 0x0 SS:ESP 0068:f1f5fe4c
Oct 27 21:49:02 subgenius kernel: CR2: 0000000000000000
Oct 27 21:49:02 subgenius kernel: ---[ end trace ccff8844e71a655b ]---
