Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab1CBDoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:44:22 -0500
Received: from science.horizon.com ([71.41.210.146]:58245 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757860Ab1CBDoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:44:20 -0500
Date: 1 Mar 2011 22:44:17 -0500
Message-ID: <20110302034417.4954.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Null pointer OOPS in sync_inodes_sb+0xa9/0x104
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just after resuming from a suspend to RAM, 2.6.38-rc6 plus Eric Dumazet's
[PATCH] net: Add default_advmss() methods to blackhole dst_ops

Core 2 duo, 32-bit kernel, 2 GiB RAM.
I suspend to RAM every few days; this is not the first
time since booting.

The display hadn'd flipped to X yet, so I managed to capture the screen
(manually transcribed):

BUG: unable to handle kernel NULL pointer dereference at 00000030
IP: [<c10a3a21>] sync_inodes_sb+0xa9/0x104
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.3/3-1.3:1.0/input11/name
Modules linked in: btusb sco rfcomm l2cap crc16 bluetooth ctr twofish_generic twofish_i586 twofish_common serpent xcbc sha256_generic b43 mac80211 cfg80211

Pid: 23367, comm: mount Not tainted 2.6.38-rc6 #228 Dell Inc. MXC061                          /0MG532
EIP: 0060:[<c10a3a21>] EFLAGS: 0010246 CPU: 1
EIP is at sync_inodes_sb+0xa9/0x104
EAX: c003fd5c EBX: f58f606c ECX: 00000000 EDX: 00000909
ESI: d4cc1424 EDI: c003fd0c EBP: 00000000 ESP: f56ffee8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mount (pid: 23367, ti=f56fe000 task=c28472a0 task.ti = f56fe000)
Stack:
 7fffffff f58f6000 00000001 00000000 f56ffef8 f56ffef8 f56fff04 00000000
 00000303 f56fff0c f56fff0c f58f6000 00000001 00000000 f4a57000 c10a6c72
 f58f6000 00000020 00000000 c108e442 00000000 00000000 00000020 00000000
Call Trace:
 [<c10a6c72>] ? _sync_filesystem+0x3a/0x69
 [<c108e442>] ? do_remount_sb+0x59/0xce
 [<c10a067b>] ? do_mount+0x214/0x6a8
 [<c10a0b83>] ? sys_mount+0x74/0xa9
 [<c1002750>] ? sysenter_do_call+0x12/0x26
Code: b9 3a c1 e8 f4 6d f8 ff b8 80 f7 51 c1 31 f6 e8 f1 09 26 00 8b 7b 6c 83 c3 6c 83 ef 50 eb 44 f6 47 30 38 75 38 8b af c0 00 00 00 <83> 7d 30 00 74 2c 89 f8 e8 1a 85 ff ff fe 05 80 f7 51 c1 89 f0
EIP: [<c10a3a21>] sync_inodes_sb+0xa9/0x104 SS:ESP 0068:f56ffee8
CR2: 0000000000000030

I can't make much sense out of it, but maybe someone can.  It's a simple
laptop with one rotating hard drive.  Distro is Debian/unstable, kernel
is hand-compiled from Linus' git.
