Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0ESS1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:27:15 -0400
Received: from science.horizon.com ([71.41.210.146]:56877 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752642Ab0ESS1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:27:13 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2010 14:27:13 EDT
Date: 19 May 2010 14:20:27 -0400
Message-ID: <20100519182027.3412.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.34 + ssh segfault
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to scp a file (using a public key cached in ssh-agent) to another machine
with my new (up 21:40) 2.6.34 kernel failed twice with the same symptoms.

Wasn't a problem in 2.6.34-rc5.  (Same machines, same ssh key, etc.)
Hopefully someone can figure it out.  Uniprocessor Athlon XP, 2 GB RAM,
GCC 4.4.4.


I have another crash on boot on my laptop that I'm bisecting.  34
doesn't seem to be a lucky number for me.


[77350.698203] general protection fault: 4f80 [#1] 
[77350.698210] last sysfs file: /sys/devices/pci0000:00/0000:00:02.2/usb1/1-0:1.0/uevent
[77350.698214] Modules linked in: battery deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish cast5 des_generic cbc aes_i586 aes_generic xcbc sha512_generic sha256_generic sha1_generic crypto_null af_key loop fan thermal evdev serio_raw processor button thermal_sys
[77350.698245] 
[77350.698250] Pid: 3697, comm: ssh Not tainted 2.6.34 #14 FN41 / 
[77350.698255] EIP: 0060:[<c11ad8f3>] EFLAGS: 00010286 CPU: 0
[77350.698268] EIP is at sk_stream_wait_memory+0x134/0x188
[77350.698272] EAX: eced4fa9 EBX: f650c000 ECX: 00000001 EDX: 00000000
[77350.698277] ESI: fffffff5 EDI: 00000000 EBP: ca450e68 ESP: ca450df4
[77350.698281]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[77350.698287] Process ssh (pid: 3697, ti=ca450000 task=eced4f80 task.ti=ca450000)
[77350.698290] Stack:
[77350.698292]  b91c6038 eced4f80 00000000 eced4f80 c1028f1e ca19edd0 ca19edd0 f650c000
[77350.698300] <0> 00000004 00000000 00000000 c11cd6b8 eced47c0 000032e8 00000040 b91c65e0
[77350.698308] <0> 00000d48 000005a8 f6814c3c 000005a8 c39a2df4 00000000 00000000 ca450f60
[77350.698317] Call Trace:
[77350.698329]  [<c1028f1e>] ? autoremove_wake_function+0x0/0x29
[77350.698339]  [<c11cd6b8>] ? tcp_sendmsg+0x5c7/0x6fa
[77350.698349]  [<c11a50c4>] ? sock_aio_write+0xe9/0xf2
[77350.698359]  [<c1067fae>] ? do_sync_write+0x9d/0xd2
[77350.698366]  [<c1067dbe>] ? fsnotify_access+0x4c/0x53
[77350.698372]  [<c10684df>] ? vfs_write+0x8b/0xd8
[77350.698377]  [<c10685bf>] ? sys_write+0x3c/0x60
[77350.698384]  [<c1002510>] ? sysenter_do_call+0x12/0x26
[77350.698387] Code: 74 72 89 f1 31 d2 89 d8 89 0c 24 e8 3d a3 ff ff 8b 0c 24 ff 8b 34 01 00 00 85 ff 89 ce 74 17 8b 75 00 81 fe ff ff ff 7f 74 0c 29 <cf> b8 00 00 00 00 29 fe 0f 48 f0 89 75 00 31 ff e9 18 ff ff ff 
[77350.698426] EIP: [<c11ad8f3>] sk_stream_wait_memory+0x134/0x188 SS:ESP 0068:ca450df4
[77350.698454] ---[ end trace f6ff9dff06070f9c ]---

[77366.937785] general protection fault: 43e0 [#2] 
[77366.937793] last sysfs file: /sys/devices/pci0000:00/0000:00:02.2/usb1/1-0:1.0/uevent
[77366.937797] Modules linked in: battery deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish cast5 des_generic cbc aes_i586 aes_generic xcbc sha512_generic sha256_generic sha1_generic crypto_null af_key loop fan thermal evdev serio_raw processor button thermal_sys
[77366.937828] 
[77366.937834] Pid: 3702, comm: ssh Tainted: G      D    2.6.34 #14 FN41 / 
[77366.937839] EIP: 0060:[<c11ad8f3>] EFLAGS: 00010282 CPU: 0
[77366.937851] EIP is at sk_stream_wait_memory+0x134/0x188
[77366.937855] EAX: eced43e9 EBX: f6938480 ECX: 00000001 EDX: 00000000
[77366.937859] ESI: fffffff5 EDI: 00000000 EBP: da6c4e68 ESP: da6c4df4
[77366.937864]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[77366.937870] Process ssh (pid: 3702, ti=da6c4000 task=eced43e0 task.ti=da6c4000)
[77366.937873] Stack:
[77366.937875]  b896d038 eced43e0 00000000 eced43e0 c1028f1e de29fc70 de29fc70 f6938480
[77366.937883] <0> 00000004 00000000 00000000 c11cd6b8 eced4000 000032e8 00000040 b896d5e0
[77366.937891] <0> 00000d48 000005a8 d7e88c3c 000005a8 f6a6c5f4 00000000 00000000 da6c4f60
[77366.937900] Call Trace:
[77366.937912]  [<c1028f1e>] ? autoremove_wake_function+0x0/0x29
[77366.937922]  [<c11cd6b8>] ? tcp_sendmsg+0x5c7/0x6fa
[77366.937932]  [<c11a50c4>] ? sock_aio_write+0xe9/0xf2
[77366.937942]  [<c1067fae>] ? do_sync_write+0x9d/0xd2
[77366.937949]  [<c1067dbe>] ? fsnotify_access+0x4c/0x53
[77366.937955]  [<c10684df>] ? vfs_write+0x8b/0xd8
[77366.937960]  [<c10685bf>] ? sys_write+0x3c/0x60
[77366.937967]  [<c1002510>] ? sysenter_do_call+0x12/0x26
[77366.937970] Code: 74 72 89 f1 31 d2 89 d8 89 0c 24 e8 3d a3 ff ff 8b 0c 24 ff 8b 34 01 00 00 85 ff 89 ce 74 17 8b 75 00 81 fe ff ff ff 7f 74 0c 29 <cf> b8 00 00 00 00 29 fe 0f 48 f0 89 75 00 31 ff e9 18 ff ff ff 
[77366.938009] EIP: [<c11ad8f3>] sk_stream_wait_memory+0x134/0x188 SS:ESP 0068:da6c4df4
[77366.938037] ---[ end trace f6ff9dff06070f9d ]---

