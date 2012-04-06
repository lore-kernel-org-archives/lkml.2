Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2DFPvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:51:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50075 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab2DFPvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:51:14 -0400
Date: Fri, 6 Apr 2012 17:51:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 03/15] perf: Build libtraceevent.a
Message-ID: <20120406155109.GA2693@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <srostedt@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
	Namhyung Kim <namhyung.kim@lge.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <1333666086-6517-4-git-send-email-fweisbec@gmail.com>
 <20120406114502.GD30425@liondog.tnic>
 <CAFTL4hzvy1wgm8e7_h2S6Fa_A+QybUsssetLaWyUu3tB5a2m1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFTL4hzvy1wgm8e7_h2S6Fa_A+QybUsssetLaWyUu3tB5a2m1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 05:26:35PM +0200, Frederic Weisbecker wrote:
> 2012/4/6 Borislav Petkov <bp@alien8.de>:
> > On Fri, Apr 06, 2012 at 12:47:54AM +0200, Frederic Weisbecker wrote:
> >> From: Steven Rostedt <srostedt@redhat.com>
> >>
> >> Have building perf also build libtraceevent.a. Currently, perf does
> >> not use the code within libtraceevent.a, but it soon will.
> >>
> >> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >> Cc: Ingo Molnar <mingo@kernel.org>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> >> Cc: Steven Rostedt <rostedt@goodmis.org>
> >> Cc: Borislav Petkov <bp@alien8.de>
> >> Cc: Jiri Olsa <jolsa@redhat.com>
> >> Cc: Arun Sharma <asharma@fb.com>
> >> Cc: Namhyung Kim <namhyung.kim@lge.com>
> >> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> >> ---
> >>  tools/perf/Makefile |   11 ++++++++++-
> >>  1 files changed, 10 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> >> index 6f93a99..8e60e51 100644
> >> --- a/tools/perf/Makefile
> >> +++ b/tools/perf/Makefile
> >> @@ -1,5 +1,6 @@
> >>  ifeq ("$(origin O)", "command line")
> >>       OUTPUT := $(O)/
> >> +     COMMAND_O := O=$(O)
> >>  endif
> >>
> >>  # The default target of this Makefile is...
> >> @@ -211,6 +212,9 @@ $(OUTPUT)python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
> >>
> >>  SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
> >>
> >> +EVENT_PARSE_DIR = ../lib/traceevent/
> >> +LIBTRACEEVENT = $(OUTPUT)$(EVENT_PARSE_DIR)libtraceevent.a
> >> +
> >>  #
> >>  # Single 'perf' binary right now:
> >>  #
> >> @@ -335,6 +339,7 @@ LIB_H += util/cpumap.h
> >>  LIB_H += util/top.h
> >>  LIB_H += $(ARCH_INCLUDE)
> >>  LIB_H += util/cgroup.h
> >> +LIB_H += $(EVENT_PARSE_DIR)event-parse.h
> >>
> >>  LIB_OBJS += $(OUTPUT)util/abspath.o
> >>  LIB_OBJS += $(OUTPUT)util/alias.o
> >> @@ -741,7 +746,7 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
> >>               '-DPERF_HTML_PATH="$(htmldir_SQ)"' \
> >>               $(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
> >>
> >> -$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
> >> +$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS) $(LIBTRACEEVENT)
> >>       $(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
> >>                 $(BUILTIN_OBJS) $(LIBS) -o $@
> >>
> >> @@ -847,6 +852,10 @@ $(sort $(dir $(DIRECTORY_DEPS))):
> >>  $(LIB_FILE): $(LIB_OBJS)
> >>       $(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
> >>
> >> +# libparsevent.a
> >> +$(LIBTRACEEVENT):
> >> +     make -C $(EVENT_PARSE_DIR) $(COMMAND_O) libtraceevent.a
> >> +
> >
> > With a toplevel Makefile in tools/, this should be made into its own
> > target residing in tools/lib/traceevent/Makefile and a perf build should
> > be dependent on it instead of adding a perf-specific libtraceevent
> > target here.
> 
> Not sure what you mean. The libtraceevent makefile is standalone and
> perf is dependant on it.
> What am I missing?

Right, what I meant was to add the $(LIBTRACEEVENT): target above to the
toplevel Makefile so that when you're in the kernel source tree, you do

$ make tools/perf

it has a target $(LIBTRACEEVENT) dependent on it in the toplevel
Makefile instead of perf's Makefile to avoid duplication. Then, when
perf is rebuilt, it simply links with this lib. IOW, not have the "make
-C" call in perf's Makefile but in the toplevel Makefile because other
tools will want to use libtraceevent.a too and link against it.

Oh well, the toplevel Makefile patches aren't upstream either so we're
wasting cycles here, I'll fix that up when the times comes.

Thanks.

-- 
Regards/Gruss,
Boris.
