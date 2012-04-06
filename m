Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2DFLYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:24:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46327 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab2DFLYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:24:47 -0400
Date: Fri, 6 Apr 2012 13:24:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 08/15] perf/events: Correct size given to memset
Message-ID: <20120406112441.GA30425@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
	Namhyung Kim <namhyung.kim@lge.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <1333666086-6517-9-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333666086-6517-9-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 12:47:59AM +0200, Frederic Weisbecker wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> This is a forward port of commit 5660ce34241ab
> perf tools: Correct size given to memset
> written by Julia Lawall and forward ported by Steven Rostedt.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
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
>  tools/lib/traceevent/event-parse.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index f012395..16da20c 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -2076,7 +2076,7 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
>  			goto out_free;
>  
>  		field = malloc_or_die(sizeof(*field));
> -		memset(field, 0, sizeof(field));
> +		memset(field, 0, sizeof(*field));

This one is already upstream, you can drop it: 5660ce34241ab

-- 
Regards/Gruss,
    Boris.
