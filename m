Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0HPIUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:20:09 -0400
Received: from alva.zappa.cx ([213.88.132.89]:50415 "EHLO alva.zappa.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab0HPIUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:20:07 -0400
X-Greylist: delayed 1326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 04:20:07 EDT
Message-ID: <4C68EF83.80109@zappa.cx>
Date: Mon, 16 Aug 2010 09:57:55 +0200
From: Andreas Sundstrom <sunkan@zappa.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel Oops with 2.6.35.2 and glxinfo (or other GL programs)
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my laptop X hangs as soon as something uses OpenGL.
Running for example glxinfo or glxgears causes it to freeze.
I have not had any issues like this before, and 2.6.34 works ok but not 2.6.35.2

I have pasted the Oops here: http://codepad.org/t1aVjAzy

I will include it with this email too, but to avoid problems with the formatting
I have provided the link above.

This is on a HP Compaq 6910p laptop running Debian Lenny

I used git bisect for the first time and it took a while but finally this commit was shown
by git as the offending commit:

8187a2b70e34c727a06617441f74f202b6fefaf9 is first bad commit
commit 8187a2b70e34c727a06617441f74f202b6fefaf9
Author: Zou Nan hai <nanhai.zou@intel.com>
Date:   Fri May 21 09:08:55 2010 +0800

    drm/i915: introduce intel_ring_buffer structure (V2)

    Introduces a more complete intel_ring_buffer structure with callbacks
    for setup and management of a particular ringbuffer, and converts the
    render ring buffer consumers to use it.

    Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
    Signed-off-by: Xiang Hai hao <haihao.xiang@intel.com>
    [anholt: Fixed up whitespace fail and rebased against prep patches]
    Signed-off-by: Eric Anholt <eric@anholt.net>

:040000 040000 b90a540c84c2ffa50b8b0bb7292749cef96e75d3
22c06e081bc722df129f2d0dc937950d5f164c5c M      drivers
:040000 040000 6ac1363503569458bf035132b01f206c256701cb
757099565b205b0908a8b903db5c9b00d2c6e142 M      include


I was not able to revert this commit from 2.6.35.2, but maybe it can be a pointer in the
right direction for someone that knows this stuff?

I'm not sure what else to provide? Let me know if I can do something to test
this further..

I'm not subscribed to the list so feel free to CC me on any replies.

Any help is appreciated
/Andreas

Oops message:
Aug 16 09:01:20 asu-laptop kernel: [   61.210488] BUG: unable to handle kernel NULL
pointer dereference at (null)
Aug 16 09:01:20 asu-laptop kernel: [   61.210496] IP: [<(null)>] (null)
Aug 16 09:01:20 asu-laptop kernel: [   61.210499] PGD 13ac34067 PUD 1372d9067 PMD 0
Aug 16 09:01:20 asu-laptop kernel: [   61.210504] Oops: 0010 [#1] SMP
Aug 16 09:01:20 asu-laptop kernel: [   61.210507] last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/inp
ut/input11/capabilities/sw
Aug 16 09:01:20 asu-laptop kernel: [   61.210511] CPU 0
Aug 16 09:01:20 asu-laptop kernel: [   61.210513] Modules linked in: i915 drm_kms_helper
rfcomm l2cap twofish twofish_common serpe
nt rmd160 af_key fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi firewire_sbp2
firewire_ohci iwlagn firewire_core crc_it
u_t btusb psmouse bluetooth iwlcore video backlight hp_accel lis3lv02d
Aug 16 09:01:20 asu-laptop kernel: [   61.210535]
Aug 16 09:01:20 asu-laptop kernel: [   61.210539] Pid: 5109, comm: glxinfo Not tainted
2.6.35.2 #3 30BE/HP Compaq 6910p (GB949ET#A
K8)
Aug 16 09:01:20 asu-laptop kernel: [   61.210541] RIP: 0010:[<0000000000000000>]
[<(null)>] (null)
Aug 16 09:01:20 asu-laptop kernel: [   61.210545] RSP: 0018:ffff88013a8c7cf0  EFLAGS: 00010286
Aug 16 09:01:20 asu-laptop kernel: [   61.210548] RAX: ffff88013bea4028 RBX:
0000000000000000 RCX: 000000000001761c
Aug 16 09:01:20 asu-laptop kernel: [   61.210551] RDX: 0000000000017620 RSI:
ffff88013bea4028 RDI: ffff8801358c6800
Aug 16 09:01:20 asu-laptop kernel: [   61.210553] RBP: ffff88013a8c7cf8 R08:
00000000000000d0 R09: ffff8801358c6800
Aug 16 09:01:20 asu-laptop kernel: [   61.210556] R10: ffff88013a8c7cf8 R11:
0000000000000000 R12: ffff8801358c6800
Aug 16 09:01:20 asu-laptop kernel: [   61.210559] R13: ffff88013a8c7dc8 R14:
0000000000000002 R15: 0000000000000000
Aug 16 09:01:20 asu-laptop kernel: [   61.210562] FS:  00007ff791cb96e0(0000)
GS:ffff880001e00000(0000) knlGS:0000000000000000
Aug 16 09:01:20 asu-laptop kernel: [   61.210565] CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Aug 16 09:01:20 asu-laptop kernel: [   61.210567] CR2: 0000000000000000 CR3:
00000001365bc000 CR4: 00000000000006f0
Aug 16 09:01:20 asu-laptop kernel: [   61.210570] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Aug 16 09:01:20 asu-laptop kernel: [   61.210573] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Aug 16 09:01:20 asu-laptop kernel: [   61.210576] Process glxinfo (pid: 5109, threadinfo
ffff88013a8c6000, task ffff8801364f9d80)
Aug 16 09:01:20 asu-laptop kernel: [   61.210578] Stack:
Aug 16 09:01:20 asu-laptop kernel: [   61.210580]  ffffffffa0148429 ffff88013a8c7d78
ffffffffa01264da ffff880100000000
Aug 16 09:01:20 asu-laptop kernel: [   61.210584] <0> 000000023a8c7d58 ffff88013bea4000
ffff8801358c6820 ffffc900040ed898
Aug 16 09:01:20 asu-laptop kernel: [   61.210588] <0> 0000000000000000 ffff88013a1da818
0000000000000000 0000000200000001
Aug 16 09:01:20 asu-laptop kernel: [   61.210593] Call Trace:
Aug 16 09:01:20 asu-laptop kernel: [   61.210614]  [<ffffffffa0148429>] ?
intel_ring_advance+0xd/0xf [i915]
Aug 16 09:01:20 asu-laptop kernel: [   61.210623]  [<ffffffffa01264da>]
i915_cmdbuffer+0x3a2/0x452 [i915]
Aug 16 09:01:20 asu-laptop kernel: [   61.210629]  [<ffffffff812cb714>] drm_ioctl+0x27a/0x338
Aug 16 09:01:20 asu-laptop kernel: [   61.210638]  [<ffffffffa0126138>] ?
i915_cmdbuffer+0x0/0x452 [i915]
Aug 16 09:01:20 asu-laptop kernel: [   61.210643]  [<ffffffff810ba6e8>] ?
__do_fault+0x341/0x378
Aug 16 09:01:20 asu-laptop kernel: [   61.210648]  [<ffffffff810e2758>] vfs_ioctl+0x2a/0x9e
Aug 16 09:01:20 asu-laptop kernel: [   61.210654]  [<ffffffff810e2d46>] sys_ioctl+0x55/0x77
Aug 16 09:01:20 asu-laptop kernel: [   61.210658]  [<ffffffff81002a2b>]
system_call_fastpath+0x16/0x1b
Aug 16 09:01:20 asu-laptop kernel: [   61.210661] Code:  Bad RIP value.
Aug 16 09:01:20 asu-laptop kernel: [   61.210666] RIP  [<(null)>] (null)
Aug 16 09:01:20 asu-laptop kernel: [   61.210669]  RSP <ffff88013a8c7cf0>
Aug 16 09:01:20 asu-laptop kernel: [   61.210670] CR2: 0000000000000000
Aug 16 09:01:20 asu-laptop kernel: [   61.210673] ---[ end trace c594406bea35578b ]---
Aug 16 09:01:27 asu-laptop kernel: [   67.990975] SysRq : Emergency Sync

