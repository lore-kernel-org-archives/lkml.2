Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1BMWMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:12:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56336 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab1BMWMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:12:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=u4bXhcXzMchWwRFtxYvbrSzt2Tb5nSwhppYWxjvnk6s4/ZY3wksmEdIricHh/lofec
         t+CJqA4oAX400027R1veKEYRWQRn5wo10KjovFO/FNhuoI2olqA29BKWiYRKBprxwaUY
         w2wWQ9jJBzQXVwwdobxF4vL4+hVicGgFOYbck=
MIME-Version: 1.0
Date: Sun, 13 Feb 2011 14:12:06 -0800
Message-ID: <AANLkTinW7mWsrgwY2JsG9U-Qk1icKyApbdVJvavw4iGZ@mail.gmail.com>
Subject: kernel BUG at fs/nfsd/nfs4state.c
From: Bret Towe <magnade@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

got this bug shortly after a fresh boot into 2.6.38-rc4 a nfs client
at the time was logging into its nfs home
the server is a 32bit setup running debian squeeze
the client at the time was 64bit debian squeeze (also running 2.6.38-rc4)
and the output below is from the server

let me know if you need more info and I can do tests if required

[  621.685821] ------------[ cut here ]------------
[  621.685895] kernel BUG at fs/nfsd/nfs4state.c:3132!
[  621.685960] invalid opcode: 0000 [#1]
[  621.686060] last sysfs file:
/sys/devices/pci0000:00/0000:00:0f.0/host0/target0:0:1/0:0:1:0/block/sdb/queue/max_sectors_kb
[  621.686145] Modules linked in: tun ipv6 reiserfs ext3 jbd mbcache
rng_core aes_generic i2c_viapro rtc_cmos i2c_core rtc_core rtc_lib
evdev xfs dm_mod sd_mod ata_generic uhci_hcd pata_via ehci_hcd r8169
ide_pci_generic usbcore [last unloaded: scsi_wait_scan]
[  621.687286]
[  621.687344] Pid: 1752, comm: nfsd Not tainted 2.6.38-rc4+ #18 VX800 /VX800
[  621.687416] EIP: 0060:[<c022b523>] EFLAGS: 00010246 CPU: 0
[  621.687491] EIP is at nfs4_preprocess_stateid_op+0x273/0x2d0
[  621.687558] EAX: 00000000 EBX: efd1e000 ECX: c06486a0 EDX: f24b115c
[  621.687627] ESI: 29270000 EDI: f24b115c EBP: ec8e7ed8 ESP: ec8e7eac
[  621.687696]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  621.687764] Process nfsd (pid: 1752, ti=ec8e6000 task=f6bf5d00
task.ti=ec8e6000)
[  621.687839] Stack:
[  621.687893]  f60a4000 ec8e7ef4 c02205d6 c0571d40 4d585017 f0d0f9d0
f24b113c 00000010
[  621.688280]  f24b113c f24b1820 f60a4000 ec8e7ef4 c021debe f24b115c
f24b1000 f24b1800
[  621.688667]  f24b1000 f24b1134 ec8e7f34 c021e7ed f24b1000 f24b1134
c055cae0 ec8e7f34
[  621.689053] Call Trace:
[  621.689123]  [<c02205d6>] ? nfsd4_encode_operation+0x56/0x170
[  621.689195]  [<c021debe>] nfsd4_read+0x3e/0xb0
[  621.689264]  [<c021e7ed>] nfsd4_proc_compound+0x34d/0x410
[  621.689334]  [<c0224a1b>] ? nfs4svc_decode_compoundargs+0x26b/0x370
[  621.689410]  [<c0148355>] ? groups_alloc+0x35/0xd0
[  621.689478]  [<c021de80>] ? nfsd4_read+0x0/0xb0
[  621.689549]  [<c02106db>] nfsd_dispatch+0xcb/0x200
[  621.689621]  [<c03e44a2>] ? svc_authenticate+0x82/0xa0
[  621.689690]  [<c03e1bd6>] svc_process+0x416/0x6d0
[  621.689759]  [<c0210d4c>] nfsd+0xac/0x140
[  621.689824]  [<c0210ca0>] ? nfsd+0x0/0x140
[  621.689890]  [<c0210ca0>] ? nfsd+0x0/0x140
[  621.689958]  [<c0141a64>] kthread+0x74/0x80
[  621.690024]  [<c01419f0>] ? kthread+0x0/0x80
[  621.690092]  [<c01031b6>] kernel_thread_helper+0x6/0x10
[  621.690155] Code: 85 c0 74 6b 8b 4d 08 89 01 e9 6a fe ff ff 66 90
8b 55 ec 8b 02 85 c0 74 b2 eb 9c 8b 42 24 8b 55 08 85 c0 89 02 0f 85
65 ff ff ff <0f> 0b eb fe 8b 57 24 8b 42 20 85 c0 74 3b 8b 55 08 89 02
e9 35
[  621.692774] EIP: [<c022b523>]
nfs4_preprocess_stateid_op+0x273/0x2d0 SS:ESP 0068:ec8e7eac
[  621.693002] ---[ end trace 22d2403ffa6ebd8b ]---
