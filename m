Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0JTQDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:03:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65034 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0JTQDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TxsMdBRgDI5yZ4T/1qQzzvkZQ7mLlDWIGB6qghsIUiA3ruD/ixwSPtNwYUxC1eQsW1
         3eRdWPYA3WjOvjvkPH2i1vGfifBC/qzeLfcgY/A9cm0Vo+I5X7OJ9bmQSnm3AY31NV/i
         eV2DRT88NnK1pcv0QZwwf+NFxjMT/7/XjtQmc=
Message-ID: <4CBF12D4.4070207@gmail.com>
Date: Wed, 20 Oct 2010 18:03:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: ptrace BUG [was: mmotm 2010-10-13-17-13 uploaded]
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org> <4CBF0FB7.3000602@gmail.com> <20101020155406.GC5387@nowhere>
In-Reply-To: <20101020155406.GC5387@nowhere>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 05:54 PM, Frederic Weisbecker wrote:
> On Wed, Oct 20, 2010 at 05:50:15PM +0200, Jiri Slaby wrote:
>> On 10/14/2010 02:13 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
>>
>> Hi, I tried to run a process in gdb and got this BUG:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
>> IP: [<ffffffff810c5c08>] fetch_bp_busy_slots.clone.1+0x28/0x1c0
>> PGD 1bacfa067 PUD 13b7f1067 PMD 0
>> Oops: 0000 [#1] SMP
>> last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
>> CPU 1
>> Modules linked in: dvb_usb_af9015 dvb_usb
> 
> 
> 
> Do you have this fix?
> 
> d580ff8699e8811a9af37e9de4dea375401bdeec
> ("perf, hw_breakpoint: Fix crash in hw_breakpoint creation")
> 
> It's in tip:/perf/core, which perhaps hasn't yet reached -next.
> 
> 
> This should fix the problem.

I applied the patch and got another BUG:
WARNING: at /home/l/latest/xxx/kernel/fork.c:183
__put_task_struct+0xf2/0x110()
Hardware name: To Be Filled By O.E.M.
Modules linked in: dvb_usb_af9015 dvb_usb
Pid: 4743, comm: gdb Not tainted 2.6.36-rc7-mm1_64+ #1295
Call Trace:
 [<ffffffff810692ca>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81069315>] warn_slowpath_null+0x15/0x20
 [<ffffffff810672a2>] __put_task_struct+0xf2/0x110
 [<ffffffff81074c4f>] sys_ptrace+0x7f/0xc0
 [<ffffffff8102ee2b>] system_call_fastpath+0x16/0x1b
---[ end trace 4d39ff87d0cf3ac8 ]---
------------[ cut here ]------------
WARNING: at /home/l/latest/xxx/kernel/fork.c:183
__put_task_struct+0xf2/0x110()
Hardware name: To Be Filled By O.E.M.
Modules linked in: dvb_usb_af9015 dvb_usb
Pid: 4743, comm: gdb Tainted: G        W   2.6.36-rc7-mm1_64+ #1295
Call Trace:
 [<ffffffff810692ca>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81069315>] warn_slowpath_null+0x15/0x20
 [<ffffffff810672a2>] __put_task_struct+0xf2/0x110
 [<ffffffff81074c4f>] sys_ptrace+0x7f/0xc0
 [<ffffffff8102ee2b>] system_call_fastpath+0x16/0x1b
---[ end trace 4d39ff87d0cf3ac9 ]---
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8108b55a>] exit_creds+0x1a/0x90
PGD 1abdc9067 PUD 1abdcb067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/net/tun0/statistics/collisions
CPU 1
Modules linked in: dvb_usb_af9015 dvb_usb

Pid: 4743, comm: gdb Tainted: G        W   2.6.36-rc7-mm1_64+ #1295 To
be filled by O.E.M./To Be Filled By O.E.M.
RIP: 0010:[<ffffffff8108b55a>]  [<ffffffff8108b55a>] exit_creds+0x1a/0x90
RSP: 0018:ffff8801a98e5f08  EFLAGS: 00010292
RAX: 0000000000000000 RBX: ffff88019584f500 RCX: 000000000003ffff
RDX: ffffffff81812968 RSI: 0000000000000046 RDI: 0000000000000000
RBP: ffff8801a98e5f18 R08: 0000000000000034 R09: 000000000000e1fd
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000006
R13: 0000000000000368 R14: 0000000000000000 R15: 000000000003057f
FS:  00007f4d44bb5700(0000) GS:ffff8800af280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001abff4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gdb (pid: 4743, threadinfo ffff8801a98e4000, task ffff88019583a080)
Stack:
 ffff8801a98e5f18 ffff88019584f500 ffff8801a98e5f38 ffffffff810671ed
 ffff88019584f500 0000000000000006 ffff8801a98e5f78 ffffffff81074c4f
 0000000000000003 fffffffffffffffd 00007f4d44bb56a8 0000000000000003
Call Trace:
 [<ffffffff810671ed>] __put_task_struct+0x3d/0x110
 [<ffffffff81074c4f>] sys_ptrace+0x7f/0xc0
 [<ffffffff8102ee2b>] system_call_fastpath+0x16/0x1b
Code: 84 36 ff ff ff e9 0f ff ff ff 0f 0b 0f 0b 0f 1f 00 55 48 89 e5 53
48 89 fb 48 83 ec 08 48 8b 87 08 03 00 00 48 8b bf 00 03 00 00 <8b> 00
48 c7 83 00 03 00 00 00 00 00 00 f0 ff 0f 0f 94 c0 84 c0
RIP  [<ffffffff8108b55a>] exit_creds+0x1a/0x90
 RSP <ffff8801a98e5f08>
CR2: 0000000000000000
---[ end trace 4d39ff87d0cf3aca ]---
psi[4748] trap int3 ip:7ffff3bdaa01 sp:7fffffffccc8 error:0

thanks,
-- 
js
