Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2DFLgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:36:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56000 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab2DFLgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:36:20 -0400
Date: Fri, 6 Apr 2012 13:36:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/15] perf: Separate out trace-cmd parse-events from
 perf files
Message-ID: <20120406113615.GB30425@liondog.tnic>
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
 <1333666086-6517-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333666086-6517-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 12:47:52AM +0200, Frederic Weisbecker wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Move the trace-event-parse.c code that originally came from trace-cmd into
> their own files. The new file will be called trace-parse-events.c, as
> the name of trace-cmd's file was parse-events.c too, but it conflicted
> with the parse-events.c file in perf that parses the command line.
> 
> This tries to update the code with mimimal changes.
> 
> Perf specific code stays in the trace-event-parse.[ch] files and
> the common parsing code is now in trace-parse-events.c and
> trace-parse-events.h.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/perf/Makefile                  |    2 +
>  tools/perf/util/trace-event-parse.c  | 3135 ----------------------------------
>  tools/perf/util/trace-event.h        |  275 +---
>  tools/perf/util/trace-parse-events.c | 3125 +++++++++++++++++++++++++++++++++
>  tools/perf/util/trace-parse-events.h |  273 +++
>  5 files changed, 3405 insertions(+), 3405 deletions(-)
>  create mode 100644 tools/perf/util/trace-parse-events.c
>  create mode 100644 tools/perf/util/trace-parse-events.h

Err, maybe I'm missing something but why this additional step? I mean,
you could do:

patch 1: Add libtraceevent.a from trace-cmd
patch 2: Fixup perf so that it is ready to be switched to the new lib (specific
		wrappers, etc)
patch 3: switch it to libtraceevent.a

Only three patches, right?

-- 
Regards/Gruss,
    Boris.
