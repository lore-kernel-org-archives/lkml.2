Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2HOK1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:27:35 -0400
Received: from mail.x86-64.org ([217.9.48.20]:42857 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab2HOK1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:27:30 -0400
Date: Wed, 15 Aug 2012 12:27:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
Message-ID: <20120815102722.GB4640@aftab.osrc.amd.com>
References: <1344864055.6935.117.camel@gandalf.stny.rr.com>
 <20120813132438.GA18990@aftab.osrc.amd.com>
 <1344867782.6935.119.camel@gandalf.stny.rr.com>
 <20120813142909.GC18990@aftab.osrc.amd.com>
 <20120813180249.GB6840@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813180249.GB6840@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:02:49PM -0300, Arnaldo Carvalho de Melo wrote:
> [acme@sandy linux]$ rm -rf ../build/perf
> [acme@sandy linux]$ make -j8 -C tools/perf/ LIBUNWIND_DIR=/opt/libunwind O=/home/acme/git/build/perf install
> /bin/sh: line 0: cd: /home/acme/git/build/perf: No such file or directory
> make: Entering directory `/home/git/linux/tools/perf'
>     GEN perf-archive
>     GEN /home/git/linux/tools/perf/python/perf.so
> make[1]: Entering directory `/home/git/linux/tools/lib/traceevent'
> make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
>     * new build flags or cross compiler
>     CC /home/git/linux/tools/perf/perf.o
>     CC /home/git/linux/tools/perf/builtin-annotate.o
>     CC /home/git/linux/tools/perf/builtin-bench.o
>     CC /home/git/linux/tools/perf/bench/sched-messaging.o
>     CC /home/git/linux/tools/perf/bench/sched-pipe.o
> 
> I.e. it should stop if the O= provided directory is not there.

Why stop? Don't we want to make the directory instead and continue
building in there?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
