Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2JHUuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:50:18 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:43058 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2JHUuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:50:12 -0400
Date: Mon, 8 Oct 2012 13:50:06 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v3 4/8] perf tools: configure tmp path at build time
Message-ID: <20121008205006.GH2631@ghostprotocols.net>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
 <1349678613-7045-5-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349678613-7045-5-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 08, 2012 at 09:43:29AM +0300, Irina Tirdea escreveu:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> Temporary perf files are hardcoded to point to /tmp. Android does not have
> a /tmp directory so it needs to set this path at compile time.
> 
> Add a compile-time definition (PERF_TMP_DIR) in the Makefile that sets the path
> to temp directory. By default it points to /tmp.


[acme@sandy linux]$ am /wb/1.patch 
Applying: perf tools: configure tmp path at build time
[perf/core eafbb72] perf tools: configure tmp path at build time
 Author: Irina Tirdea <irina.tirdea@intel.com>
 9 files changed, 39 insertions(+), 9 deletions(-)
[acme@sandy linux]$ make -j8 -C tools/perf/ LIBUNWIND_DIR=/opt/libunwind O=/home/acme/git/build/perf install
make: Entering directory `/home/git/linux/tools/perf'
PERF_VERSION = 3.6.rc5.371.geafbb7
make: Leaving directory `/home/git/linux/tools/perf'
make: Entering directory `/home/git/linux/tools/perf'
make: *** No rule to make target `/home/acme/git/build/perf/util/pmu.c', needed by `/home/acme/git/build/perf/util/pmu.o'.  Stop.
make: *** Waiting for unfinished jobs....
make: Leaving directory `/home/git/linux/tools/perf'


Remove this patch:

[acme@sandy linux]$ git reset --hard HEAD^
HEAD is now at 7747e2f Documentation: add documentation on compiling for Android

And it works again, dropping,

- Arnaldo

[acme@sandy linux]$ make -j8 -C tools/perf/ LIBUNWIND_DIR=/opt/libunwind O=/home/acme/git/build/perf install
make: Entering directory `/home/git/linux/tools/perf'
PERF_VERSION = 3.6.rc5.370.g7747e2
make: Leaving directory `/home/git/linux/tools/perf'
make: Entering directory `/home/git/linux/tools/perf'
    GEN perf-archive
make[1]: Entering directory `/home/git/linux/tools/lib/traceevent'
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
make[1]: Leaving directory `/home/git/linux/tools/lib/traceevent'
    CC /home/acme/git/build/perf/perf.o
    CC /home/acme/git/build/perf/util/pmu.o
    CC /home/acme/git/build/perf/util/symbol.o
    CC /home/acme/git/build/perf/util/dso-test-data.o
    CC /home/acme/git/build/perf/util/trace-event-info.o
    CC /home/acme/git/build/perf/util/map.o
    AR /home/acme/git/build/perf/libperf.a
    LINK /home/acme/git/build/perf/perf
install -d -m 755 '/home/acme/bin'
install /home/acme/git/build/perf/perf '/home/acme/bin'
install -d -m 755 '/home/acme/libexec/perf-core/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
install -d -m 755 '/home/acme/libexec/perf-core/scripts/perl/bin'
install /home/acme/git/build/perf/perf-archive -t '/home/acme/libexec/perf-core'
install scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '/home/acme/libexec/perf-core/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
install scripts/perl/*.pl -t '/home/acme/libexec/perf-core/scripts/perl'
install scripts/perl/bin/* -t '/home/acme/libexec/perf-core/scripts/perl/bin'
install -d -m 755 '/home/acme/libexec/perf-core/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
install -d -m 755 '/home/acme/libexec/perf-core/scripts/python/bin'
install scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '/home/acme/libexec/perf-core/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
install scripts/python/*.py -t '/home/acme/libexec/perf-core/scripts/python'
install scripts/python/bin/* -t '/home/acme/libexec/perf-core/scripts/python/bin'
install -d -m 755 '/home/acme/etc/bash_completion.d'
install bash_completion '/home/acme/etc/bash_completion.d/perf'
make: Leaving directory `/home/git/linux/tools/perf'
[acme@sandy linux]$
