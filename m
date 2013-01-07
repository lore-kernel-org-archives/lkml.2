Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3AGNJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:09:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab3AGNI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:08:59 -0500
Date: Mon, 7 Jan 2013 14:08:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v4 14/18] perf tools: add new mem command for memory
 access profiling
Message-ID: <20130107130840.GD963@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
 <1356018108-6081-15-git-send-email-eranian@google.com>
 <20130102141601.GD931@krava.brq.redhat.com>
 <CABPqkBSwvhKyyYWb+EAWmoVDLscNMydfxpAtLTFcZ8622Ydt7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSwvhKyyYWb+EAWmoVDLscNMydfxpAtLTFcZ8622Ydt7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 02:04:58PM +0100, Stephane Eranian wrote:
> On Wed, Jan 2, 2013 at 3:16 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Thu, Dec 20, 2012 at 04:41:44PM +0100, Stephane Eranian wrote:
> >> This new command is a wrapper on top of perf record and
> >> perf report to make it easier to configure for memory
> >> access profiling.
> >>
> >> To record loads:
> >> $ perf mem -t load rec .....
> >>
> >> To record stores:
> >> $ perf mem -t store rec .....
> >>
> >> To get the report:
> >> $ perf mem -t load rep
> >
> > I get following segfault occasionally:
> >
> >   $ perf mem -t load rec ls
> >   $ perf mem -t load rep --stdio
> >     Failed to open /etc/ld.so.cache, continuing without symbols
> >     Segmentation fault
> >   $ gdb ./perf
> >   GNU gdb (GDB) Fedora (7.4.50.20120120-52.fc17)
> >   Copyright (C) 2012 Free Software Foundation, Inc.
> >   License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> >   This is free software: you are free to change and redistribute it.
> >   There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> >   and "show warranty" for details.
> >   This GDB was configured as "x86_64-redhat-linux-gnu".
> >   For bug reporting instructions, please see:
> >   <http://www.gnu.org/software/gdb/bugs/>...
> >   Reading symbols from /home/jolsa/kernel/tip-local/tools/perf/perf...done.
> >   (gdb) r  mem -t load rep --stdio
> >   Starting program: /home/jolsa/kernel/tip-local/tools/perf/perf mem -t load rep --stdio
> >   [Thread debugging using libthread_db enabled]
> >   Using host libthread_db library "/lib64/libthread_db.so.1".
> >   Detaching after fork from child process 3130.
> >   Failed to open /etc/ld.so.cache, continuing without symbols
> >
> Can't reproduce this problem on my 3.8.0-rc1 patch series kernel, but
> then I am not
> using the same distro as you. Is your bin/ls statically linked and stripped?

[jolsa@dhcp-26-214 ~]$ file /bin/ls
/bin/ls: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, stripped
[jolsa@dhcp-26-214 ~]$ ldd /bin/ls
/usr/bin/ldd: line 163: /lib/ld-linux.so.2: cannot execute binary file
        linux-vdso.so.1 =>  (0x00007fff499ff000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f0eebdc1000)
        librt.so.1 => /lib64/librt.so.1 (0x00007f0eebbb9000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007f0eeb9b4000)
        libacl.so.1 => /lib64/libacl.so.1 (0x00007f0eeb7ac000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f0eeb3f4000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f0eeb1ef000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f0eebff5000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f0eeafd3000)
        libattr.so.1 => /lib64/libattr.so.1 (0x00007f0eeadcf000)
[jolsa@dhcp-26-214 ~]$ cat /etc/fedora-release 
Fedora release 16 (Verne)

I planed to look on it if I dont hear from you ;-) I'll check and let you know

jirka
