Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1DGWQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:16:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53747 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754565Ab1DGWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:16:51 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1/sWV5gpBrsedkw/EKeAkSgOFLT/PivA236lblj5N
	G5ncOnFi40NC95
Message-ID: <4D9E38CD.2000006@gmx.de>
Date: Fri, 08 Apr 2011 00:21:01 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.38.x: system hangs, iowait ~75, no resource-hogs, no logs
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there ...

I observed three system hangs since 2.6.38 (two times 2.6.38,
once 2.6.38.2). I have no idea what triggers the problem, I
cannot find the cause myself. I tried these:

top:
~~~~
 - no cpu-hogg, still a bit free RAM, lots of free SWAP
 - iowait is constantly high at ~75%, I don't know why

dmesg, /var/log/*:
~~~~~~~~~~~~~~~~~~
Nothing in 'dmesg', nothing in the logfiles.

pkill / iotop / ps:
~~~~~~~~~~~~~~~~~~~
they all hang quite soon, no reaction on Ctrl-C. While 'ps'
shows some lines of output, 'pkill' and 'iotop' just hang.

vmstat 1:
~~~~~~~~~
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  4     72 421008  54560 326652    0    0     0     0  518 1293 25  9  0 66
 0  4     72 421008  54560 326652    0    0     0     0  311  535 13  4  0 83
 2  4     72 420208  54560 326652    0    0     0     0  450  882 18  9  0 73
 0  4     72 421008  54560 326652    0    0     0     0  377  914 19  5  0 76
(I collected about 90 lines, there's not much to be seen.)

I run 'strace -o dump command' with iotop, ps and su.
(And lost a tty to each of them.)

$ tail dump_*
==> dump_iotop <==
fstat64(9, {st_mode=S_IFREG|0644, st_size=2952, ...}) = 0
mmap2(NULL, 2952, PROT_READ, MAP_SHARED, 9, 0) = 0xb6d80000
_llseek(9, 2952, [2952], SEEK_SET)      = 0
munmap(0xb6d80000, 2952)                = 0
close(9)                                = 0
open("/proc/5904/cmdline", O_RDONLY|O_LARGEFILE) = 9
fstat64(9, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
fstat64(9, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xb6d80000
read(9,
==> dump_ps <==
stat64("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2309, ...}) = 0
stat64("/proc/5904", {st_mode=S_IFDIR|0555, st_size=0, ...}) = 0
open("/proc/5904/stat", O_RDONLY)       = 6
read(6, "5904 (thunderbird-bin) D 5900 58"..., 1023) = 242
close(6)                                = 0
open("/proc/5904/status", O_RDONLY)     = 6
read(6, "Name:\tthunderbird-bin\nState:\tD ("..., 1023) = 836
close(6)                                = 0
open("/proc/5904/cmdline", O_RDONLY)    = 6
read(6,
==> dump_su <==
stat64("/home/tsattler/.pam_environment", 0xbffdb3e0) = -1 ENOENT (No such
file or directory)
access("/usr/bin/xauth", X_OK)          = 0
setuid32(1000)                          = 0
chdir("/home/tsattler")                 = 0
close(3)                                = 0
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
child_tidptr=0xb75f3728) = 25247
rt_sigprocmask(SIG_BLOCK, ~[RTMIN RT_1], NULL, 8) = 0
rt_sigaction(SIGTERM, {0x8049ce0, [], 0}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [ALRM TERM], NULL, 8) = 0
waitpid(-1,

'top' showed constantly increasing sysload, I rebooted
(via Alt-SysRq-[S][U][B]) at a load of about 25-30.

My system is as follows:
~~~~~~~~~~~~~~~~~~~~~~~~
IBM T41p, 1.5GB RAM, 4GB SWAP (nearly unused), two HDs
160/80GB. Gentoo Linux, kernel 2.6.38.2 (vanilla sources).

I compiled the kernel myself. I skipped 2.6.37 but run
2.6.36.3 with sabayon's fourth version of a backport of
sched-automated-per-session-task-groups.patch for more
than two months without any problems.

CPU-Speed is 1700MHz (hardware) but I run the machine
at 1400MHz most of the time as the fans become loud
when running at full speed.

** Please CC: me, as I'm not on the list. **

Thomas

