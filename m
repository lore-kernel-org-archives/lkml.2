Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0JWRjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:39:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35638 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab0JWRjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:39:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=lWlqbZ/5ah1SfVRcvU7WoxoFLMukjNQCdBXwTGpiHwMEa5Wo8nayHA7BsZMFp8dSYk
         r4vWW/NDZIMIQQBmS7biBawpgHg0upf60UZMxUvgfr7id46OJBRRjHjHY49gFQEMF+0o
         nmXzVA7s6BdeJrkDcN7xgyIyMR+4Vbl1NFxwc=
MIME-Version: 1.0
Date: Sat, 23 Oct 2010 19:39:14 +0200
Message-ID: <AANLkTi=C4QpqAir0uf5tKbb_ZNo5BAuV3TAtY2mMu6bs@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference at 0000000c (elv_quiesce_start)
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.
Freshly pulled Linus' tree. Removing an unmounted USB drive gave:

[ 1379.802313] usb 1-3: USB disconnect, address 2
[ 1379.802589] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[ 1379.802724] IP: [<c1161f7f>] elv_quiesce_start+0x3/0x55
[ 1379.802820] *pde = 00000000
[ 1379.802873] Oops: 0000 [#1] PREEMPT
[ 1379.802940] last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C0A:00/power_supply/BAT0/type
[ 1379.803012] Modules linked in: [last unloaded: scsi_wait_scan]
[ 1379.803012]
[ 1379.803012]  [<c1167f40>] ? disk_replace_part_tbl+0x2b/0x51
[ 1379.803012]  [<c1167f7e>] ? disk_release+0x18/0x2b
[ 1379.803012]  [<c12208f8>] ? device_release+0x32/0x5e
[ 1379.803012]  [<c116ecbf>] ? kobject_release+0x3d/0x4f
[ 1379.803012]  [<c116ec82>] ? kobject_release+0x0/0x4f
[ 1379.803012]  [<c116fabc>] ? kref_put+0x35/0x3d
[ 1379.803012]  [<c1239fe6>] ? sg_device_destroy+0x3f/0x48
[ 1379.803012]  [<c1239fa7>] ? sg_device_destroy+0x0/0x48
[ 1379.803012]  [<c116fabc>] ? kref_put+0x35/0x3d
[ 1379.803012]  [<c1220d92>] ? device_del+0x9e/0x12f
[ 1379.803012]  [<c1220e2b>] ? device_unregister+0x8/0x10
[ 1379.803012]  [<c1233a81>] ? __scsi_remove_device+0x34/0x7e
[ 1379.803012]  [<c1232f07>] ? scsi_forget_host+0x45/0x72
[ 1379.803012]  [<c122cf46>] ? scsi_remove_host+0x84/0x102
[ 1379.803012]  [<c128c28f>] ? quiesce_and_remove_host+0x47/0x7f
[ 1379.803012]  [<c128c357>] ? usb_stor_disconnect+0x10/0x18
[ 1379.803012]  [<c1279aa3>] ? usb_unbind_interface+0x32/0xc1
[ 1379.803012]  [<c1222d45>] ? __device_release_driver+0x53/0x96
[ 1379.803012]  [<c1222d9d>] ? device_release_driver+0x15/0x1e
[ 1379.803012]  [<c1222a44>] ? bus_remove_device+0x5f/0x6a
[ 1379.803012]  [<c1220de0>] ? device_del+0xec/0x12f
[ 1379.803012]  [<c1278d90>] ? usb_disable_device+0x36/0xbc
[ 1379.803012]  [<c12744f4>] ? usb_disconnect+0x69/0xcb
[ 1379.803012]  [<c127501e>] ? hub_thread+0x324/0xa82
[ 1379.803012]  [<c1032de6>] ? autoremove_wake_function+0x0/0x29
[ 1379.803012]  [<c1274cfa>] ? hub_thread+0x0/0xa82
[ 1379.803012]  [<c1032b7e>] ? kthread+0x62/0x67
[ 1379.803012]  [<c1032b1c>] ? kthread+0x0/0x67
[ 1379.803012]  [<c1002bf6>] ? kernel_thread_helper+0x6/0x10
[ 1379.803012] Code: 8d 4a 01 83 fa 09 89 0d 94 56 60 c1 7f 18 50 8b
43 0c 8b 40 2c 83 c0 58 50 68 38 a9 49 c1 e8 bd 6a 22 00 83 c4 0c 5b
c3 53 89 c3 <83> 78 0c 00 74 4a 0f ba a8 c0 01 00 00 08 eb 33 89 d8 e8
d4 15
[ 1379.803012] EIP: [<c1161f7f>] elv_quiesce_start+0x3/0x55 SS:ESP 0068:f64e5e1c
[ 1379.803012] CR2: 000000000000000c
[ 1379.803012] ---[ end trace 230ef585b1215f7d ]---
[ 1379.803012] note: khubd[14] exited with preempt_count 1

My system seems to work fine, though.
Regards,
Fabio
