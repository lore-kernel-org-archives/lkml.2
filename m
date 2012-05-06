Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2EFSHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 14:07:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42294 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab2EFSHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 14:07:13 -0400
Date: Sun, 6 May 2012 15:07:07 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf top: Fix a race in callchain handling
Message-ID: <20120506180707.GA2485@infradead.org>
References: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
 <1336242167.2463.138.camel@laptop>
 <20120505235319.GB2150@infradead.org>
 <1336271107.1534.12.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336271107.1534.12.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2012-05-05 (토), 20:53 -0300, Arnaldo Carvalho de Melo:
> > First testing Namhyung patch with -F 100000 tho :-)

Program received signal SIGSEGV, Segmentation fault.
0x000000000046a51a in machine__resolve_callchain (self=0x982b20, evsel=0x982440, thread=0x993210, chain=0x7ffff18462d8, parent=0x7fffffffd6f8) at util/session.c:307
307				ip = chain->ips[i];
(gdb) bt
#0  0x000000000046a51a in machine__resolve_callchain (self=0x982b20, evsel=0x982440, thread=0x993210, chain=0x7ffff18462d8, parent=0x7fffffffd6f8) at util/session.c:307
#1  0x000000000042b9d2 in perf_event__process_sample (tool=0x7fffffffd8a0, event=0x7ffff18462b8, evsel=0x982440, sample=0x7fffffffd750, machine=0x982b20) at builtin-top.c:777
#2  0x000000000042bd17 in perf_top__mmap_read_idx (top=0x7fffffffd8a0, idx=0) at builtin-top.c:858
#3  0x000000000042bdfc in perf_top__mmap_read (top=0x7fffffffd8a0) at builtin-top.c:873
#4  0x000000000042c45f in __cmd_top (top=0x7fffffffd8a0) at builtin-top.c:1033
#5  0x000000000042d514 in cmd_top (argc=0, argv=0x7fffffffe630, prefix=0x0) at builtin-top.c:1323
#6  0x00000000004142c9 in run_builtin (p=0x78a7c8, argc=4, argv=0x7fffffffe630) at perf.c:273
#7  0x00000000004144cc in handle_internal_command (argc=4, argv=0x7fffffffe630) at perf.c:345
#8  0x0000000000414618 in run_argv (argcp=0x7fffffffe51c, argv=0x7fffffffe510) at perf.c:389
#9  0x000000000041489e in main (argc=4, argv=0x7fffffffe630) at perf.c:487
(gdb) p i
$1 = 12477348
(gdb) p *chain
$2 = {nr = 9007199254740994, ips = 0x7ffff18462d8}
(gdb) frame 2
#2  0x000000000042bd17 in perf_top__mmap_read_idx (top=0x7fffffffd8a0, idx=0) at builtin-top.c:858
858				perf_event__process_sample(&top->tool, event, evsel,
(gdb) print event->header
$3 = {type = 4175878766, misc = 16327, size = 0}
(gdb) print event->header
$4 = {type = 4175878766, misc = 16327, size = 0}
(gdb)

Probably an additional bug :-\

- Arnaldo
