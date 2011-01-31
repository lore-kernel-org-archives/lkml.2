Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1AaKGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:06:30 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:56083 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751368Ab1AaKG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:06:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=e8POBHpCGS3p8CGx4Dcli1fltI2jF7sBD+6qzQi3Fon61Kq4LR1++zYrAH23Vm+wHHWLLDJZ006jUnk5R52liR4tm0FCXTahVP3ebnvn0XPOCHUuRoVWjHvo9rwj1rgc;
Message-ID: <4D46899B.80302@tao.ma>
Date: Mon, 31 Jan 2011 18:06:19 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: kref and apparmor panic in 2.6.38-rc2.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     I get this message when testing ext4. I am not sure whether it is 
apparmor or kref related.
[ 1990.293928] ------------[ cut here ]------------
[ 1990.295021] WARNING: at lib/kref.c:34 kref_get+0x21/0x30()
[ 1990.296257] Hardware name: Bochs
[ 1990.296884] Modules linked in: ext4 jbd2 lp psmouse serio_raw 
parport_pc floppy parport 8139too 8139cp i2c_piix4 mii [last unloaded: ext4]
[ 1990.299102] Pid: 2809, comm: gcc Not tainted 2.6.38-rc2+ #30
[ 1990.300340] Call Trace:
[ 1990.300939]  [<c030db61>] ? kref_get+0x21/0x30
[ 1990.302011]  [<c0151dc1>] ? warn_slowpath_common+0x81/0xa0
[ 1990.303321]  [<c030db61>] ? kref_get+0x21/0x30
[ 1990.304432]  [<c0151e02>] ? warn_slowpath_null+0x22/0x30
[ 1990.305791]  [<c030db61>] ? kref_get+0x21/0x30
[ 1990.306797]  [<c02e4c73>] ? aa_dup_task_context+0x33/0x60
[ 1990.307894]  [<c02e9146>] ? apparmor_cred_prepare+0x36/0x50
[ 1990.308832]  [<c02bc1f5>] ? security_prepare_creds+0x15/0x20
[ 1990.310147]  [<c017533b>] ? prepare_creds+0x7b/0x90
[ 1990.310925]  [<c0210ee8>] ? sys_faccessat+0x38/0x170
[ 1990.311724]  [<c01a09fd>] ? audit_syscall_exit+0x32d/0x3a0
[ 1990.312655]  [<c0211045>] ? sys_access+0x25/0x30
[ 1990.313394]  [<c010a923>] ? sysenter_do_call+0x12/0x28
[ 1990.314202] ---[ end trace afaebe646b776b5e ]---
[ 1990.315342] BUG: unable to handle kernel paging request at fffffffd
[ 1990.316635] IP: [<c030db46>] kref_get+0x6/0x30
[ 1990.316635] *pdpt = 00000000007c3001 *pde = 00000000007c8067 *pte = 
0000000000000000
[ 1990.316635] Oops: 0000 [#1] SMP
[ 1990.316635] last sysfs file: /sys/block/md0/range
[ 1990.316635] Modules linked in: ext4 jbd2 lp psmouse serio_raw 
parport_pc floppy parport 8139too 8139cp i2c_piix4 mii [last unloaded: ext4]
[ 1990.316635]
[ 1990.316635] Pid: 2809, comm: gcc Tainted: G        W   2.6.38-rc2+ 
#30 /Bochs
[ 1990.316635] EIP: 0060:[<c030db46>] EFLAGS: 00210282 CPU: 0
[ 1990.316635] EIP is at kref_get+0x6/0x30
[ 1990.316635] EAX: fffffffd EBX: fffffffd ECX: ffffffff EDX: 00000000
[ 1990.316635] ESI: f30cf480 EDI: e6490d80 EBP: e6593f34 ESP: e6593f30
[ 1990.316635]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1990.316635] Process gcc (pid: 2809, ti=e6592000 task=f30fe520 
task.ti=e6592000)
[ 1990.316635] Stack:
[ 1990.316635]  f6404400 e6593f40 c02e4c82 f6404400 e6593f54 c02e9146 
c06dcc60 f30cf480
[ 1990.316635]  087dfb90 e6593f60 c02bc1f5 e6490d80 e6593f70 c017533b 
00000001 087e047c
[ 1990.316635]  e6593f98 c0210ee8 c01a09fd f30cf480 e8f4fc3c 00000002 
e640f800 087dfb90
[ 1990.316635] Call Trace:
[ 1990.316635]  [<c02e4c82>] aa_dup_task_context+0x42/0x60
[ 1990.316635]  [<c02e9146>] apparmor_cred_prepare+0x36/0x50
[ 1990.316635]  [<c02bc1f5>] security_prepare_creds+0x15/0x20
[ 1990.316635]  [<c017533b>] prepare_creds+0x7b/0x90
[ 1990.316635]  [<c0210ee8>] sys_faccessat+0x38/0x170
[ 1990.316635]  [<c01a09fd>] ? audit_syscall_exit+0x32d/0x3a0
[ 1990.316635]  [<c0211045>] sys_access+0x25/0x30
[ 1990.316635]  [<c010a923>] sysenter_do_call+0x12/0x28
[ 1990.316635] Code: 42 e4 ff eb cd ba 38 00 00 00 b8 0f 00 65 c0 e8 b1 
42 e4 ff eb bc eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 53 
89 c3 <8b> 00 85 c0 74 06 3e ff 03 5b 5d c3 ba 22 00 00 00 b8 0f 00 65
[ 1990.316635] EIP: [<c030db46>] kref_get+0x6/0x30 SS:ESP 0068:e6593f30
[ 1990.316635] CR2: 00000000fffffffd
[ 1990.316635] ---[ end trace afaebe646b776b5f ]---
[ 1990.358253] ------------[ cut here ]------------
[ 1990.359138] WARNING: at lib/kref.c:34 kref_get+0x21/0x30()
[ 1990.360165] Hardware name: Bochs
[ 1990.360829] Modules linked in: ext4 jbd2 lp psmouse serio_raw 
parport_pc floppy parport 8139too 8139cp i2c_piix4 mii [last unloaded: ext4]
[ 1990.363774] Pid: 2808, comm: sh Tainted: G      D W   2.6.38-rc2+ #30
[ 1990.365217] Call Trace:
[ 1990.366000]  [<c030db61>] ? kref_get+0x21/0x30
[ 1990.366896]  [<c0151dc1>] ? warn_slowpath_common+0x81/0xa0
[ 1990.367869]  [<c030db61>] ? kref_get+0x21/0x30
[ 1990.368748]  [<c0151e02>] ? warn_slowpath_null+0x22/0x30
[ 1990.369698]  [<c030db61>] ? kref_get+0x21/0x30
[ 1990.371340]  [<c02e4c73>] ? aa_dup_task_context+0x33/0x60
[ 1990.372380]  [<c02e9146>] ? apparmor_cred_prepare+0x36/0x50
[ 1990.373400]  [<c02bc1f5>] ? security_prepare_creds+0x15/0x20
[ 1990.374539]  [<c017533b>] ? prepare_creds+0x7b/0x90
[ 1990.375436]  [<c0210ee8>] ? sys_faccessat+0x38/0x170
[ 1990.376354]  [<c01a09fd>] ? audit_syscall_exit+0x32d/0x3a0
[ 1990.377359]  [<c0211045>] ? sys_access+0x25/0x30
[ 1990.378197]  [<c010a923>] ? sysenter_do_call+0x12/0x28
[ 1990.379146] ---[ end trace afaebe646b776b60 ]---
[ 1990.380309] BUG: unable to handle kernel NULL pointer dereference at 
00000009
[ 1990.381640] IP: [<c030db46>] kref_get+0x6/0x30
[ 1990.382544] *pdpt = 000000002648f001 *pde = 0000000000000000
[ 1990.383843] Oops: 0000 [#2] SMP
[ 1990.384009] last sysfs file: /sys/block/md0/range
[ 1990.384009] Modules linked in: ext4 jbd2 lp psmouse serio_raw 
parport_pc floppy parport 8139too 8139cp i2c_piix4 mii [last unloaded: ext4]
[ 1990.384009]
[ 1990.384009] Pid: 2808, comm: sh Tainted: G      D W   2.6.38-rc2+ #30 
/Bochs
[ 1990.384009] EIP: 0060:[<c030db46>] EFLAGS: 00210206 CPU: 0
[ 1990.384009] EIP is at kref_get+0x6/0x30
[ 1990.384009] EAX: 00000009 EBX: 00000009 ECX: ffffffff EDX: 00000000
[ 1990.384009] ESI: f30cf200 EDI: e6490c00 EBP: f315ff34 ESP: f315ff30
[ 1990.384009]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1990.384009] Process sh (pid: 2808, ti=f315e000 task=f30fed60 
task.ti=f315e000)
[ 1990.384009] Stack:
[ 1990.384009]  f6404400 f315ff40 c02e4c82 f6404400 f315ff54 c02e9146 
c06dcc60 f30cf200
[ 1990.384009]  08d3d4c0 f315ff60 c02bc1f5 e6490c00 f315ff70 c017533b 
00000001 08d40ae0
[ 1990.384009]  f315ff98 c0210ee8 c01a09fd 0000abe8 00000000 00000002 
e640d000 08d40ae0
[ 1990.384009] Call Trace:
[ 1990.384009]  [<c02e4c82>] aa_dup_task_context+0x42/0x60
[ 1990.384009]  [<c02e9146>] apparmor_cred_prepare+0x36/0x50
[ 1990.384009]  [<c02bc1f5>] security_prepare_creds+0x15/0x20
[ 1990.384009]  [<c017533b>] prepare_creds+0x7b/0x90
[ 1990.384009]  [<c0210ee8>] sys_faccessat+0x38/0x170
[ 1990.384009]  [<c01a09fd>] ? audit_syscall_exit+0x32d/0x3a0
[ 1990.384009]  [<c0211045>] sys_access+0x25/0x30
[ 1990.384009]  [<c010a923>] sysenter_do_call+0x12/0x28
[ 1990.384009] Code: 42 e4 ff eb cd ba 38 00 00 00 b8 0f 00 65 c0 e8 b1 
42 e4 ff eb bc eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 53 
89 c3 <8b> 00 85 c0 74 06 3e ff 03 5b 5d c3 ba 22 00 00 00 b8 0f 00 65
[ 1990.384009] EIP: [<c030db46>] kref_get+0x6/0x30 SS:ESP 0068:f315ff30
[ 1990.384009] CR2: 0000000000000009
[ 1990.423834] AppArmor: free_profile: internal error, profile '' still 
on ns list
[ 1990.425251] ------------[ cut here ]------------
[ 1990.426091] kernel BUG at security/apparmor/policy.c:736!
[ 1990.427035] invalid opcode: 0000 [#3] SMP
[ 1990.428043] last sysfs file: /sys/block/md0/range
[ 1990.429198] Modules linked in: ext4 jbd2 lp psmouse serio_raw 
parport_pc floppy parport 8139too 8139cp i2c_piix4 mii [last unloaded: ext4]
[ 1990.429221]
[ 1990.429221] Pid: 2808, comm: sh Tainted: G      D W   2.6.38-rc2+ #30 
/Bochs
[ 1990.429221] EIP: 0060:[<c02e701e>] EFLAGS: 00210292 CPU: 0
[ 1990.429221] EIP is at aa_free_profile_kref+0x3e/0x120
[ 1990.429221] EAX: 00000059 EBX: f6404400 ECX: ffffffff EDX: 00000000
[ 1990.429221] ESI: c02e6fe0 EDI: 00000004 EBP: f6409f3c ESP: f6409f2c
[ 1990.429221]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1990.429221] Process sh (pid: 2808, ti=f6408000 task=f30fed60 
task.ti=f315e000)
[ 1990.429221] Stack:
[ 1990.429221]  c064e0d8 c059c243 f6404400 f6404408 f6409f4c c030dafd 
f30c5600 f6e042e0
[ 1990.429221]  f6409f58 c02e4d92 e6490d00 f6409f64 c02e90e3 e6490d00 
f6409f6c c02bc1d4
[ 1990.429221]  f6409f84 c0174edf 00000003 f6409f84 c02134fb e6490ce4 
f6409fac c01a83c5
[ 1990.429221] Call Trace:
[ 1990.429221]  [<c030dafd>] kref_put+0x2d/0x70
[ 1990.429221]  [<c02e4d92>] aa_free_task_context+0x22/0x60
[ 1990.429221]  [<c02e90e3>] apparmor_cred_free+0x13/0x20
[ 1990.429221]  [<c02bc1d4>] security_cred_free+0x14/0x20
[ 1990.429221]  [<c0174edf>] put_cred_rcu+0x1f/0x90
[ 1990.429221]  [<c02134fb>] ? file_free_rcu+0x2b/0x30
[ 1990.429221]  [<c01a83c5>] __rcu_process_callbacks+0xf5/0x2e0
[ 1990.429221]  [<c01a85d3>] rcu_process_callbacks+0x23/0x40
[ 1990.429221]  [<c0157c92>] __do_softirq+0x92/0x1a0
[ 1990.429221]  [<c0157c00>] ? __do_softirq+0x0/0x1a0
[ 1990.429221] <IRQ>
[ 1990.429221]  [<c0157e0c>] ? irq_exit+0x6c/0x80
[ 1990.429221]  [<c057d2f0>] ? smp_apic_timer_interrupt+0x60/0x8f
[ 1990.429221]  [<c0576c01>] ? apic_timer_interrupt+0x31/0x40
[ 1990.429221]  [<c01500d8>] ? unshare_files+0x8/0x80
[ 1990.429221]  [<c05779ac>] ? oops_end+0x6c/0xd0
[ 1990.429221]  [<c0152d60>] ? printk+0x20/0x30
[ 1990.429221]  [<c0134703>] ? no_context+0x123/0x1a0
[ 1990.429221]  [<c01348bc>] ? __bad_area_nosemaphore+0x4c/0x160
[ 1990.429221]  [<c0128eab>] ? lapic_next_event+0x1b/0x20
[ 1990.429221]  [<c017c586>] ? clockevents_program_event+0xb6/0x140
[ 1990.429221]  [<c0134a0f>] ? __bad_area+0x3f/0x50
[ 1990.429221]  [<c0134a57>] ? bad_area+0x17/0x20
[ 1990.429221]  [<c0579da0>] ? do_page_fault+0x390/0x480
[ 1990.429221]  [<c010d775>] ? show_trace_log_lvl+0x45/0x60
[ 1990.429221]  [<c0157ddd>] ? irq_exit+0x3d/0x80
[ 1990.429221]  [<c0579a10>] ? do_page_fault+0x0/0x480
[ 1990.429221]  [<c0576f07>] ? error_code+0x67/0x70
[ 1990.429221]  [<c030db46>] ? kref_get+0x6/0x30
[ 1990.429221]  [<c02e4c82>] ? aa_dup_task_context+0x42/0x60
[ 1990.429221]  [<c02e9146>] ? apparmor_cred_prepare+0x36/0x50
[ 1990.429221]  [<c02bc1f5>] ? security_prepare_creds+0x15/0x20
[ 1990.429221]  [<c017533b>] ? prepare_creds+0x7b/0x90
[ 1990.429221]  [<c0210ee8>] ? sys_faccessat+0x38/0x170
[ 1990.429221]  [<c01a09fd>] ? audit_syscall_exit+0x32d/0x3a0
[ 1990.429221]  [<c0211045>] ? sys_access+0x25/0x30
[ 1990.429221]  [<c010a923>] ? sysenter_do_call+0x12/0x28
[ 1990.429221] Code: c0 85 c0 0f 85 b0 00 00 00 85 db 0f 84 a2 00 00 00 
8d 43 0c 39 43 0c 74 16 b8 43 c2 59 c0 e8 8a b4 e6 ff 85 c0 0f 85 bd 00 
00 00 <0f> 0b eb fe 89 d8 e8 a7 fc ff ff 8b 43 1c 85 c0 74 0d 83 c0 08
[ 1990.429221] EIP: [<c02e701e>] aa_free_profile_kref+0x3e/0x120 SS:ESP 
0068:f6409f2c
[ 1990.497092] ---[ end trace afaebe646b776b61 ]---

Regards,
Tao
