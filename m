Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2DFLsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:48:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33147 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356Ab2DFLsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:48:16 -0400
Date: Fri, 6 Apr 2012 13:48:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 04/15] events: Update tools/lib/traceevent to work with
 perf
Message-ID: <20120406114812.GE30425@liondog.tnic>
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
 <1333666086-6517-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333666086-6517-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 12:47:55AM +0200, Frederic Weisbecker wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Some of the util functions of libtraceevent.a conflict with perf,
> such as die(), warning() and others. Move them into event-util.h

Minor: judging by the patch below, you mean "event-utils.h" here.

> that is not included by the perf tools.
> 
> Also, as perf compiles with 'bool' the filter_arg->bool needs to
> be renamed to filter_arg->boolean.
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
>  tools/lib/traceevent/event-parse.c  |    1 +
>  tools/lib/traceevent/event-parse.h  |   20 +++-----------------
>  tools/lib/traceevent/event-utils.h  |   16 ++++++++++++++++
>  tools/lib/traceevent/parse-filter.c |   32 ++++++++++++++++----------------
>  tools/lib/traceevent/trace-seq.c    |    1 +
>  5 files changed, 37 insertions(+), 33 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 47a3227..3ce75b5 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -33,6 +33,7 @@
>  #include <errno.h>
>  
>  #include "event-parse.h"
> +#include "event-utils.h"

	     ^^^^^^^^^^^^^

-- 
Regards/Gruss,
    Boris.
