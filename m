Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0CQKfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:35:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab0CQKfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:35:08 -0400
Date: Wed, 17 Mar 2010 11:34:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 00/10] perf-probe updates - data-structure support,
 etc.
Message-ID: <20100317103450.GJ17146@elte.hu>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=BAYES_00,FS_TIP_DDD autolearn=no SpamAssassin version=3.2.5
	0.1 FS_TIP_DDD             Phrase: subject = tip ddd
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Ingo,
> 
> Here are several updates of perf-probe.
> This updates includes data structure accessing support
> --list option enhancement and --dry-run option support.
> 
> - --dry-run allows users to run perf-probe just for checking
>   that the command works correctly.
> 
> - --list option enhancement allows user to check where the
>   probes are put on (with filename/line number).
> 
> - data structure accessing support allows user to trace
>   the contents of local variables/function parameters.

Very nice! I think tracing a data structure value at a given point in the 
source will be a rather popular feature.

> Long-term TODOs (future features):
>   - Enhance probe-finder to decode call frame instructions.
>   - Support tracing static variables (non global)
>   - Support variable basic types from debuginfo (e.g. char, int, ...)
>   - Support array element (var[N])
>   - Support string/dynamic arrays (*var, var[N..M])
>   - Support the type of return value
>   - Support force type-casting ((type)var)
>   - Support sys_perf_counter_open (for non-root users)
>   - Support dynamic array-indexing (var[var2])
> 
> Miscs:
>   - Better support for probes on modules
>   - More debugger like enhancements(%next, --disasm, etc.)

Sounds good :-)

> Masami Hiramatsu (10):
>       perf probe: Accessing members in data structures
>       perf probe: List probes with line number and file name
>       perf probe: Introduce kprobe_trace_event and perf_probe_event
>       perf probe: Add --dry-run option
>       perf probe: Introduce die_find_child() function
>       perf probe: Rename some die_get_* functions
>       perf probe: Rename session to param
>       perf probe: Move add-probe routine under util/
>       perf probe: Use wrapper functions
>       perf tools: Introduce xzalloc() for detecting out of memory
> 
> 
>  tools/perf/Documentation/perf-probe.txt |    5 
>  tools/perf/builtin-probe.c              |  191 +------
>  tools/perf/util/probe-event.c           |  830 +++++++++++++++++++++++--------
>  tools/perf/util/probe-event.h           |  123 ++++-
>  tools/perf/util/probe-finder.c          |  459 ++++++++++++-----
>  tools/perf/util/probe-finder.h          |   60 +-
>  tools/perf/util/util.h                  |    7 
>  7 files changed, 1115 insertions(+), 560 deletions(-)

Applied, thanks!

	Ingo
