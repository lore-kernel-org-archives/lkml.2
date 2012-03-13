Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715Ab2CMVof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:44:35 -0400
Received: from host171.canaca.com ([67.55.55.225]:41929 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2CMVod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:44:33 -0400
Message-ID: <db895036fd86eb68ae06f0fcc4913134.squirrel@mungewell.org>
In-Reply-To: <alpine.LNX.2.00.1203132224410.18356@pobox.suse.cz>
References: <ced1eb513cb4134634e89feab0db49ca.squirrel@mungewell.org>
    <alpine.LNX.2.00.1203132224410.18356@pobox.suse.cz>
Date: Tue, 13 Mar 2012 17:44:29 -0400
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: simon@mungewell.org, "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael Bauer" <michael@m-bauer.org>,
        "Michal Maly" <madcatxster@gmail.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Could you please post the full oops?

--
Mar 13 14:05:55 ubuntu kernel: [ 3286.170380] logitech
0003:046D:C294.0002: input,hidraw0: USB HID v1.11 Joystick [PS3/USB
Cordless Wheel] on usb-0000:02:00.0-1/input0
Mar 13 14:05:55 ubuntu kernel: [ 3286.171462] BUG: unable to handle kernel
NULL pointer dereference at 00000091
Mar 13 14:05:55 ubuntu kernel: [ 3286.171543] IP: [<e09f3998>]
lg4ff_led_get_brightness+0x28/0x90 [hid_logitech]
Mar 13 14:05:55 ubuntu kernel: [ 3286.171931] *pde = 00000000
Mar 13 14:05:55 ubuntu kernel: [ 3286.171991] Oops: 0000 [#1] SMP
Mar 13 14:05:55 ubuntu kernel: [ 3286.172253] Modules linked in:
hid_logitech joydev ff_memless usbhid hid binfmt_misc snd_ens1371 gameport
snd_ac97_codec ac97_bus snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore
i2c_piix4 ppdev snd_page_alloc shpchp psmouse serio_raw lp vmw_balloon
parport_pc parport floppy pcnet32 mptspi mptscsih mptbase
scsi_transport_spi [last unloaded: hid_logitech]
Mar 13 14:05:55 ubuntu kernel: [ 3286.172434]
Mar 13 14:05:55 ubuntu kernel: [ 3286.172517] Pid: 16, comm: khubd Not
tainted 3.3.0-rc6-stock+ #10 VMware, Inc. VMware Virtual Platform/440BX
Desktop Reference Platform
Mar 13 14:05:55 ubuntu kernel: [ 3286.173257] EIP: 0060:[<e09f3998>]
EFLAGS: 00010202 CPU: 0
Mar 13 14:05:55 ubuntu kernel: [ 3286.173325] EIP is at
lg4ff_led_get_brightness+0x28/0x90 [hid_logitech]
Mar 13 14:05:55 ubuntu kernel: [ 3286.173393] EAX: 00000089 EBX: dd3d2540
ECX: 00000000 EDX: ddc9a000
Mar 13 14:05:55 ubuntu kernel: [ 3286.173406] ESI: dd3a51b8 EDI: dd3a51b8
EBP: de59fa94 ESP: de59fa84
Mar 13 14:05:55 ubuntu kernel: [ 3286.173419]  DS: 007b ES: 007b FS: 00d8
GS: 00e0 SS: 0068
Mar 13 14:05:55 ubuntu kernel: [ 3286.173452] Process khubd (pid: 16,
ti=de59e000 task=de4cbf70 task.ti=de59e000)
Mar 13 14:05:55 ubuntu kernel: [ 3286.173471] Stack:
Mar 13 14:05:55 ubuntu kernel: [ 3286.173517]  c13498ed de59fa94 dd3d2540
dda080a0 de59fab8 c1439119 de57c5c0 dd3a51b8
Mar 13 14:05:55 ubuntu kernel: [ 3286.173681]  00000000 dd3d2540 c16f79e0
e09f5e1d 00000000 de59fafc e09f4311 00002200
Mar 13 14:05:55 ubuntu kernel: [ 3286.173689]  00000000 dd3d23c0 00000002
ddc9ac64 00000000 dd3a51b8 00010800 dde10022
Mar 13 14:05:55 ubuntu kernel: [ 3286.173738] Call Trace:
Mar 13 14:05:55 ubuntu kernel: [ 3286.174090]  [<c13498ed>] ?
device_create+0x2d/0x30
Mar 13 14:05:55 ubuntu kernel: [ 3286.174212]  [<c1439119>]
led_classdev_register+0x99/0xf0
Mar 13 14:05:55 ubuntu kernel: [ 3286.174269]  [<e09f4311>]
lg4ff_init+0x2a1/0x570 [hid_logitech]
Mar 13 14:05:55 ubuntu kernel: [ 3286.174276]  [<e09f2427>]
lg_probe+0x147/0x2c0 [hid_logitech]
Mar 13 14:05:55 ubuntu kernel: [ 3286.174360]  [<c1027938>] ?
default_spin_lock_flags+0x8/0x10
Mar 13 14:05:55 ubuntu kernel: [ 3286.174638]  [<c153b6af>] ?
_raw_spin_lock_irqsave+0x2f/0x50
Mar 13 14:05:55 ubuntu kernel: [ 3286.174672]  [<e0a025a3>] ?
hid_match_device+0x83/0x90 [hid]
Mar 13 14:05:55 ubuntu kernel: [ 3286.174680]  [<e0a02bf0>]
hid_device_probe+0x80/0x100 [hid]
Mar 13 14:05:55 ubuntu kernel: [ 3286.174685]  [<c134b452>] ?
driver_sysfs_add+0x72/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174692]  [<c134b6cf>]
driver_probe_device+0x7f/0x190
Mar 13 14:05:55 ubuntu kernel: [ 3286.174698]  [<c134b8b9>]
__device_attach+0x49/0x60
Mar 13 14:05:55 ubuntu kernel: [ 3286.174703]  [<c134b870>] ?
__driver_attach+0x90/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174707]  [<c134a0ff>]
bus_for_each_drv+0x4f/0x70
Mar 13 14:05:55 ubuntu kernel: [ 3286.174712]  [<c134b5aa>]
device_attach+0x8a/0xa0
Mar 13 14:05:55 ubuntu kernel: [ 3286.174716]  [<c134b870>] ?
__driver_attach+0x90/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174721]  [<c134ae3f>]
bus_probe_device+0x6f/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174725]  [<c1349710>]
device_add+0x560/0x610
Mar 13 14:05:55 ubuntu kernel: [ 3286.174732]  [<e0a026b2>]
hid_add_device+0x92/0x1f0 [hid]
Mar 13 14:05:55 ubuntu kernel: [ 3286.174742]  [<e09a5c26>]
usbhid_probe+0x2e6/0x430 [usbhid]
Mar 13 14:05:55 ubuntu kernel: [ 3286.174753]  [<c13c7c06>]
usb_probe_interface+0xd6/0x1b0
Mar 13 14:05:55 ubuntu kernel: [ 3286.174766]  [<c11898c7>] ?
sysfs_create_link+0x17/0x20
Mar 13 14:05:55 ubuntu kernel: [ 3286.174772]  [<c134b6cf>]
driver_probe_device+0x7f/0x190
Mar 13 14:05:55 ubuntu kernel: [ 3286.174776]  [<c13c75fb>] ?
usb_device_match+0x6b/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174781]  [<c134b8b9>]
__device_attach+0x49/0x60
Mar 13 14:05:55 ubuntu kernel: [ 3286.174813]  [<c134b870>] ?
__driver_attach+0x90/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174821]  [<c134a0ff>]
bus_for_each_drv+0x4f/0x70
Mar 13 14:05:55 ubuntu kernel: [ 3286.174825]  [<c134b5aa>]
device_attach+0x8a/0xa0
Mar 13 14:05:55 ubuntu kernel: [ 3286.174830]  [<c134b870>] ?
__driver_attach+0x90/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174834]  [<c134ae3f>]
bus_probe_device+0x6f/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174839]  [<c1349710>]
device_add+0x560/0x610
Mar 13 14:05:55 ubuntu kernel: [ 3286.174845]  [<c13c6385>] ?
usb_set_configuration+0x4c5/0x650
Mar 13 14:05:55 ubuntu kernel: [ 3286.174850]  [<c13c63ee>]
usb_set_configuration+0x52e/0x650
Mar 13 14:05:55 ubuntu kernel: [ 3286.174859]  [<c13ce5eb>]
generic_probe+0x3b/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174864]  [<c11898c7>] ?
sysfs_create_link+0x17/0x20
Mar 13 14:05:55 ubuntu kernel: [ 3286.174868]  [<c13c7d06>]
usb_probe_device+0x26/0x50
Mar 13 14:05:55 ubuntu kernel: [ 3286.174873]  [<c134b6cf>]
driver_probe_device+0x7f/0x190
Mar 13 14:05:55 ubuntu kernel: [ 3286.174908]  [<c128c165>] ?
kobject_uevent_env+0x105/0x420
Mar 13 14:05:55 ubuntu kernel: [ 3286.174917]  [<c153b50d>] ?
_raw_spin_lock+0xd/0x10
Mar 13 14:05:55 ubuntu kernel: [ 3286.174922]  [<c134b8b9>]
__device_attach+0x49/0x60
Mar 13 14:05:55 ubuntu kernel: [ 3286.174925]  [<c134b870>] ?
__driver_attach+0x90/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174929]  [<c134a0ff>]
bus_for_each_drv+0x4f/0x70
Mar 13 14:05:55 ubuntu kernel: [ 3286.174934]  [<c134b5aa>]
device_attach+0x8a/0xa0
Mar 13 14:05:55 ubuntu kernel: [ 3286.174938]  [<c134b870>] ?
__driver_attach+0x90/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174942]  [<c134ae3f>]
bus_probe_device+0x6f/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.174947]  [<c1349710>]
device_add+0x560/0x610
Mar 13 14:05:55 ubuntu kernel: [ 3286.174956]  [<c13bcf00>] ?
usb_enumerate_device+0x20/0x100
Mar 13 14:05:55 ubuntu kernel: [ 3286.174965]  [<c13547c9>] ?
pm_runtime_forbid+0x49/0x60
Mar 13 14:05:55 ubuntu kernel: [ 3286.174969]  [<c13bf720>]
usb_new_device+0xe0/0x120
Mar 13 14:05:55 ubuntu kernel: [ 3286.174974]  [<c13c0b64>] ?
hub_thread+0xc44/0xfd0
Mar 13 14:05:55 ubuntu kernel: [ 3286.174978]  [<c13c094f>]
hub_thread+0xa2f/0xfd0
Mar 13 14:05:55 ubuntu kernel: [ 3286.174988]  [<c1052220>] ?
wake_up_bit+0x30/0x30
Mar 13 14:05:55 ubuntu kernel: [ 3286.174993]  [<c13bff20>] ?
usb_remote_wakeup+0x50/0x50
Mar 13 14:05:55 ubuntu kernel: [ 3286.174997]  [<c1051c3c>] kthread+0x7c/0x90
Mar 13 14:05:55 ubuntu kernel: [ 3286.175001]  [<c1051bc0>] ?
flush_kthread_worker+0xb0/0xb0
Mar 13 14:05:55 ubuntu kernel: [ 3286.175028]  [<c15428be>]
kernel_thread_helper+0x6/0x10
Mar 13 14:05:55 ubuntu kernel: [ 3286.175075] Code: 00 00 00 55 89 e5 56
53 83 ec 08 3e 8d 74 26 00 89 c3 8b 40 1c 8b 30 89 f0 e8 a5 78 95 e0 85 c0
74 39 8b 40 04 31 c9 85 c0 74 48 <39> 5c 88 08 74 12 83 c1 01 83 f9 05 75
f2 31 c0 83 c4 08 5b 5e
Mar 13 14:05:55 ubuntu kernel: [ 3286.175218] EIP: [<e09f3998>]
lg4ff_led_get_brightness+0x28/0x90 [hid_logitech] SS:ESP 0068:de59fa84
Mar 13 14:05:55 ubuntu kernel: [ 3286.175263] CR2: 0000000000000091
Mar 13 14:05:55 ubuntu kernel: [ 3286.175702] ---[ end trace
bae956db68dd6567 ]---
Mar 13 14:06:00 ubuntu dhclient: DHCPREQUEST of 192.168.227.143 on eth0 to
192.168.227.254 port 67
Mar 13 14:06:00 ubuntu dhclient: DHCPACK of 192.168.227.143 from
192.168.227.254
Mar 13 14:06:00 ubuntu dhclient: bound to 192.168.227.143 -- renewal in
736 seconds.
--

