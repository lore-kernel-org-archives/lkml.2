Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab2DTSai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:30:38 -0400
Received: from smtp10.mail.sp.isp-net.nl ([217.149.192.65]:44936 "EHLO
	smtp10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab2DTSag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:30:36 -0400
X-Greylist: delayed 950 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2012 14:30:36 EDT
Message-ID: <4F91A791.5000205@xmsnet.nl>
Date: Fri, 20 Apr 2012 20:14:41 +0200
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [3.4-rc's] some kernel unable to handle kernel paging requests and
 NULL pointer dereference bugs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Language-Detected: fr
X-Language-Detected: da
X-Language-Detected: ca
X-Language-Detected: en
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
X-Spam-Score: 3.1
X-SpamscanResult: heavy
X-Spam-Report: -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	 1.0 SARE_BAYES_7x8 BODY: Bayes poison 7x8
	 0.8 SARE_BAYES_6x8 BODY: Bayes poison 6x8
	 0.8 SARE_BAYES_5x8 BODY: Bayes poison 5x8
	 0.5 INN_SPAMWORDS Message contains possible spamwords
	-0.0 NO_RECEIVED Informational: message has no Received headers
	 0.0 INN_NONNLRELAY Non NL relay
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the last 20 day's I have seen some unable to handle kernel NULL 
pointer dereference and unable to handle kernel paging request BUGS:

bash-4.1$ grep BUG /var/log/syslog
Apr  1 08:22:46 psion kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000002c
Apr  9 22:35:38 psion kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000017c
Apr 13 17:42:51 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 16 18:47:17 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 16 18:49:47 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 16 19:56:49 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 16 20:02:03 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 20 19:22:35 psion kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000002c

The bugs happen just after my laptop has booted when KDE is busy with 
its splash screen and drawing the initial desktop. Because of a bisect I 
have been booting a lot, 92 times in the last 20 days. So the bugs are 
to scarce to try a bisect. The laptop is running on nfs root.

-- 
Hans



from my syslog:


Apr  1 08:22:46 psion kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000002c
Apr  1 08:22:46 psion kernel: IP: [<c11111fc>] 
nfs_clear_request_commit+0x6/0x3f
Apr  1 08:22:46 psion kernel: *pde = 00000000
Apr  1 08:22:46 psion kernel: Oops: 0000 [#1] PREEMPT
Apr  1 08:22:46 psion kernel: Modules linked in:
Apr  1 08:22:46 psion kernel:
Apr  1 08:22:46 psion kernel: Pid: 2156, comm: akonadi_maildis Not 
tainted 3.3.0+ #371 Dell Inc. Latitude D430                   /0XW455
Apr  1 08:22:46 psion kernel: EIP: 0060:[<c11111fc>] EFLAGS: 00010246 CPU: 0
Apr  1 08:22:46 psion kernel: EIP is at nfs_clear_request_commit+0x6/0x3f
Apr  1 08:22:46 psion kernel: EAX: 00000000 EBX: 00000000 ECX: 0001c630 
EDX: 8000002d
Apr  1 08:22:46 psion kernel: ESI: 00000000 EDI: 00000000 EBP: f3c73e38 
ESP: f3c73e34
Apr  1 08:22:46 psion kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr  1 08:22:46 psion kernel: CR0: 80050033 CR2: 0000002c CR3: 33c75000 
CR4: 000007d0
Apr  1 08:22:46 psion kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 
DR3: 00000000
Apr  1 08:22:46 psion kernel: DR6: ffff0ff0 DR7: 00000400
Apr  1 08:22:46 psion kernel: Process akonadi_maildis (pid: 2156, 
ti=f3c72000 task=f547fb80 task.ti=f3c72000)
Apr  1 08:22:46 psion kernel: Stack:
Apr  1 08:22:46 psion kernel:  f76a6aa0 f3c73e74 c1112808 00000000 
00000000 00000000 00000000 f3d55f40
Apr  1 08:22:46 psion kernel:  00001000 c144ba98 f3c73e78 f410a114 
f3d55f40 f76a6aa0 f5bbcd80 00001000
Apr  1 08:22:46 psion kernel:  f3c73e98 c11075fa 00001000 f3c73ee0 
00a0a030 00000000 f76a6aa0 b456e008
Apr  1 08:22:46 psion kernel: Call Trace:
Apr  1 08:22:46 psion kernel:  [<c1112808>] nfs_updatepage+0x170/0x40d
Apr  1 08:22:46 psion kernel:  [<c11075fa>] nfs_vm_page_mkwrite+0xbb/0xfb
Apr  1 08:22:46 psion kernel:  [<c10905cb>] do_wp_page.clone.78+0x186/0x51e
Apr  1 08:22:46 psion kernel:  [<c1091cce>] handle_pte_fault+0x4e7/0x524
Apr  1 08:22:46 psion kernel:  [<c1091d8d>] handle_mm_fault+0x82/0x91
Apr  1 08:22:46 psion kernel:  [<c103e9d9>] ? vmalloc_sync_all+0xe2/0xe2
Apr  1 08:22:46 psion kernel:  [<c103ecef>] do_page_fault+0x316/0x333
Apr  1 08:22:46 psion kernel:  [<c103affa>] ? ack_apic_level+0x3a/0x93
Apr  1 08:22:46 psion kernel:  [<c10480d3>] ? irq_exit+0x7f/0x8b
Apr  1 08:22:46 psion kernel:  [<c103e9d9>] ? vmalloc_sync_all+0xe2/0xe2
Apr  1 08:22:46 psion kernel:  [<c13d9920>] error_code+0x58/0x60
Apr  1 08:22:46 psion kernel:  [<c13d0000>] ? tg3_nvram_init+0x2ba/0xb9a
Apr  1 08:22:46 psion kernel:  [<c103e9d9>] ? vmalloc_sync_all+0xe2/0xe2
Apr  1 08:22:46 psion kernel: Code: e0 25 00 e0 ff ff ff 40 14 83 42 20 
ff 83 52 24 ff ff 48 14 8b 40 08 a8 08 74 05 e8 eb 78 2c 00 53 9d 5b c9 
c3 55 89 e5 53 89 c3 <8b> 40 2c a8 04 74 2f 89 e0 25 00 e0 ff ff ff 40 
14 89 d8 e8 a0
Apr  1 08:22:46 psion kernel: EIP: [<c11111fc>] 
nfs_clear_request_commit+0x6/0x3f SS:ESP 0068:f3c73e34
Apr  1 08:22:46 psion kernel: CR2: 000000000000002c
Apr  1 08:22:46 psion kernel: ---[ end trace 22efbaf961492ca8 ]---

---------------------

(This could be due to a usb-disk plugin)

Apr  9 22:35:38 psion kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000017c
Apr  9 22:35:38 psion kernel: IP: [<c1230fdb>] scsi_send_eh_cmnd+0x22/0x1e9
Apr  9 22:35:38 psion kernel: *pde = 00000000
Apr  9 22:35:38 psion kernel: Oops: 0000 [#1] PREEMPT
Apr  9 22:35:38 psion kernel: Modules linked in:
Apr  9 22:35:38 psion kernel:
Apr  9 22:35:38 psion kernel: Pid: 2394, comm: scsi_eh_3 Not tainted 
3.4.0-rc2 #390 Dell Inc. Latitude D430                   /0XW455
Apr  9 22:35:38 psion kernel: EIP: 0060:[<c1230fdb>] EFLAGS: 00010286 CPU: 0
Apr  9 22:35:38 psion kernel: EIP is at scsi_send_eh_cmnd+0x22/0x1e9
Apr  9 22:35:38 psion kernel: EAX: 00000000 EBX: f3dcd780 ECX: 00000003 
EDX: f5a73ed0
Apr  9 22:35:38 psion kernel: ESI: f5a73f98 EDI: f5a73f20 EBP: f5a73f38 
ESP: f5a73ec0
Apr  9 22:35:38 psion kernel:  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Apr  9 22:35:38 psion kernel: CR0: 8005003b CR2: 0000017c CR3: 33e9d000 
CR4: 000007d0
Apr  9 22:35:38 psion kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 
DR3: 00000000
Apr  9 22:35:38 psion kernel: DR6: ffff0ff0 DR7: 00000400
Apr  9 22:35:38 psion kernel: Process scsi_eh_3 (pid: 2394, ti=f5a72000 
task=f367a6e0 task.ti=f5a72000)
Apr  9 22:35:38 psion kernel: Stack:
Apr  9 22:35:38 psion kernel:  00000000 00000001 00000006 c160a990 
c155c614 c155c5d4 f5a73ef8 c1552538
Apr  9 22:35:38 psion kernel:  00000000 7fffffff f367a6e0 00000002 
f5a73ef8 c13da0f8 f5a73f2c c13d8de2
Apr  9 22:35:38 psion kernel:  000005c1 f367adf4 f5a73f20 f5a73f70 
f367a6e0 c1552340 0000014f f367a6e0
Apr  9 22:35:38 psion kernel: Call Trace:
Apr  9 22:35:38 psion kernel:  [<c13da0f8>] ? schedule+0x50/0x52
Apr  9 22:35:38 psion kernel:  [<c13d8de2>] ? schedule_timeout+0x17/0x13d
Apr  9 22:35:38 psion kernel:  [<c1231219>] scsi_eh_tur+0x1c/0x68
Apr  9 22:35:38 psion kernel:  [<c12312cb>] scsi_eh_test_devices+0x66/0xe5
Apr  9 22:35:38 psion kernel:  [<c1231dca>] scsi_error_handler+0x188/0x326
Apr  9 22:35:38 psion kernel:  [<c1231c42>] ? scsi_eh_get_sense+0x8f/0x8f
Apr  9 22:35:38 psion kernel:  [<c1056141>] kthread+0x66/0x6b
Apr  9 22:35:38 psion kernel:  [<c10560db>] ? 
kthread_freezable_should_stop+0x43/0x43
Apr  9 22:35:38 psion kernel:  [<c13db376>] kernel_thread_helper+0x6/0xd
Apr  9 22:35:38 psion kernel: Code: f3 ab 5b 5e 5b 5e 5f c9 c3 55 89 e5 
57 8d 7d e8 56 53 89 c3 83 ec 6c 89 55 94 89 4d 90 8b 40 54 8d 55 98 8b 
40 68 b9 03 00 00 00 <8b> 80 7c 01 00 00 8b 00 89 45 8c 8b 03 8b 30 31 
c0 f3 ab 8d 45
Apr  9 22:35:38 psion kernel: EIP: [<c1230fdb>] 
scsi_send_eh_cmnd+0x22/0x1e9 SS:ESP 0068:f5a73ec0
Apr  9 22:35:38 psion kernel: CR2: 000000000000017c
Apr  9 22:35:38 psion kernel: ---[ end trace bf97f4b66125e6bf ]---

-----------

Apr 13 17:42:51 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 13 17:42:51 psion kernel: IP: [<2e740031>] 0x2e740030
Apr 13 17:42:51 psion kernel: *pde = 00000000
Apr 13 17:42:51 psion kernel: Oops: 0000 [#1] PREEMPT
Apr 13 17:42:51 psion kernel: Modules linked in:
Apr 13 17:42:51 psion kernel:
Apr 13 17:42:51 psion kernel: Pid: 2204, comm: polkit-kde-auth Not 
tainted 3.4.0-rc2+ #396 Dell Inc. Latitude D430                   /0XW455
Apr 13 17:42:51 psion kernel: EIP: 0060:[<2e740031>] EFLAGS: 00010246 CPU: 0
Apr 13 17:42:51 psion kernel: EIP is at 0x2e740031
Apr 13 17:42:51 psion kernel: EAX: 00000000 EBX: 6369746e ECX: 00000000 
EDX: f3a72dc0
Apr 13 17:42:51 psion kernel: ESI: 6f697461 EDI: 67612d6e EBP: 2d746e65 
ESP: f5323fb4
Apr 13 17:42:51 psion kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr 13 17:42:51 psion kernel: CR0: 8005003b CR2: 2e740031 CR3: 33af4000 
CR4: 000007d0
Apr 13 17:42:51 psion kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 
DR3: 00000000
Apr 13 17:42:51 psion kernel: DR6: ffff0ff0 DR7: 00000400
Apr 13 17:42:51 psion kernel: Process polkit-kde-auth (pid: 2204, 
ti=f5322000 task=f3a72dc0 task.ti=f5322000)
Apr 13 17:42:51 psion kernel: Stack:
Apr 13 17:42:51 psion kernel:  0000000f 08cb5db8 00000000 00000000 
00000000 bfe72d08 000000ac 0000007b
Apr 13 17:42:51 psion kernel:  0000007b 00000000 00000000 000000ac 
b60b2d8e 00000073 00000246 bfe72950
Apr 13 17:42:51 psion kernel:  0000007b 00000000 00000000
Apr 13 17:42:51 psion kernel: Call Trace:
Apr 13 17:42:51 psion kernel: Code:  Bad EIP value.
Apr 13 17:42:51 psion kernel: EIP: [<2e740031>] 0x2e740031 SS:ESP 
0068:f5323fb4
Apr 13 17:42:51 psion kernel: CR2: 000000002e740031
Apr 13 17:42:51 psion kernel: ---[ end trace da12336a7e4b27d5 ]---

--------------------------------

Apr 16 18:47:17 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 16 18:47:17 psion kernel: IP: [<2e740031>] 0x2e740030
Apr 16 18:47:17 psion kernel: *pde = 00000000
Apr 16 18:47:17 psion kernel: Oops: 0000 [#1] PREEMPT
Apr 16 18:47:17 psion kernel: Modules linked in:
Apr 16 18:47:17 psion kernel:
Apr 16 18:47:17 psion kernel: Pid: 2209, comm: polkit-kde-auth Not 
tainted 3.4.0-rc2+ #398 Dell Inc. Latitude D430                   /0XW455
Apr 16 18:47:17 psion kernel: EIP: 0060:[<2e740031>] EFLAGS: 00010246 CPU: 0
Apr 16 18:47:17 psion kernel: EIP is at 0x2e740031
Apr 16 18:47:17 psion kernel: EAX: 00000000 EBX: 6369746e ECX: 00000000 
EDX: f53a74a0
Apr 16 18:47:17 psion kernel: ESI: 6f697461 EDI: 67612d6e EBP: 2d746e65 
ESP: f53e9fb4
Apr 16 18:47:17 psion kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr 16 18:47:17 psion kernel: CR0: 8005003b CR2: 2e740031 CR3: 33a48000 
CR4: 000007d0
Apr 16 18:47:17 psion kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 
DR3: 00000000
Apr 16 18:47:17 psion kernel: DR6: ffff0ff0 DR7: 00000400
Apr 16 18:47:17 psion kernel: Process polkit-kde-auth (pid: 2209, 
ti=f53e8000 task=f53a74a0 task.ti=f53e8000)
Apr 16 18:47:17 psion kernel: Stack:
Apr 16 18:47:17 psion kernel:  0000000f 09f80d78 00000000 00000000 
00000000 bff54c08 000000ac 0000007b
Apr 16 18:47:17 psion kernel:  0000007b 00000000 00000000 000000ac 
b60bed8e 00000073 00000246 bff54850
Apr 16 18:47:17 psion kernel:  0000007b 460f0f0f e5a9a9a9
Apr 16 18:47:17 psion kernel: Call Trace:
Apr 16 18:47:17 psion kernel: Code:  Bad EIP value.
Apr 16 18:47:17 psion kernel: EIP: [<2e740031>] 0x2e740031 SS:ESP 
0068:f53e9fb4
Apr 16 18:47:17 psion kernel: CR2: 000000002e740031
Apr 16 18:47:17 psion kernel: ---[ end trace 83029d8601b08745 ]---


---------------------


Apr 16 18:49:47 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 16 18:49:47 psion kernel: IP: [<2e740031>] 0x2e740030
Apr 16 18:49:47 psion kernel: *pde = 00000000
Apr 16 18:49:47 psion kernel: Oops: 0000 [#2] PREEMPT
Apr 16 18:49:47 psion kernel: Modules linked in:
Apr 16 18:49:47 psion kernel:
Apr 16 18:49:47 psion kernel: Pid: 2477, comm: polkit-kde-auth Tainted: 
G      D      3.4.0-rc2+ #398 Dell Inc. Latitude D430 
/0XW455
Apr 16 18:49:47 psion kernel: EIP: 0060:[<2e740031>] EFLAGS: 00010246 CPU: 0
Apr 16 18:49:47 psion kernel: EIP is at 0x2e740031
Apr 16 18:49:47 psion kernel: EAX: 00000000 EBX: 6369746e ECX: 00000000 
EDX: f53ea370
Apr 16 18:49:47 psion kernel: ESI: 6f697461 EDI: 67612d6e EBP: 2d746e65 
ESP: f3b77fb4
Apr 16 18:49:47 psion kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr 16 18:49:47 psion kernel: CR0: 8005003b CR2: 2e740031 CR3: 33867000 
CR4: 000007d0
Apr 16 18:49:47 psion kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 
DR3: 00000000
Apr 16 18:49:47 psion kernel: DR6: ffff0ff0 DR7: 00000400
Apr 16 18:49:47 psion kernel: Process polkit-kde-auth (pid: 2477, 
ti=f3b76000 task=f53ea370 task.ti=f3b76000)
Apr 16 18:49:47 psion kernel: Stack:
Apr 16 18:49:47 psion kernel:  0000000f 092f7768 00000000 00000000 
00000000 bffb80f8 000000ac 0000007b
Apr 16 18:49:47 psion kernel:  0000007b 00000000 00000000 000000ac 
b60e5d8e 00000073 00000246 bffb7d40
Apr 16 18:49:47 psion kernel:  0000007b 00000000 00000000
Apr 16 18:49:47 psion kernel: Call Trace:
Apr 16 18:49:47 psion kernel: Code:  Bad EIP value.
Apr 16 18:49:47 psion kernel: EIP: [<2e740031>] 0x2e740031 SS:ESP 
0068:f3b77fb4
Apr 16 18:49:47 psion kernel: CR2: 000000002e740031
Apr 16 18:49:47 psion kernel: ---[ end trace 83029d8601b08746 ]---


-----------------

Apr 16 19:56:49 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 16 19:56:49 psion kernel: IP: [<2e740031>] 0x2e740030
Apr 16 19:56:49 psion kernel: *pde = 00000000
Apr 16 19:56:49 psion kernel: Oops: 0000 [#1] PREEMPT
Apr 16 19:56:49 psion kernel: Modules linked in:
Apr 16 19:56:49 psion kernel:
Apr 16 19:56:49 psion kernel: Pid: 2210, comm: polkit-kde-auth Not 
tainted 3.4.0-rc2+ #398 Dell Inc. Latitude D430                   /0XW455
Apr 16 19:56:49 psion kernel: EIP: 0060:[<2e740031>] EFLAGS: 00010246 CPU: 0
Apr 16 19:56:49 psion kernel: EIP is at 0x2e740031
Apr 16 19:56:49 psion kernel: EAX: 00000000 EBX: 6369746e ECX: 00000000 
EDX: f3e2f810
Apr 16 19:56:49 psion kernel: ESI: 6f697461 EDI: 67612d6e EBP: 2d746e65 
ESP: f3f17fb4
Apr 16 19:56:49 psion kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr 16 19:56:49 psion kernel: CR0: 8005003b CR2: 2e740031 CR3: 33e21000 
CR4: 000007d0
Apr 16 19:56:49 psion kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 
DR3: 00000000
Apr 16 19:56:49 psion kernel: DR6: ffff0ff0 DR7: 00000400
Apr 16 19:56:49 psion kernel: Process polkit-kde-auth (pid: 2210, 
ti=f3f16000 task=f3e2f810 task.ti=f3f16000)
Apr 16 19:56:49 psion kernel: Stack:
Apr 16 19:56:49 psion kernel:  0000000f 085f8d78 00000000 00000000 
00000000 bf842968 000000ac 0000007b
Apr 16 19:56:49 psion kernel:  0000007b 00000000 00000000 000000ac 
b6000d8e 00000073 00000246 bf8425b0
Apr 16 19:56:49 psion kernel:  0000007b 00000000 00000000
Apr 16 19:56:49 psion kernel: Call Trace:
Apr 16 19:56:49 psion kernel: Code:  Bad EIP value.
Apr 16 19:56:49 psion kernel: EIP: [<2e740031>] 0x2e740031 SS:ESP 
0068:f3f17fb4
Apr 16 19:56:49 psion kernel: CR2: 000000002e740031
Apr 16 19:56:49 psion kernel: ---[ end trace 272e3d12d6c86123 ]---


-----------------

Apr 16 20:02:03 psion kernel: BUG: unable to handle kernel paging 
request at 2e740031
Apr 16 20:02:03 psion kernel: IP: [<2e740031>] 0x2e740030
Apr 16 20:02:03 psion kernel: *pde = 00000000
Apr 16 20:02:03 psion kernel: Oops: 0000 [#1] PREEMPT
Apr 16 20:02:03 psion kernel: Modules linked in:
Apr 16 20:02:03 psion kernel:
Apr 16 20:02:03 psion kernel: Pid: 2206, comm: polkit-kde-auth Not 
tainted 3.4.0-rc2+ #398 Dell Inc. Latitude D430                   /0XW455
Apr 16 20:02:03 psion kernel: EIP: 0060:[<2e740031>] EFLAGS: 00010246 CPU: 0
Apr 16 20:02:03 psion kernel: EIP is at 0x2e740031
Apr 16 20:02:03 psion kernel: EAX: 00000000 EBX: 6369746e ECX: 00000000 
EDX: f3e1d810
Apr 16 20:02:03 psion kernel: ESI: 6f697461 EDI: 67612d6e EBP: 2d746e65 
ESP: f3f1bfb4
Apr 16 20:02:03 psion kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr 16 20:02:03 psion kernel: CR0: 8005003b CR2: 2e740031 CR3: 33db6000 
CR4: 000007d0
Apr 16 20:02:03 psion kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 
DR3: 00000000
Apr 16 20:02:03 psion kernel: DR6: ffff0ff0 DR7: 00000400
Apr 16 20:02:03 psion kernel: Process polkit-kde-auth (pid: 2206, 
ti=f3f1a000 task=f3e1d810 task.ti=f3f1a000)
Apr 16 20:02:03 psion kernel: Stack:
Apr 16 20:02:03 psion kernel:  0000000f 09abad78 00000000 00000000 
00000000 bf8cdd28 000000ac 0000007b
Apr 16 20:02:03 psion kernel:  0000007b 00000000 00000000 000000ac 
b5ff6d8e 00000073 00000246 bf8cd970
Apr 16 20:02:03 psion kernel:  0000007b 00000000 00000000
Apr 16 20:02:03 psion kernel: Call Trace:
Apr 16 20:02:03 psion kernel: Code:  Bad EIP value.
Apr 16 20:02:03 psion kernel: EIP: [<2e740031>] 0x2e740031 SS:ESP 
0068:f3f1bfb4
Apr 16 20:02:03 psion kernel: CR2: 000000002e740031
Apr 16 20:02:03 psion kernel: ---[ end trace 881ad65106479395 ]---



----------------------


( todays git at  c6f5c93 )


Apr 20 19:22:35 psion kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000002c
Apr 20 19:22:35 psion kernel: IP: [<c111151c>] 
nfs_clear_request_commit+0x6/0x3f
Apr 20 19:22:35 psion kernel: *pde = 00000000
Apr 20 19:22:35 psion kernel: Oops: 0000 [#1] PREEMPT
Apr 20 19:22:35 psion kernel: Modules linked in:
Apr 20 19:22:35 psion kernel:
Apr 20 19:22:35 psion kernel: Pid: 2113, comm: plasma-desktop Not 
tainted 3.4.0-rc3+ #403 Dell Inc. Latitude D430                   /0XW455
Apr 20 19:22:35 psion kernel: EIP: 0060:[<c111151c>] EFLAGS: 00010246 CPU: 0
Apr 20 19:22:35 psion kernel: EIP is at nfs_clear_request_commit+0x6/0x3f
Apr 20 19:22:35 psion kernel: EAX: 00000000 EBX: 00000000 ECX: 0001e316 
EDX: 80000029
Apr 20 19:22:35 psion kernel: ESI: 00000000 EDI: 00000000 EBP: f5775e38 
ESP: f5775e34
Apr 20 19:22:35 psion kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Apr 20 19:22:35 psion kernel: CR0: 80050033 CR2: 0000002c CR3: 35590000 
CR4: 000007d0
Apr 20 19:22:35 psion kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 
DR3: 00000000
Apr 20 19:22:35 psion kernel: DR6: ffff0ff0 DR7: 00000400
Apr 20 19:22:35 psion kernel: Process plasma-desktop (pid: 2113, 
ti=f5774000 task=f594c000 task.ti=f5774000)
Apr 20 19:22:35 psion kernel: Stack:
Apr 20 19:22:35 psion kernel:  f76a10e0 f5775e74 c1112b28 f5775e50 
f5775e78 c107efee 00000000 f55a48c0
Apr 20 19:22:35 psion kernel:  00001000 00000000 f5775e78 f410a34c 
f55a48c0 f76a10e0 f5711d00 00001000
Apr 20 19:22:35 psion kernel:  f5775e98 c110791a 00001000 f5775e84 
00a0a030 00000000 f76a10e0 b29fc008
Apr 20 19:22:35 psion kernel: Call Trace:
Apr 20 19:22:35 psion kernel:  [<c1112b28>] nfs_updatepage+0x170/0x40d
Apr 20 19:22:35 psion kernel:  [<c107efee>] ? wait_on_page_bit+0x57/0x60
Apr 20 19:22:35 psion kernel:  [<c110791a>] nfs_vm_page_mkwrite+0xbb/0xfb
Apr 20 19:22:35 psion kernel:  [<c109098f>] do_wp_page.clone.78+0x186/0x51e
Apr 20 19:22:35 psion kernel:  [<c1092092>] handle_pte_fault+0x4e7/0x524
Apr 20 19:22:35 psion kernel:  [<c1092151>] handle_mm_fault+0x82/0x91
Apr 20 19:22:35 psion kernel:  [<c103eb71>] ? vmalloc_sync_all+0xe2/0xe2
Apr 20 19:22:35 psion kernel:  [<c103ee87>] do_page_fault+0x316/0x333
Apr 20 19:22:35 psion kernel:  [<c1066e56>] ? tick_program_event+0x1e/0x23
Apr 20 19:22:35 psion kernel:  [<c105954e>] ? hrtimer_interrupt+0x11b/0x1cc
Apr 20 19:22:35 psion kernel:  [<c103eb71>] ? vmalloc_sync_all+0xe2/0xe2
Apr 20 19:22:35 psion kernel:  [<c13dacd0>] error_code+0x58/0x60
Apr 20 19:22:35 psion kernel:  [<c13d0000>] ? i810fb_init+0x1f5/0x346
Apr 20 19:22:35 psion kernel:  [<c103eb71>] ? vmalloc_sync_all+0xe2/0xe2
Apr 20 19:22:35 psion kernel: Code: e0 25 00 e0 ff ff ff 40 14 83 42 20 
ff 83 52 24 ff ff 48 14 8b 40 08 a8 08 74 05 e8 7b 89 2c 00 53 9d 5b c9 
c3 55 89 e5 53 89 c3 <8b> 40 2c a8 04 74 2f 89 e0 25 00 e0 ff ff ff 40 
14 89 d8 e8 a0
Apr 20 19:22:35 psion kernel: EIP: [<c111151c>] 
nfs_clear_request_commit+0x6/0x3f SS:ESP 0068:f5775e34
Apr 20 19:22:35 psion kernel: CR2: 000000000000002c
Apr 20 19:22:35 psion kernel: ---[ end trace ca3d62059c1cf3d5 ]---


