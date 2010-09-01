Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab0IAPBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:01:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55216 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab0IAPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer;
        b=ByTpDy4OrOqjoyvb4Ch5YUMsGTf9khFyinmyq2NHDbvRnKHNMij5HFZZm+ooWEk9AG
         wn04njG2Hgp3U2+GGCmH1HiWCku0jEEySgXAx1IuD0tKxgZwmwGRUnw4/qrWzK6zdDhd
         G4pxoogqxZK2KCImIq8zVIQ4R/WyuSe/jLPKA=
Subject: BUG: character device crashing after turning off device on
 usbserial
From: Peter =?UTF-8?Q?J=C3=BAno=C5=A1?= <petoju@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-UniGv7ngJrIkwOyMUIRt"
Date: Wed, 01 Sep 2010 17:01:34 +0200
Message-ID: <1283353294.19680.3.camel@peto-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UniGv7ngJrIkwOyMUIRt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hello,
I would like to report a bug stated in $SUBJ; important parts from dmesg
and ver_linux are enclosed. If you are not correct recipient, send me,
please, emails of correct recipients.

Reproducible: sometimes

Steps to reproduce:
1.) Connect usbserial device via USB.
2.) Turn it on.
3.) Send something to this USB.
4.) Turn it off.
5.) Read your dmesg & note that device is not responding anymore.

Addional information:
-device connected via USB was AOiP calys 50, usbserial build-in, more
information is enclosed in dmesg_on_connect
-in step 3 I was learning about Linux serial programming and maybe I did
something wrong - wrong data written to port, incorrect flags set, data
could be send/received only partially. Everything was run as regular
user (no root, no kernel modules)
-more information can be requested via email


Peter Júnoš
-- 
"Verba docent, exempla trahunt."


--=-UniGv7ngJrIkwOyMUIRt
Content-Disposition: attachment; filename="dmesg"
Content-Type: text/plain; name="dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[ 1336.540432] kernel BUG at drivers/char/tty_ldisc.c:726!
[ 1336.540439] invalid opcode: 0000 [#1] SMP 
[ 1336.540447] last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
[ 1336.540453] CPU 1 
[ 1336.540456] Modules linked in: cp210x usbserial xt_tcpudp iptable_filter ip_tables x_tables binfmt_misc vboxnetadp vboxnetflt vboxdrv nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss snd_hda_codec_atihdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm radeon snd_seq_midi ttm joydev snd_rawmidi snd_seq_midi_event drm_kms_helper hp_accel uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 lis3lv02d hp_wmi snd_seq drm i2c_algo_bit input_polldev led_class sunrpc snd_timer snd_seq_device wmi i2c_core snd video output soundcore snd_page_alloc intel_agp psmouse serio_raw usbhid hid ahci libahci sky2
[ 1336.540557] 
[ 1336.540565] Pid: 29, comm: khubd Not tainted 2.6.35-muj #1 3074/HP ProBook 4510s
[ 1336.540572] RIP: 0010:[<ffffffff81330b30>]  [<ffffffff81330b30>] tty_ldisc_reinit+0x50/0x60
[ 1336.540590] RSP: 0018:ffff88013979faf0  EFLAGS: 00010202
[ 1336.540596] RAX: ffffffffffffffea RBX: ffff880126852800 RCX: 02000000000000c1
[ 1336.540602] RDX: 00000000000000b8 RSI: ffffea0004089b20 RDI: 00000000000000bf
[ 1336.540608] RBP: ffff88013979fb00 R08: 0000000000000001 R09: 0000000000000000
[ 1336.540613] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000000bf
[ 1336.540619] R13: ffff880126852820 R14: 0000000000000000 R15: ffff8801268529e0
[ 1336.540626] FS:  0000000000000000(0000) GS:ffff880001e80000(0000) knlGS:0000000000000000
[ 1336.540633] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1336.540639] CR2: 00007f8e55906000 CR3: 0000000117467000 CR4: 00000000000006e0
[ 1336.540646] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1336.540652] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1336.540659] Process khubd (pid: 29, threadinfo ffff88013979e000, task ffff88013b7444a0)
[ 1336.540663] Stack:
[ 1336.540667]  ffff880126852800 0000000000000000 ffff88013979fb30 ffffffff81330d00
[ 1336.540676] <0> ffff880126852800 ffff880126852800 ffff880126852a10 ffff880126852a10
[ 1336.540687] <0> ffff88013979fb90 ffffffff813282fe ffff88013979fb70 0000000000000000
[ 1336.540698] Call Trace:
[ 1336.540709]  [<ffffffff81330d00>] tty_ldisc_hangup+0x1c0/0x1f0
[ 1336.540718]  [<ffffffff813282fe>] do_tty_hangup+0x16e/0x3e0
[ 1336.540727]  [<ffffffff81328585>] tty_vhangup+0x15/0x20
[ 1336.540741]  [<ffffffffa05df49c>] usb_serial_disconnect+0xac/0x1d0 [usbserial]
[ 1336.540754]  [<ffffffff813d3b0a>] usb_unbind_interface+0x5a/0x1a0
[ 1336.540765]  [<ffffffff8135ac55>] __device_release_driver+0x75/0xe0
[ 1336.540773]  [<ffffffff8135adad>] device_release_driver+0x2d/0x40
[ 1336.540781]  [<ffffffff81359d71>] bus_remove_device+0xb1/0xf0
[ 1336.540789]  [<ffffffff81357a07>] device_del+0x127/0x1d0
[ 1336.540798]  [<ffffffff813d0257>] usb_disable_device+0xa7/0x130
[ 1336.540806]  [<ffffffff813c996b>] usb_disconnect+0xdb/0x170
[ 1336.540815]  [<ffffffff813ca9d2>] hub_thread+0x4a2/0x13a0
[ 1336.540825]  [<ffffffff8104c271>] ? dequeue_entity+0x1b1/0x1f0
[ 1336.540835]  [<ffffffff81071fa0>] ? autoremove_wake_function+0x0/0x40
[ 1336.540843]  [<ffffffff813ca530>] ? hub_thread+0x0/0x13a0
[ 1336.540851]  [<ffffffff81071a76>] kthread+0x96/0xa0
[ 1336.540860]  [<ffffffff81003d94>] kernel_thread_helper+0x4/0x10
[ 1336.540868]  [<ffffffff810719e0>] ? kthread+0x0/0xa0
[ 1336.540875]  [<ffffffff81003d90>] ? kernel_thread_helper+0x0/0x10
[ 1336.540880] Code: c7 43 40 00 00 00 00 44 89 e7 e8 6c fe ff ff 48 3d 00 f0 ff ff 77 14 48 89 43 40 44 89 e6 48 89 df e8 e5 f9 ff ff 5b 41 5c c9 c3 <0f> 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 
[ 1336.540960] RIP  [<ffffffff81330b30>] tty_ldisc_reinit+0x50/0x60
[ 1336.540970]  RSP <ffff88013979faf0>
[ 1336.540977] ---[ end trace 58107ed7e885d2ba ]---

[ 1917.791522] kernel BUG at drivers/char/tty_ldisc.c:726!
[ 1917.791528] invalid opcode: 0000 [#1] SMP 
[ 1917.791536] last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
[ 1917.791542] CPU 0 
[ 1917.791546] Modules linked in: cp210x usbserial xt_tcpudp iptable_filter ip_tables x_tables binfmt_misc vboxnetadp vboxnetflt vboxdrv nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss snd_hda_codec_atihdmi snd_hda_codec_analog sunrpc snd_hda_intel radeon snd_hda_codec snd_hwdep snd_pcm ttm snd_seq_midi drm_kms_helper snd_rawmidi snd_seq_midi_event snd_seq joydev hp_wmi uvcvideo snd_timer drm videodev v4l1_compat snd_seq_device v4l2_compat_ioctl32 snd psmouse i2c_algo_bit i2c_core serio_raw soundcore snd_page_alloc wmi intel_agp hp_accel lis3lv02d input_polldev video output led_class ahci sky2 libahci
[ 1917.791646] 
[ 1917.791653] Pid: 29, comm: khubd Not tainted 2.6.35-muj #1 3074/HP ProBook 4510s
[ 1917.791659] RIP: 0010:[<ffffffff81330b30>]  [<ffffffff81330b30>] tty_ldisc_reinit+0x50/0x60
[ 1917.791677] RSP: 0018:ffff8801397adaf0  EFLAGS: 00010202
[ 1917.791683] RAX: ffffffffffffffea RBX: ffff88011d943000 RCX: 0000000000000002
[ 1917.791689] RDX: 0000000000000002 RSI: ffffffff81c8a480 RDI: 00000000000000bf
[ 1917.791695] RBP: ffff8801397adb00 R08: 0000000000000000 R09: 0000000000000000
[ 1917.791701] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000000bf
[ 1917.791707] R13: ffff88011d943020 R14: 0000000000000000 R15: ffff88011d9431e0
[ 1917.791714] FS:  0000000000000000(0000) GS:ffff880001e00000(0000) knlGS:0000000000000000
[ 1917.791721] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1917.791727] CR2: 00007fa2239e0000 CR3: 00000000ba84c000 CR4: 00000000000006f0
[ 1917.791733] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1917.791739] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1917.791746] Process khubd (pid: 29, threadinfo ffff8801397ac000, task ffff88013aafc4a0)
[ 1917.791751] Stack:
[ 1917.791754]  ffff88011d943000 0000000000000000 ffff8801397adb30 ffffffff81330d00
[ 1917.791764] <0> ffff88011d943000 ffff88011d943000 ffff88011d943210 ffff88011d943210
[ 1917.791774] <0> ffff8801397adb90 ffffffff813282fe ffff8801397adb70 0000000000000000
[ 1917.791785] Call Trace:
[ 1917.791796]  [<ffffffff81330d00>] tty_ldisc_hangup+0x1c0/0x1f0
[ 1917.791805]  [<ffffffff813282fe>] do_tty_hangup+0x16e/0x3e0
[ 1917.791814]  [<ffffffff81328585>] tty_vhangup+0x15/0x20
[ 1917.791828]  [<ffffffffa05c349c>] usb_serial_disconnect+0xac/0x1d0 [usbserial]
[ 1917.791840]  [<ffffffff813d3b0a>] usb_unbind_interface+0x5a/0x1a0
[ 1917.791850]  [<ffffffff8135ac55>] __device_release_driver+0x75/0xe0
[ 1917.791858]  [<ffffffff8135adad>] device_release_driver+0x2d/0x40
[ 1917.791866]  [<ffffffff81359d71>] bus_remove_device+0xb1/0xf0
[ 1917.791874]  [<ffffffff81357a07>] device_del+0x127/0x1d0
[ 1917.791883]  [<ffffffff813d0257>] usb_disable_device+0xa7/0x130
[ 1917.791891]  [<ffffffff813c996b>] usb_disconnect+0xdb/0x170
[ 1917.791900]  [<ffffffff813ca9d2>] hub_thread+0x4a2/0x13a0
[ 1917.791909]  [<ffffffff8104c271>] ? dequeue_entity+0x1b1/0x1f0
[ 1917.791920]  [<ffffffff81071fa0>] ? autoremove_wake_function+0x0/0x40
[ 1917.791928]  [<ffffffff813ca530>] ? hub_thread+0x0/0x13a0
[ 1917.791936]  [<ffffffff81071a76>] kthread+0x96/0xa0
[ 1917.791945]  [<ffffffff81003d94>] kernel_thread_helper+0x4/0x10
[ 1917.791953]  [<ffffffff810719e0>] ? kthread+0x0/0xa0
[ 1917.791960]  [<ffffffff81003d90>] ? kernel_thread_helper+0x0/0x10
[ 1917.791965] Code: c7 43 40 00 00 00 00 44 89 e7 e8 6c fe ff ff 48 3d 00 f0 ff ff 77 14 48 89 43 40 44 89 e6 48 89 df e8 e5 f9 ff ff 5b 41 5c c9 c3 <0f> 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 
[ 1917.792045] RIP  [<ffffffff81330b30>] tty_ldisc_reinit+0x50/0x60
[ 1917.792055]  RSP <ffff8801397adaf0>

--=-UniGv7ngJrIkwOyMUIRt
Content-Disposition: attachment; filename="dmesg_on_connect"
Content-Type: text/plain; name="dmesg_on_connect"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[ 2949.800209] usb 6-1: new full speed USB device using uhci_hcd and address 2
[ 2950.046893] usbcore: registered new interface driver usbserial
[ 2950.046915] USB Serial support registered for generic
[ 2950.046951] usbcore: registered new interface driver usbserial_generic
[ 2950.046953] usbserial: USB Serial Driver core
[ 2950.048989] USB Serial support registered for cp210x
[ 2950.049030] cp210x 6-1:1.0: cp210x converter detected
[ 2950.160208] usb 6-1: reset full speed USB device using uhci_hcd and address 2
[ 2950.311603] usb 6-1: cp210x converter now attached to ttyUSB0
[ 2950.311652] usbcore: registered new interface driver cp210x
[ 2950.311657] cp210x: v0.09:Silicon Labs CP210x RS232 serial adaptor driver

--=-UniGv7ngJrIkwOyMUIRt
Content-Disposition: attachment; filename="ver_linux"
Content-Type: text/plain; name="ver_linux"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Linux peto-laptop 2.6.35-muj #1 SMP Wed Aug 11 09:46:42 CEST 2010 x86_64 GNU/Linux
 
Gnu C                  4.4.5
Gnu make               3.81
binutils               2.20.51
util-linux             2.17.2
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.12
pcmciautils            014
Linux C Library        2.12.1
Dynamic linker (ldd)   2.12.1
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               8.5
wireless-tools         30
Modules Loaded         usbhid hid xt_tcpudp iptable_filter ip_tables x_tables binfmt_misc vboxnetadp vboxnetflt vboxdrv nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss snd_hda_codec_atihdmi snd_hda_codec_analog sunrpc radeon snd_hda_intel snd_hda_codec snd_seq_midi snd_hwdep snd_rawmidi snd_seq_midi_event ttm snd_pcm snd_seq drm_kms_helper joydev snd_seq_device snd_timer hp_wmi uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 drm i2c_algo_bit psmouse hp_accel i2c_core video lis3lv02d input_polldev serio_raw snd output led_class wmi soundcore snd_page_alloc intel_agp ahci libahci sky2

--=-UniGv7ngJrIkwOyMUIRt--

