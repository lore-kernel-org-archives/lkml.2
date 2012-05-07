Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2EGIOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:14:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35171 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2EGIOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:14:30 -0400
Date: Mon, 7 May 2012 10:14:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 00/15] tools: Unify perf and trace-cmd trace event format
 parsing v3
Message-ID: <20120507081424.GE16608@gmail.com>
References: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> This is essentially a rebase against latest tip:perf/core updates.
> Mostly due to conflicts against the perf Makefile updates.
> 
> I think we all agree that this library needs improvements but these
> should rather be done incrementally. The current perf trace event parsing
> is anyway much backward compared to that library.
> 
> Default target is a static library in tools/libtraceevent/libtraceevent.a
> 
> This can be pulled from:
> 
> git://github.com/fweisbec/tracing.git
> 	perf/parse-events-4

It gives me:

/home/mingo/tip/tools/lib/traceevent/parse-filter.c: In function ‘create_arg_item’:
/home/mingo/tip/tools/lib/traceevent/parse-filter.c:343:9: warning: comparison between ‘enum filter_arg_type’ and ‘enum event_type’ [-Wenum-compare]
/home/mingo/tip/tools/lib/traceevent/parse-filter.c:339:2: warning: case value ‘8’ not in enumerated type ‘enum filter_arg_type’ [-Wswitch]

Had this been in tools/perf/ it would use -Werror already and 
you'd have fixed it, not requiring me to unpull these bits :-/

So can we please make a libevent.so, built sanely within 
tools/perf/lib/ or such and distributed together with perf so 
that the two can never get out of sync?

Thanks,

	Ingo
