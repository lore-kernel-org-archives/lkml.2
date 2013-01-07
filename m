Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3AGNFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:05:01 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:45691 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3AGNFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:05:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130102141601.GD931@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
	<1356018108-6081-15-git-send-email-eranian@google.com>
	<20130102141601.GD931@krava.brq.redhat.com>
Date: Mon, 7 Jan 2013 14:04:58 +0100
Message-ID: <CABPqkBSwvhKyyYWb+EAWmoVDLscNMydfxpAtLTFcZ8622Ydt7w@mail.gmail.com>
Subject: Re: [PATCH v4 14/18] perf tools: add new mem command for memory
 access profiling
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 3:16 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Dec 20, 2012 at 04:41:44PM +0100, Stephane Eranian wrote:
>> This new command is a wrapper on top of perf record and
>> perf report to make it easier to configure for memory
>> access profiling.
>>
>> To record loads:
>> $ perf mem -t load rec .....
>>
>> To record stores:
>> $ perf mem -t store rec .....
>>
>> To get the report:
>> $ perf mem -t load rep
>
> I get following segfault occasionally:
>
>   $ perf mem -t load rec ls
>   $ perf mem -t load rep --stdio
>     Failed to open /etc/ld.so.cache, continuing without symbols
>     Segmentation fault
>   $ gdb ./perf
>   GNU gdb (GDB) Fedora (7.4.50.20120120-52.fc17)
>   Copyright (C) 2012 Free Software Foundation, Inc.
>   License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
>   This is free software: you are free to change and redistribute it.
>   There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
>   and "show warranty" for details.
>   This GDB was configured as "x86_64-redhat-linux-gnu".
>   For bug reporting instructions, please see:
>   <http://www.gnu.org/software/gdb/bugs/>...
>   Reading symbols from /home/jolsa/kernel/tip-local/tools/perf/perf...done.
>   (gdb) r  mem -t load rep --stdio
>   Starting program: /home/jolsa/kernel/tip-local/tools/perf/perf mem -t load rep --stdio
>   [Thread debugging using libthread_db enabled]
>   Using host libthread_db library "/lib64/libthread_db.so.1".
>   Detaching after fork from child process 3130.
>   Failed to open /etc/ld.so.cache, continuing without symbols
>
Can't reproduce this problem on my 3.8.0-rc1 patch series kernel, but
then I am not
using the same distro as you. Is your bin/ls statically linked and stripped?


>   Program received signal SIGSEGV, Segmentation fault.
>   dso__name_len (dso=0x68100142) at util/dso.c:389
>   389             return dso->short_name_len;
>   Missing separate debuginfos, use: debuginfo-install atk-2.4.0-1.fc17.x86_64 audit-libs-2.2.1-1.fc17.x86_64 bzip2-libs-1.0.6-4.fc17.x86_64 cairo-1.10.2-7.fc17.x86_64 elfutils-libelf-0.154-2.fc17.x86_64 elfutils-libs-0.154-2.fc17.x86_64 expat-2.1.0-1.fc17.x86_64 fontconfig-2.8.0-8.fc17.x86_64 freetype-2.4.8-3.fc17.x86_64 gdk-pixbuf2-2.26.1-1.fc17.x86_64 glib2-2.32.4-2.fc17.x86_64 glibc-2.15-58.fc17.x86_64 gtk2-2.24.13-1.fc17.x86_64 libX11-1.5.0-2.fc17.x86_64 libXau-1.0.6-3.fc17.x86_64 libXcomposite-0.4.3-3.fc17.x86_64 libXcursor-1.1.13-1.fc17.x86_64 libXdamage-1.1.3-3.fc17.x86_64 libXext-1.3.1-1.fc17.x86_64 libXfixes-5.0-2.fc17.x86_64 libXi-1.6.1-1.fc17.x86_64 libXinerama-1.1.2-1.fc17.x86_64 libXrandr-1.3.1-3.fc17.x86_64 libXrender-0.9.7-1.fc17.x86_64 libffi-3.0.10-2.fc17.x86_64 libgcc-4.7.2-2.fc17.x86_64 libpng-1.5.10-1.fc17.x86_64 libselinux-2.1.10-3.fc17.x86_64 libunwind-1.0.1-3.fc17.x86_64 libxcb-1.9-1.fc17.x86_64 newt-0.52.14-2.fc17.x86_64 numactl-libs-2.0.7-6.fc17.x86_64 pango-1.30.0-1.fc17.x86_64 pixman-0.24.4-2.fc17.x86_64 python-libs-2.7.3-7.2.fc17.x86_64 slang-2.2.4-3.fc17.x86_64 xz-libs-5.1.2-1alpha.fc17.x86_64 zlib-1.2.5-7.fc17.x86_64
>   (gdb) bt
>   #0  dso__name_len (dso=0x68100142) at util/dso.c:389
>   #1  0x000000000048d8cd in hists__calc_col_len (hists=hists@entry=0x8a1c10, h=h@entry=0xd7de50) at util/hist.c:130
>   #2  0x000000000048dc47 in hists__inc_nr_entries (h=0xd7de50, hists=0x8a1c10) at util/hist.c:285
>   #3  hists__inc_nr_entries (h=0xd7de50, hists=0x8a1c10) at util/hist.c:613
>   #4  __hists__output_resort (hists=hists@entry=0x8a1c10, threaded=threaded@entry=false) at util/hist.c:639
>   #5  0x000000000048e2de in hists__output_resort (hists=hists@entry=0x8a1c10) at util/hist.c:645
>   #6  0x0000000000436240 in __cmd_report (rep=0x7fffffffd330) at builtin-report.c:521
>   #7  cmd_report (argc=<optimized out>, argv=argv@entry=0x89fd10, prefix=prefix@entry=0x0) at builtin-report.c:888
>   #8  0x0000000000449e30 in report_events (mem=0x7fffffffde90, argv=0x7fffffffe4a0, argc=<optimized out>) at builtin-mem.c:182
>   #9  cmd_mem (argc=<optimized out>, argv=0x7fffffffe4a0, prefix=<optimized out>) at builtin-mem.c:233
>   #10 0x00000000004191d3 in run_builtin (p=p@entry=0x7bf768, argc=argc@entry=5, argv=argv@entry=0x7fffffffe4a0) at perf.c:319
>   #11 0x0000000000418976 in handle_internal_command (argv=0x7fffffffe4a0, argc=5) at perf.c:367
>   #12 run_argv (argv=0x7fffffffe290, argcp=0x7fffffffe29c) at perf.c:411
>   #13 main (argc=5, argv=0x7fffffffe4a0) at perf.c:513
>
>
> jirka
