Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2DFPXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:23:08 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47654 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2DFPXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120406113615.GB30425@liondog.tnic>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	<1333666086-6517-2-git-send-email-fweisbec@gmail.com>
	<20120406113615.GB30425@liondog.tnic>
Date: Fri, 6 Apr 2012 17:23:05 +0200
Message-ID: <CAFTL4hy_n_9nXFeYv+okW6Z4LUMcaigN0iNaDMTtrFPznEatJw@mail.gmail.com>
Subject: Re: [PATCH 01/15] perf: Separate out trace-cmd parse-events from perf files
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/6 Borislav Petkov <bp@alien8.de>:
> On Fri, Apr 06, 2012 at 12:47:52AM +0200, Frederic Weisbecker wrote:
>> From: Steven Rostedt <srostedt@redhat.com>
>>
>> Move the trace-event-parse.c code that originally came from trace-cmd into
>> their own files. The new file will be called trace-parse-events.c, as
>> the name of trace-cmd's file was parse-events.c too, but it conflicted
>> with the parse-events.c file in perf that parses the command line.
>>
>> This tries to update the code with mimimal changes.
>>
>> Perf specific code stays in the trace-event-parse.[ch] files and
>> the common parsing code is now in trace-parse-events.c and
>> trace-parse-events.h.
>>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Arun Sharma <asharma@fb.com>
>> Cc: Namhyung Kim <namhyung.kim@lge.com>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  tools/perf/Makefile                  |    2 +
>>  tools/perf/util/trace-event-parse.c  | 3135 ----------------------------------
>>  tools/perf/util/trace-event.h        |  275 +---
>>  tools/perf/util/trace-parse-events.c | 3125 +++++++++++++++++++++++++++++++++
>>  tools/perf/util/trace-parse-events.h |  273 +++
>>  5 files changed, 3405 insertions(+), 3405 deletions(-)
>>  create mode 100644 tools/perf/util/trace-parse-events.c
>>  create mode 100644 tools/perf/util/trace-parse-events.h
>
> Err, maybe I'm missing something but why this additional step? I mean,
> you could do:
>
> patch 1: Add libtraceevent.a from trace-cmd
> patch 2: Fixup perf so that it is ready to be switched to the new lib (specific
>                wrappers, etc)
> patch 3: switch it to libtraceevent.a
>
> Only three patches, right?

Because this step splits what is purely perf code and what isn't. Then
later on we remove the non-perf part only.
I think it makes it smoother that way: we first identify what we want
to delete and layout the things in advance
by separating it. It makes the removal easier to review.
