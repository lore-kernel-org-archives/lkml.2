Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1BDKMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:12:02 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:35439 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab1BDKL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:11:57 -0500
Date: Fri, 4 Feb 2011 12:11:55 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc3 regression on parisc: segfaults
In-Reply-To: <20110203022420.A73F54E7B@hiauly1.hia.nrc.ca>
Message-ID: <alpine.SOC.1.00.1102041150390.8218@math.ut.ee>
References: <20110203022420.A73F54E7B@hiauly1.hia.nrc.ca>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If aptitude fails consistently, it should be possible to debug or
> isolate to a particular kernel change.  Usually, SMP segvs don't
> provide much information as to the cause of the problem.  strace
> output and a gdb backtrace would be useful.

strace works but does not tell much to me:

2349  _newselect(1, [0], NULL, NULL, {0, 0}) = 0 (Timeout)
2349  rt_sigaction(SIGTSTP, {0x40664bea, [RT_1 RT_4 RT_5 RT_7 RT_11 RT_12 RT_15 RT_16 RT_18 RT_26], SA_RESTART}, NULL, 8) = 0
2349  futex(0x458e0858, FUTEX_WAKE_OP_PRIVATE, 1, 1, 0x458e0850, {FUTEX_OP_SET, 0, FUTEX_OP_CMP_GT, 1}) = -1 ENOSYS (Function not implemented)
2349  futex(0x458e0858, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
2363  <... futex resumed> )             = 0
2363  futex(0x458e0850, FUTEX_WAIT_PRIVATE, 2, NULL <unfinished ...>
2349  <... futex resumed> )             = 1
2349  futex(0x458e0850, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
2363  <... futex resumed> )             = 0
2363  futex(0x458e0850, FUTEX_WAKE_PRIVATE, 1) = 0
2363  futex(0x458e0820, FUTEX_WAIT_PRIVATE, 2, NULL <unfinished ...>
2349  <... futex resumed> )             = 1
2349  futex(0x458e0820, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
2363  <... futex resumed> )             = 0
2363  futex(0x458e0820, FUTEX_WAKE_PRIVATE, 1) = 0
2363  rename("/var/lib/apt/lists/partial/ftp.ee.debian.org_debian_dists_unstable_main_source_Sources.diff_2011-02-02-0207.41.decomp", "/var/lib/apt/lists/ftp.ee.debian.org_debian_dists_unstable_main_source_Sources.ed") = 0
2363  stat64("/usr/lib/apt/methods/rred", {st_mode=0, st_size=0, ...}) = 0
2363  pipe([26, 28])                    = 0
2363  pipe([30, 31])                    = 0
2363  fcntl64(26, F_SETFD, FD_CLOEXEC)  = 0
2363  fcntl64(28, F_SETFD, FD_CLOEXEC)  = 0
2363  fcntl64(30, F_SETFD, FD_CLOEXEC)  = 0
2363  fcntl64(31, F_SETFD, FD_CLOEXEC)  = 0
2363  clone( <unfinished ...>
2349  <... futex resumed> )             = 1
2363  <... clone resumed> child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x460df4a8) = 2372
2349  --- SIGSEGV (Segmentation fault) @ 0 (0) ---
2372  rt_sigaction(SIGPIPE, {SIG_DFL, [], SA_RESTART},  <unfinished ...>
2349  write(1, "\33[56;1H\33[34h\33[?25h", 18 <unfinished ...>

Something futex-related. Full log temprarilty available at 
http://www.cs.ut.ee/~mroos/aptitude-strace.txt

gdb does not seem to work well:

root@hernes:~# gdb aptitude
GNU gdb (GDB) 7.2-debian
Copyright (C) 2010 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later 
<http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "hppa-linux-gnu".
For bug reporting instructions, please see:<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /usr/bin/aptitude...(no debugging symbols found)...done.
(gdb) run
Starting program: /usr/bin/aptitude
[Thread debugging using libthread_db enabled]
warning: Can't attach LWP 1075813436: No such process
/tmp/buildd/gdb-7.2/gdb/linux-thread-db.c:392: internal-error: thread_get_info_callback: Assertion `inout->thread_info != NULL' failed.
A problem internal to GDB has been detected,
further debugging may prove unreliable.

-- 
Meelis Roos (mroos@linux.ee)
