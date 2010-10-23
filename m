Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab0JWTTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:19:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57870 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab0JWTTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZlGtfDjLFUVQfPcBFB9GXjk2izX5nnjB5cNeszyiMmEfl4JEiMzuriw85LDUse7goL
         R1F7D7Jgbq8vE6Zj4mHPwGNFKjnif6Lehmy4yXsvv+SscPQPZih1mUs0eAbs/BPCT72Z
         USPULmnCYW+ZF40XsnlqdyE9vbcZSsIj+uH4E=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=C4QpqAir0uf5tKbb_ZNo5BAuV3TAtY2mMu6bs@mail.gmail.com>
References: <AANLkTi=C4QpqAir0uf5tKbb_ZNo5BAuV3TAtY2mMu6bs@mail.gmail.com>
Date: Sat, 23 Oct 2010 21:19:05 +0200
Message-ID: <AANLkTi=O6S0feKJ-nOQXVHZrkJ626CN0=Wta8zVhT7=y@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 0000000c (elv_quiesce_start)
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, different config, same action, another crash:

[   77.345978] usb 1-2: USB disconnect, address 2
[   77.346276] BUG: unable to handle kernel NULL pointer dereference at 00000208
[   77.346410] IP: [<c117271a>] disk_replace_part_tbl+0x19/0x47
[   77.346513] *pde = 00000000
[   77.346566] Oops: 0000 [#1] PREEMPT SMP
[   77.346645] last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C0A:00/power_supply/BAT0/type
[   77.346800] Modules linked in: scsi_wait_scan
[   77.346879]
[   77.346909] Pid: 15, comm: khubd Not tainted 2.6.36+ #1 900/900
[   77.347003] EIP: 0060:[<c117271a>] EFLAGS: 00010282 CPU: 0
[   77.347026] EIP is at disk_replace_part_tbl+0x19/0x47
[   77.347026] EAX: f581c600 EBX: f63c4720 ECX: 40000000 EDX: 00000000
[   77.347026] ESI: 00000000 EDI: c15515ec EBP: f5812800 ESP: f60d5e1c
[   77.347026]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   77.347026] Process khubd (pid: 15, ti=f60d4000 task=f603f2c0
task.ti=f60d4000)
[   77.347026] Stack:
[   77.347026]  f581c600 00000000 c1172793 00000000 c122a668 f581c658
c11795d6 f581c674
[   77.347026] <0> c1179599 f61310b8 c117a3c2 f63ffb80 00000202
c124205f f63ffbac c124202d
[   77.347026] <0> c117a3c2 f6131188 c1552440 c122ab0e f6131188
f61310b8 00000282 c122aba9
[   77.347026] Call Trace:
[   77.347026]  [<c1172793>] ? disk_release+0x18/0x36
[   77.347026]  [<c122a668>] ? device_release+0x32/0x5e
[   77.347026]  [<c11795d6>] ? kobject_release+0x3d/0x4f
[   77.347026]  [<c1179599>] ? kobject_release+0x0/0x4f
[   77.347026]  [<c117a3c2>] ? kref_put+0x36/0x3e
[   77.347026]  [<c124205f>] ? sg_device_destroy+0x32/0x3b
[   77.347026]  [<c124202d>] ? sg_device_destroy+0x0/0x3b
[   77.347026]  [<c117a3c2>] ? kref_put+0x36/0x3e
[   77.347026]  [<c122ab0e>] ? device_del+0xa0/0x133
[   77.347026]  [<c122aba9>] ? device_unregister+0x8/0x10
[   77.347026]  [<c123be13>] ? __scsi_remove_device+0x34/0x7e
[   77.347026]  [<c123b2ea>] ? scsi_forget_host+0x32/0x4c
[   77.347026]  [<c12354d5>] ? scsi_remove_host+0x5e/0xcb
[   77.347026]  [<c1294929>] ? quiesce_and_remove_host+0x49/0x77
[   77.347026]  [<c12949ea>] ? usb_stor_disconnect+0x10/0x18
[   77.347026]  [<c128268a>] ? usb_unbind_interface+0x32/0xa3
[   77.347026]  [<c122ca90>] ? __device_release_driver+0x42/0x79
[   77.347026]  [<c122cadc>] ? device_release_driver+0x15/0x1e
[   77.347026]  [<c122c7a1>] ? bus_remove_device+0x5f/0x6a
[   77.347026]  [<c122ab5e>] ? device_del+0xf0/0x133
[   77.347026]  [<c1281994>] ? usb_disable_device+0x36/0xbc
[   77.347026]  [<c127d27f>] ? usb_disconnect+0x69/0xc4
[   77.347026]  [<c127dd63>] ? hub_thread+0x314/0xa51
[   77.347026]  [<c127da4f>] ? hub_thread+0x0/0xa51
[   77.347026]  [<c1398689>] ? schedule+0x626/0x6a1
[   77.347026]  [<c103a9e8>] ? autoremove_wake_function+0x0/0x29
[   77.347026]  [<c127da4f>] ? hub_thread+0x0/0xa51
[   77.347026]  [<c103a727>] ? kthread+0x63/0x68
[   77.347026]  [<c103a6c4>] ? kthread+0x0/0x68
[   77.347026]  [<c1002c56>] ? kernel_thread_helper+0x6/0x10
[   77.347026] Code: ff 70 b8 68 63 ed 4e c1 51 e8 9a ba 00 00 83 c4
0c c3 56 53 8b 58 30 8b b0 4c 01 00 00 85 db 89 50 30 74 32 c7 43 0c
00 00 00 00 <8b> 86 08 02 00 00 e8 e8 72 22 00 89 f0 e8 1f 97 ff ff 8b
86 08
[   77.347026] EIP: [<c117271a>] disk_replace_part_tbl+0x19/0x47
SS:ESP 0068:f60d5e1c
[   77.347026] CR2: 0000000000000208
[   77.428741] ---[ end trace f878ff60aa54a932 ]---

BTW, this is a regression from plain 2.6.36.



On Sat, Oct 23, 2010 at 7:39 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi all.
> Freshly pulled Linus' tree. Removing an unmounted USB drive gave:
>
> [ 1379.802313] usb 1-3: USB disconnect, address 2
> [ 1379.802589] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> [ 1379.802724] IP: [<c1161f7f>] elv_quiesce_start+0x3/0x55
> [ 1379.802820] *pde = 00000000
> [ 1379.802873] Oops: 0000 [#1] PREEMPT
> [ 1379.802940] last sysfs file:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C0A:00/power_supply/BAT0/type
> [ 1379.803012] Modules linked in: [last unloaded: scsi_wait_scan]
> [ 1379.803012]
> [ 1379.803012]  [<c1167f40>] ? disk_replace_part_tbl+0x2b/0x51
> [ 1379.803012]  [<c1167f7e>] ? disk_release+0x18/0x2b
> [ 1379.803012]  [<c12208f8>] ? device_release+0x32/0x5e
> [ 1379.803012]  [<c116ecbf>] ? kobject_release+0x3d/0x4f
> [ 1379.803012]  [<c116ec82>] ? kobject_release+0x0/0x4f
> [ 1379.803012]  [<c116fabc>] ? kref_put+0x35/0x3d
> [ 1379.803012]  [<c1239fe6>] ? sg_device_destroy+0x3f/0x48
> [ 1379.803012]  [<c1239fa7>] ? sg_device_destroy+0x0/0x48
> [ 1379.803012]  [<c116fabc>] ? kref_put+0x35/0x3d
> [ 1379.803012]  [<c1220d92>] ? device_del+0x9e/0x12f
> [ 1379.803012]  [<c1220e2b>] ? device_unregister+0x8/0x10
> [ 1379.803012]  [<c1233a81>] ? __scsi_remove_device+0x34/0x7e
> [ 1379.803012]  [<c1232f07>] ? scsi_forget_host+0x45/0x72
> [ 1379.803012]  [<c122cf46>] ? scsi_remove_host+0x84/0x102
> [ 1379.803012]  [<c128c28f>] ? quiesce_and_remove_host+0x47/0x7f
> [ 1379.803012]  [<c128c357>] ? usb_stor_disconnect+0x10/0x18
> [ 1379.803012]  [<c1279aa3>] ? usb_unbind_interface+0x32/0xc1
> [ 1379.803012]  [<c1222d45>] ? __device_release_driver+0x53/0x96
> [ 1379.803012]  [<c1222d9d>] ? device_release_driver+0x15/0x1e
> [ 1379.803012]  [<c1222a44>] ? bus_remove_device+0x5f/0x6a
> [ 1379.803012]  [<c1220de0>] ? device_del+0xec/0x12f
> [ 1379.803012]  [<c1278d90>] ? usb_disable_device+0x36/0xbc
> [ 1379.803012]  [<c12744f4>] ? usb_disconnect+0x69/0xcb
> [ 1379.803012]  [<c127501e>] ? hub_thread+0x324/0xa82
> [ 1379.803012]  [<c1032de6>] ? autoremove_wake_function+0x0/0x29
> [ 1379.803012]  [<c1274cfa>] ? hub_thread+0x0/0xa82
> [ 1379.803012]  [<c1032b7e>] ? kthread+0x62/0x67
> [ 1379.803012]  [<c1032b1c>] ? kthread+0x0/0x67
> [ 1379.803012]  [<c1002bf6>] ? kernel_thread_helper+0x6/0x10
> [ 1379.803012] Code: 8d 4a 01 83 fa 09 89 0d 94 56 60 c1 7f 18 50 8b
> 43 0c 8b 40 2c 83 c0 58 50 68 38 a9 49 c1 e8 bd 6a 22 00 83 c4 0c 5b
> c3 53 89 c3 <83> 78 0c 00 74 4a 0f ba a8 c0 01 00 00 08 eb 33 89 d8 e8
> d4 15
> [ 1379.803012] EIP: [<c1161f7f>] elv_quiesce_start+0x3/0x55 SS:ESP 0068:f64e5e1c
> [ 1379.803012] CR2: 000000000000000c
> [ 1379.803012] ---[ end trace 230ef585b1215f7d ]---
> [ 1379.803012] note: khubd[14] exited with preempt_count 1
>
> My system seems to work fine, though.
> Regards,
> Fabio
>
