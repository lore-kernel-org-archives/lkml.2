Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1ADTqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:46:54 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37861 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1ADTqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:46:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=mLUG+6oDsZH0Pj8BYbXqH5DjikKSpv3Fnn0RVoe7zEqs0UT6iA4VPhLSiNDC3tqF50
         fa7eETEtCQrQPWdmG/Osv3dvZWwAI7hr8kOW/Ri0eXAUB+EviDr/m+rM1nGOfRzDlBYB
         ODj7Kn1oiSpPD5DXTwhUp9/+GsiGWEVdYQqo0=
MIME-Version: 1.0
In-Reply-To: <AANLkTimH+xa3Na6Y+M=UNZSfjph5etyTtc=v2TMdqwHj@mail.gmail.com>
References: <AANLkTimH+xa3Na6Y+M=UNZSfjph5etyTtc=v2TMdqwHj@mail.gmail.com>
From: Leo Prasath <leo.prasath@gmail.com>
Date: Tue, 4 Jan 2011 13:46:32 -0600
Message-ID: <AANLkTik_dFBq5=GDB3tmiN0N=hc1iaif0hv4URnm2f5b@mail.gmail.com>
Subject: Null pointer exception for local variables in stack with C++ kernel modules
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I have integrated a C++ codebase which uses minimalistic features of c
and followed the guidelines in
http://pograph.wordpress.com/2009/04/05/porting-cpp-code-to-linux-kernel/
to integrate with an existing C linux kernel module.
It all works fine except for occassional very very weird NULL pointer
exceptions.

The problem that I am facing is , I get NULL pointer exceptions while
the C++ code access local variables in the program stack.
The same functions in which the null pointer exceptions occur have
executed correctly several times before such an exception occurs.

The null pointer exceptions that I get and the corresponding code
where this occurs are below.

Any help / clues/ pointers on how to go about debugging this are very welcome !

Relevant details :
-------------------------

Code 1:

void Address::from_long(ssd::ulong longval)
{
        page = longval % BLOCK_SIZE;
        longval /= BLOCK_SIZE;
        block = longval % PLANE_SIZE;
        longval /= PLANE_SIZE;
        plane = longval % DIE_SIZE;
    <============ Null pointer Exception in this line
        longval /= DIE_SIZE;
        die = longval % PACKAGE_SIZE;
        longval /= PACKAGE_SIZE;
        package = longval % SSD_SIZE;
        valid = PAGE;
}

Exception 1:

(/root/compressions/Compressions/psu_ssd/sba.c, 888): process_request:
process request : block 64 rw 1 sectors : 8calling get_next_free_addr
(flashsim/flashsim.cpp, 32): issue_request: issue request lba 0 size 1 dir 1
BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffffa01c3373>] _ZN3ssd7Address9from_longEm+0xa3/0x12c [SBA]
PGD 1f6ebc067 PUD 21d440067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/devices/virtual/block/sba0/range
CPU 0
Pid: 2349, comm: disksimulator0
 Not tainted 2.6.33.yy #71 0GM819/OptiPlex 755
RIP: 0010:[<ffffffffa01c3373>]  [<ffffffffa01c3373>]
_ZN3ssd7Address9from_longEm+0xa3/0x12c [SBA]
RSP: 0018:ffff88022c49bbe0  EFLAGS: 00010296
RAX: 0000000000000018 RBX: 0000000000000008 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88021d7e9f00
RBP: ffff88022c49bbe0 R08: 0000000000000086 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff88021c7e8a80
R13: 0000000000000038 R14: ffffffffa01d3378 R15: ffff88022c49bd90
FS:  0000000000000000(0000) GS:ffff880009e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000020 CR3: 00000001f6e7a000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process disksimulator0
 (pid: 2349, threadinfo ffff88022c49a000, task ffff88021c7da450)
Stack:
 ffff88022c49bc10 ffffffffa01c7eb3 ffff88021d7e9ed8 ffff88021d6f8640
<0> ffff88021d6f8630 ffff88021d7e9ed8 ffff88022c49bc30 ffffffffa01c5703
<0> ffff88021d7e9ed8 ffff88021d6f8638 ffff88022c49bca0 ffffffffa01cb608
Call Trace:
 [<ffffffffa01c7eb3>] _ZN3ssd3Ftl5writeERNS_5EventE+0x37/0x5a [SBA]
 [<ffffffffa01c5703>]
_ZN3ssd10Controller12event_arriveERNS_5EventE+0x6b/0xb0 [SBA]
 [<ffffffffa01cb608>]
_ZN3ssd3Ssd12event_arriveENS_10event_typeEmjd+0x182/0x212 [SBA]
 [<ffffffffa01cc4f2>] issue_request+0xb2/0xf0 [SBA]
 [<ffffffffa01c07f9>] sba_common_execute_fault+0x18c/0x432 [SBA]
 [<ffffffff8143d267>] ? printk+0x41/0x4a
 [<ffffffffa01c0abc>] sba_common_inject_fault+0x1d/0x1f [SBA]
 [<ffffffffa01c19dc>] process_request+0x96/0xd4 [SBA]
 [<ffffffff81071eeb>] ? do_gettimeofday+0x1a/0x3a
 [<ffffffffa01bebc2>] ssd_process_request+0x22/0x34 [SBA]
 [<ffffffff8107ac36>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa01bedd2>] disk_simulator+0x1a9/0x4d4 [SBA]
 [<ffffffffa01bec29>] ? disk_simulator+0x0/0x4d4 [SBA]
 [<ffffffff8106984c>] kthread+0x9a/0xa2
 [<ffffffff8107abfe>] ? trace_hardirqs_on_caller+0x125/0x150
 [<ffffffff8100aaa4>] kernel_thread_helper+0x4/0x10
 [<ffffffff814407d0>] ? restore_args+0x0/0x30
 [<ffffffff810697b2>] ? kthread+0x0/0xa2
 [<ffffffff8100aaa0>] ? kernel_thread_helper+0x0/0x10
Code: f0 ba 00 00 00 00 48 f7 75 e8 48 89 45 f0 8b 05 4c f4 00 00 89
c1 48 8b 45 f0 ba 00 00 00 00 48 f7 f1 48 89 d0 89 c2 48 8b 45 f8 <89>
50 08 8b 05 2c f4 00 00 89 c0 48 89 45 e8 48 8b 45 f0 ba 00
RIP  [<ffffffffa01c3373>] _ZN3ssd7Address9from_longEm+0xa3/0x12c [SBA]
 RSP <ffff88022c49bbe0>
CR2: 0000000000000020
---[ end trace ccd59973ea413bef ]---

Code 2:

enum page_state Page::get_state(void) const
{
        return state;
             <=================== Null pointer exception in this line.
}

Exception 2:

(flashsim/flashsim.cpp, 32): issue_request: issue request lba 26 size 1 dir 1
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffffa01ba14a>] _ZNK3ssd4Page9get_stateEv+0xc/0x10 [SBA]
PGD 219196067 PUD 219195067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/block/sba0/range
CPU 1
Pid: 2542, comm: disksimulator0
 Not tainted 2.6.33.yy #71 0GM819/OptiPlex 755
RIP: 0010:[<ffffffffa01ba14a>]  [<ffffffffa01ba14a>]
_ZNK3ssd4Page9get_stateEv+0xc/0x10 [SBA]
RSP: 0018:ffff88022967fa30  EFLAGS: 00010282
RAX: 0000000000000018 RBX: ffff8801f6800000 RCX: 0000000000000080
RDX: 00000000000003a0 RSI: ffff88022b516820 RDI: ffff88022af32d08
RBP: ffff88022967fa30 R08: 0000000000000086 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff8801ef9c5180
R13: 0000000000000690 R14: ffffffffa01c4378 R15: ffff88022967fd90
FS:  0000000000000000(0000) GS:ffff88000a000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 000000022c5be000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process disksimulator0
 (pid: 2542, threadinfo ffff88022967e000, task ffff88021c70a450)
Stack:
 ffff88022967fa60 ffffffffa01b4e75 ffff88022b516820 ffff8801f6800080
<0> 0000000100000000 0000001df6800080 ffff88022967fa90 ffffffffa01bb594
<0> 00000000000001ff ffff88022b5167e0 ffff88021c7e5168 000000021c474e10
Call Trace:
 [<ffffffffa01b4e75>]
_ZNK3ssd5Block13get_next_pageERNS_7AddressE+0x33/0x76 [SBA]
 [<ffffffffa01bb594>] _ZN3ssd5Plane13get_next_pageEv+0x74/0xae [SBA]
 [<ffffffffa01ba6b0>] _ZN3ssd5Plane5writeERNS_5EventE+0x10c/0x198 [SBA]
 [<ffffffffa01b784a>] _ZN3ssd3Die5writeERNS_5EventE+0x152/0x15a [SBA]
 [<ffffffffa01b940d>] _ZN3ssd7Package5writeERNS_5EventE+0xf7/0xfe [SBA]
 [<ffffffffa01bc878>] _ZN3ssd3Ssd5writeERNS_5EventE+0xec/0xf4 [SBA]
 [<ffffffffa01b6ad1>] _ZN3ssd10Controller5issueERNS_5EventE+0x389/0x6ca [SBA]
 [<ffffffffa01b8ec9>] _ZN3ssd3Ftl5writeERNS_5EventE+0x4d/0x5a [SBA]
 [<ffffffffa01b6703>]
_ZN3ssd10Controller12event_arriveERNS_5EventE+0x6b/0xb0 [SBA]
 [<ffffffffa01bc608>]
_ZN3ssd3Ssd12event_arriveENS_10event_typeEmjd+0x182/0x212 [SBA]
 [<ffffffffa01bd4f2>] issue_request+0xb2/0xf0 [SBA]
 [<ffffffffa01b17f9>] sba_common_execute_fault+0x18c/0x432 [SBA]
 [<ffffffff8143d267>] ? printk+0x41/0x4a
 [<ffffffffa01b1abc>] sba_common_inject_fault+0x1d/0x1f [SBA]
 [<ffffffffa01b29dc>] process_request+0x96/0xd4 [SBA]
 [<ffffffff81071eeb>] ? do_gettimeofday+0x1a/0x3a
 [<ffffffffa01afbc2>] ssd_process_request+0x22/0x34 [SBA]
 [<ffffffff8107ac36>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa01afdd2>] disk_simulator+0x1a9/0x4d4 [SBA]
 [<ffffffffa01afc29>] ? disk_simulator+0x0/0x4d4 [SBA]
 [<ffffffff8106984c>] kthread+0x9a/0xa2
 [<ffffffff8107abfe>] ? trace_hardirqs_on_caller+0x125/0x150
 [<ffffffff8100aaa4>] kernel_thread_helper+0x4/0x10
 [<ffffffff814407d0>] ? restore_args+0x0/0x30
 [<ffffffff810697b2>] ? kthread+0x0/0xa2
 [<ffffffff8100aaa0>] ? kernel_thread_helper+0x0/0x10
Code: 01 00 00 00 eb 05 b8 00 00 00 00 c9 c3 55 48 89 e5 48 89 7d f8
48 8b 45 f8 48 8b 40 08 c9 c3 55 48 89 e5 48 89 7d f8 48 8b 45 f8 <8b>
00 c9 c3 55 48 89 e5 48 89 7d f8 89 75 f4 48 8b 45 f8 8b 55
RIP  [<ffffffffa01ba14a>] _ZNK3ssd4Page9get_stateEv+0xc/0x10 [SBA]
 RSP <ffff88022967fa30>
CR2: 0000000000000018
---[ end trace e73656473e494c3b ]---

Code 3:

double Event::incr_time_taken(double time_incr)
{
        if(time_incr > 0.0)
                time_taken += time_incr;
                 <====================== Null pointer exception in
this line
        return time_taken;
}

Exception 3:

(flashsim/flashsim.cpp, 32): issue_request: issue request lba 15 size 1 dir 1
BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffffa01cdc19>] _ZN3ssd5Event15incr_time_takenEd+0x25/0x4c [SBA]
PGD 21902d067 PUD 22af61067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/block/sba0/range
CPU 1
Pid: 1680, comm: disksimulator0
 Not tainted 2.6.33.yy #71 0GM819/OptiPlex 755
RIP: 0010:[<ffffffffa01cdc19>]  [<ffffffffa01cdc19>]
_ZN3ssd5Event15incr_time_takenEd+0x25/0x4c [SBA]
RSP: 0018:ffff88021c7c1ad0  EFLAGS: 00010202
RAX: 0000000000000018 RBX: 0000000000000000 RCX: 00000000000001ff
RDX: 0000000000000083 RSI: 0000000000000200 RDI: ffff880219046000
RBP: ffff88021c7c1ad0 R08: 0000000000000086 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff88021c6eebc0
R13: 00000000000003e0 R14: ffffffffa01d9378 R15: ffff88021c7c1d90
FS:  0000000000000000(0000) GS:ffff88000a000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000020 CR3: 000000021c7a3000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process disksimulator0
 (pid: 1680, threadinfo ffff88021c7c0000, task ffff88022c82c8a0)
Stack:
 ffff88021c7c1b10 ffffffffa01caea9 ffff880219046000 4028000000000000
<0> 3ff0000000000000 ffff88022b5a1dd0 000001fe0a1d3218 40979c0000000000
<0> ffff88021c7c1b60 ffffffffa01ca489 ffff88021c7c1b90 ffff880219046000
Call Trace:
 [<ffffffffa01caea9>] _ZN3ssd7Channel4lockEddRNS_5EventE+0x507/0x50e [SBA]
 [<ffffffffa01ca489>] _ZN3ssd3Bus4lockEjddRNS_5EventE+0xfb/0x102 [SBA]
 [<ffffffffa01cba7b>] _ZN3ssd10Controller5issueERNS_5EventE+0x333/0x6ca [SBA]
 [<ffffffffa01cdec9>] _ZN3ssd3Ftl5writeERNS_5EventE+0x4d/0x5a [SBA]
 [<ffffffffa01cb703>]
_ZN3ssd10Controller12event_arriveERNS_5EventE+0x6b/0xb0 [SBA]
 [<ffffffffa01d1608>]
_ZN3ssd3Ssd12event_arriveENS_10event_typeEmjd+0x182/0x212 [SBA]
 [<ffffffffa01d24f2>] issue_request+0xb2/0xf0 [SBA]
 [<ffffffffa01c67f9>] sba_common_execute_fault+0x18c/0x432 [SBA]
 [<ffffffff8143d267>] ? printk+0x41/0x4a
 [<ffffffffa01c6abc>] sba_common_inject_fault+0x1d/0x1f [SBA]
 [<ffffffffa01c79dc>] process_request+0x96/0xd4 [SBA]
 [<ffffffff81071eeb>] ? do_gettimeofday+0x1a/0x3a
 [<ffffffffa01c4bc2>] ssd_process_request+0x22/0x34 [SBA]
 [<ffffffff8107ac36>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa01c4dd2>] disk_simulator+0x1a9/0x4d4 [SBA]
 [<ffffffffa01c4c29>] ? disk_simulator+0x0/0x4d4 [SBA]
 [<ffffffff8106984c>] kthread+0x9a/0xa2
 [<ffffffff8107abfe>] ? trace_hardirqs_on_caller+0x125/0x150
 [<ffffffff8100aaa4>] kernel_thread_helper+0x4/0x10
 [<ffffffff814407d0>] ? restore_args+0x0/0x30
 [<ffffffff810697b2>] ? kthread+0x0/0xa2
 [<ffffffff8100aaa0>] ? kernel_thread_helper+0x0/0x10
Code: 10 45 e8 c9 c3 90 55 48 89 e5 48 89 7d f8 f2 0f 11 45 f0 66 0f
57 c9 f2 0f 10 45 f0 66 0f 2e c1 0f 97 c0 84 c0 74 17 48 8b 45 f8 <f2>
0f 10 40 08 f2 0f 58 45 f0 48 8b 45 f8 f2 0f 11 40 08 48 8b
RIP  [<ffffffffa01cdc19>] _ZN3ssd5Event15incr_time_takenEd+0x25/0x4c [SBA]
 RSP <ffff88021c7c1ad0>
CR2: 0000000000000020
---[ end trace cd7ad906a80537a5 ]---

Thanks,
-Leo
