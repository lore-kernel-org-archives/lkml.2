Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab2JLI6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:58:10 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47306 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2JLI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaNj+Ji+cgt+3myE8vE_dX9rAR_jpGH=jjmbw0sLdcr2aw@mail.gmail.com>
References: <CADCVGbRTYecZrv+pH3QUHEQsAkar8XNaKhDLWm-K72f9hUCVOg@mail.gmail.com>
	<CAHdPZaNj+Ji+cgt+3myE8vE_dX9rAR_jpGH=jjmbw0sLdcr2aw@mail.gmail.com>
Date: Fri, 12 Oct 2012 16:58:02 +0800
Message-ID: <CADCVGbRBKvOWmV2fbM0oQL_Dt0ajfPu2gk+a-oy_-tAPHKv5Cg@mail.gmail.com>
Subject: Re: Using ps to display process information never exit, and can't be killed
From: Cyberman Wu <cypher.w@gmail.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, since strace is not in default root fs on that platform, I've forgot it.

I tried two time:
read(4, "36864\n", 24)                  = 6
close(4)                                = 0
mmap2(NULL, 262144, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0xaaaacf0000
mprotect(0xaaaad20000, 65536, PROT_NONE) = 0
gettimeofday({1350030074, 626458}, NULL) = 0
openat(AT_FDCWD, "/proc/meminfo", O_RDONLY) = 4
lseek(4, 0, SEEK_SET)                   = 0
read(4, "MemTotal:        8308416 kB\nMemF"..., 2047) = 1080
fstatat(AT_FDCWD, "/proc/self/task", {st_mode=S_IFDIR|0555, st_size=0,
...}, 0) = 0
openat(AT_FDCWD, "/proc", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 6
getdents64(6, /* 301 entries */, 32768) = 7568
fstatat(AT_FDCWD, "/proc/1", {st_mode=S_IFDIR|0555, st_size=0, ...}, 0) = 0
openat(AT_FDCWD, "/proc/1/stat", O_RDONLY) = 7
read(7, "1 (init) S 0 1 1 0 -1 4194560 14"..., 1023) = 206
close(7)                                = 0
openat(AT_FDCWD, "/proc/1/status", O_RDONLY) = 7
read(7, "Name:\tinit\nState:\tS (sleeping)\nT"..., 1023) = 722
close(7)                                = 0
fstatat(AT_FDCWD, "/proc/2", {st_mode=S_IFDIR|0555, st_size=0, ...}, 0) = 0
openat(AT_FDCWD, "/proc/2/stat", O_RDONLY) = 7
read(7, "2 (kthreadd) R 0 0 0 0 -1 214961"..., 1023) = 137
close(7)                                = 0
openat(AT_FDCWD, "/proc/2/status", O_RDONLY) = 7
read(7, "Name:\tkthreadd\nState:\tR (running"..., 1023) = 512
close(7)                                = 0
fstatat(AT_FDCWD, "/proc/3", {st_mode=S_IFDIR|0555, st_size=0, ...}, 0) = 0
openat(AT_FDCWD, "/proc/3/stat", O_RDONLY) = 7
read(7, "3 (ksoftirqd/0) S 2 0 0 0 -1 221"..., 1023) = 160
close(7)                                = 0
openat(AT_FDCWD, "/proc/3/status", O_RDONLY) = 7
read(7, "Name:\tksoftirqd/0\nState:\tS (slee"..., 1023) = 514
close(7)                                = 0
fstatat(AT_FDCWD, "/proc/4", {st_mode=S_IFDIR|0555, st_size=0, ...}, 0) = 0
openat(AT_FDCWD, "/proc/4/stat", O_RDONLY) = 7
read(7, "4 (kworker/0:0) S 2 0 0 0 -1 221"..., 1023) = 159
close(7)                                = 0
openat(AT_FDCWD, "/proc/4/status", O_RDONLY) = 7
read(7, "Name:\tkworker/0:0\nState:\tS (slee"..., 1023) = 511
close(7)                                = 0
fstatat(AT_FDCWD, "/proc/5", {st_mode=S_IFDIR|0555, st_size=0, ...}, 0) = 0
openat(AT_FDCWD, "/proc/5/stat", O_RDONLY) = 7
read(7, ^C <unfinished ...>
#
#
#
# ps
^C^C^C^C^C

close(7)                                = 0
fstatat(AT_FDCWD, "/proc/2", {st_mode=S_IFDIR|0555, st_size=0, ...}, 0) = 0
openat(AT_FDCWD, "/proc/2/stat", O_RDONLY) = 7
read(7, "2 (kthreadd) R 0 0 0 0 -1 214961"..., 1023) = 137
close(7)                                = 0
openat(AT_FDCWD, "/proc/2/status", O_RDONLY) = 7
read(7, "Name:\tkthreadd\nState:\tR (running"..., 1023) = 513
close(7)                                = 0
fstatat(AT_FDCWD, "/proc/3", {st_mode=S_IFDIR|0555, st_size=0, ...}, 0) = 0
openat(AT_FDCWD, "/proc/3/stat", O_RDONLY) = 7
read(7, "3 (ksoftirqd/0) S 2 0 0 0 -1 221"..., 1023) = 160
close(7)                                = 0
openat(AT_FDCWD, "/proc/3/status", O_RDONLY) = 7
read(7, "Name:\tksoftirqd/0\nState:\tS (slee"..., 1023) = 515
close(7)                                = 0
fstatat(AT_FDCWD, "/proc/4", {st_mode=S_IFDIR|0555, st_size=0, ...}, 0) = 0
openat(AT_FDCWD, "/proc/4/stat", O_RDONLY) = 7
read(7, "4 (kworker/0:0) S 2 0 0 0 -1 221"..., 1023) = 159
close(7)                                = 0
openat(AT_FDCWD, "/proc/4/status", O_RDONLY) = 7
read(7, "Name:\tkworker/0:0\nState:\tS (slee"..., 1023) = 512
close(7)                                = 0
fstatat(AT_FDCWD, "/proc/5", {st_mode=S_IFDIR|0555, st_size=0, ...}, 0) = 0
openat(AT_FDCWD, "/proc/5/stat", O_RDONLY) = 7
read(7,

( I'm using screen so some output lost)

The first time Ctrl-C quit strace, but it doesn't work second time.
It seem ps hang while it read /proc/5/stat, which I've check it 'comm'
and is some thing like
'kworker/u:0'. The system now stop response for any input, even in
serial port, so I can't
check it again. Output of our application is continue in serial port,
but I can't type any thing
in. For network, ping is still OK, but ssh/telnet can only connect to
that system, but can't
login now. All the old ssh connection is still connected, but nothing
can be typed in.


On Fri, Oct 12, 2012 at 3:18 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
> On Fri, Oct 12, 2012 at 1:56 AM, Cyberman Wu <cypher.w@gmail.com> wrote:
>> Sorry to use that big mail list account since I don't know any
>> specific mail list account should be used for that problem.
>>
>> We're running Linux box on Gx platform from Tilera. The kernel use
>> some vendor specific patches, but most of them
>> are the same as standard kernel.
>>
>> We encounter a problem occasionally, that I'm trying to resolve it.
>> But while I used 'ps' to get process information,
>> the new launched ps print out nothing and can't exit, ^C doesn't work.
>> I find out its pid under /proc, and it's in RUNNING
>> state:
>> # cat status
>> Name:   ps
>> State:  R (running)
>> Tgid:   1298
>> Pid:    1298
>> PPid:   1
>> TracerPid:      0
>> Uid:    0       0       0       0
>> Gid:    0       0       0       0
>> FDSize: 64
>> Groups: 0 1 2 3 4 6 10 489
>> VmPeak:     3776 kB
>> VmSize:     3712 kB
>> VmLck:         0 kB
>> VmHWM:      2624 kB
>> VmRSS:      2624 kB
>> VmData:      832 kB
>> VmStk:       256 kB
>> VmExe:       192 kB
>> VmLib:      2176 kB
>> VmPTE:         6 kB
>> VmSwap:        0 kB
>> Threads:        1
>> SigQ:   7/8113
>> SigPnd: 0000000000000100
>> ShdPnd: 00000000000a0103
>> SigBlk: 0000000000000000
>> SigIgn: 0000000000000004
>> SigCgt: 0000000073d3fef9
>> CapInh: 0000000000000000
>> CapPrm: ffffffffffffffff
>> CapEff: ffffffffffffffff
>> CapBnd: ffffffffffffffff
>> Cpus_allowed:   f,ffffffff
>> Cpus_allowed_list:      0-35
>> Mems_allowed:   3
>> Mems_allowed_list:      0-1
>> voluntary_ctxt_switches:        1
>> nonvoluntary_ctxt_switches:     0
>>
>> And it can't be killed even using SIGKILL.
>>
>> Since it's under *RUNNING* status, its stack can't be dumped. Is there
>> any exist mechanism can be used to
>> get it stack, or other information, to help me figure out what's the
>> cause of ps pend on *RUNNING*?
>>
> My answer may be silly, but did you tried running with strace?
>
>>
>> System information:
>> # uname -a
>> Linux localhost 2.6.38.8-MDE-4.0.0.141101 #7 SMP Fri Sep 28 21:46:08
>> CST 2012 tilegx GNU/Linux
>>
>>
>>
>> Best regards.
>>
>> --
>> Cyberman Wu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cyberman Wu
