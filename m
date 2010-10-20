Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab0JTJ3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:29:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40139 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0JTJ3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ScOiNrN/yTIv6O5TXiRth4SI+pJLY3LqWhn9D7YC74lvi7iVbFhbS8F2qU4q2U7lSE
         OhKQLpwExOxUhL4oRcJePldJMPoik0r09hQEjxuxnnRbPDB2qmT+lRJ2F6peq8aQ9VnJ
         93sUH6pjOc0kNU/W6r+shSlSBkL+LD+satWX8=
MIME-Version: 1.0
Date: Wed, 20 Oct 2010 12:29:46 +0300
Message-ID: <AANLkTi=JxMBjJ9MF94pRMjy4KbJcpLJh-Xm=hv+kietF@mail.gmail.com>
Subject: Null dereference bug on 2.6.36-rc8 (device-mapper?)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got this while running palimpset (didn't see that on -rc7)

Oct 20 12:25:06 annwn kernel: [43176.117555] BUG: unable to handle
kernel NULL pointer dereference at 0000000c
Oct 20 12:25:06 annwn kernel: [43176.117643] IP: [<c10a5396>]
__trace_add_event_call+0x16/0x410
Oct 20 12:25:06 annwn kernel: [43176.117710] *pde = 00000000
Oct 20 12:25:06 annwn kernel: [43176.117750] Oops: 0000 [#1] SMP
Oct 20 12:25:06 annwn kernel: [43176.117801] last sysfs file:
/sys/devices/virtual/block/dm-6/queue/rotational
Oct 20 12:25:06 annwn kernel: [43176.117860] Modules linked in:
dm_crypt(+) fuse cdc_ether usbnet mii sunrpc ext4 mbcache jbd2 crc16
kvm_intel kvm thinkpad_acpi iwl3945 e1000e iwlcore [last unloaded:
scsi_wait_scan]
Oct 20 12:25:06 annwn kernel: [43176.118007]
Oct 20 12:25:06 annwn kernel: [43176.118007] Pid: 13364, comm:
modprobe Not tainted 2.6.36-rc7 #7 2008Y32/2008Y32
Oct 20 12:25:06 annwn kernel: [43176.118007] EIP: 0060:[<c10a5396>]
EFLAGS: 00010282 CPU: 1
Oct 20 12:25:06 annwn kernel: [43176.118007] EIP is at
__trace_add_event_call+0x16/0x410
Oct 20 12:25:06 annwn kernel: [43176.118007] EAX: 00000000 EBX:
00000000 ECX: f5b1460c EDX: f85eb2a0
Oct 20 12:25:06 annwn kernel: [43176.118007] ESI: 00000048 EDI:
f85eb2a0 EBP: cbb47e84 ESP: cbb47e54
Oct 20 12:25:06 annwn kernel: [43176.118007]  DS: 007b ES: 007b FS:
00d8 GS: 0033 SS: 0068
Oct 20 12:25:06 annwn kernel: [43176.118007] Process modprobe (pid:
13364, ti=cbb46000 task=f50ea580 task.ti=cbb46000)
Oct 20 12:25:06 annwn kernel: [43176.118007] Stack:
Oct 20 12:25:06 annwn kernel: [43176.118007]  00000000 00000246
000000d0 cbb47e84 00000246 c63939c0 cbb47eb0 c10a57f8
Oct 20 12:25:06 annwn kernel: [43176.118007] <0> f5b1460c f85eb2a0
00000048 f5b14670 cbb47eb8 c10a5930 f5b14670 f5b14738
Oct 20 12:25:06 annwn kernel: [43176.118007] <0> f5b146d4 f5b1460c
f5b146d4 f5b14738 daa04080 f5b14600 c1783088 00000000
Oct 20 12:25:06 annwn kernel: [43176.118007] Call Trace:
Oct 20 12:25:06 annwn kernel: [43176.118007]  [<c10a57f8>] ?
trace_module_notify+0x68/0x2b0
Oct 20 12:25:06 annwn kernel: [43176.118007]  [<c10a5930>] ?
trace_module_notify+0x1a0/0x2b0
Oct 20 12:25:06 annwn kernel: [43176.118007]  [<c1578e30>] ?
notifier_call_chain+0x40/0x60
Oct 20 12:25:06 annwn kernel: [43176.118007]  [<c1061056>] ?
__blocking_notifier_call_chain+0x46/0x60
Oct 20 12:25:06 annwn kernel: [43176.118007]  [<c106108a>] ?
blocking_notifier_call_chain+0x1a/0x20
Oct 20 12:25:06 annwn kernel: [43176.118007]  [<c107421a>] ?
sys_init_module+0xda/0x1040
Oct 20 12:25:06 annwn kernel: [43176.118007]  [<c1002e0c>] ?
sysenter_do_call+0x12/0x22
Oct 20 12:25:06 annwn kernel: [43176.118007]  [<c1050000>] ?
signal_wake_up+0x30/0x40
Oct 20 12:25:06 annwn kernel: [43176.118007] Code: c9 83 f8 01 19 c0
83 e0 ed c3 8d 74 26 00 8d bc 27 00 00 00 00 55 89 e5 83 ec 30 89 5d
f4 89 75 f8 89 7d fc 89 c3 89 4d f0 89 d7 <8b> 40 0c be ea ff ff ff 85
c0 74 1d 8b 43 08 8b 50 20 85 d2 74
Oct 20 12:25:06 annwn kernel: [43176.118007] EIP: [<c10a5396>]
__trace_add_event_call+0x16/0x410 SS:ESP 0068:cbb47e54
Oct 20 12:25:06 annwn kernel: [43176.118007] CR2: 000000000000000c
Oct 20 12:25:06 annwn kernel: [43176.134274] ---[ end trace
39b1707504206e4d ]---
Oct 20 12:25:06 annwn kernel: [43176.134436] device-mapper: table:
254:6: crypt: unknown target type
Oct 20 12:25:06 annwn kernel: [43176.134489] device-mapper: ioctl:
error adding target to table

-- 
Felipe Contreras
