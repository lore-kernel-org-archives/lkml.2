Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1LSQ6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:58:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60958 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1LSQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:58:40 -0500
Date: Mon, 19 Dec 2011 17:58:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [RFCv2] ftrace, perf: Adding support to use function trace
Message-ID: <20111219165833.GA1947@somewhere>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
 <20111219134024.GB1606@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219134024.GB1606@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 02:40:24PM +0100, Jiri Olsa wrote:
> hi,
> any feedback?

Sorry for having lost track on this, will have a look soon.

Thanks.

> 
> thanks,
> jirka
> 
> On Mon, Dec 05, 2011 at 06:22:46PM +0100, Jiri Olsa wrote:
> > hi,
> > here's another version of perf support for function trace
> > with filter. The changeset is working and hopefully is not
> > introducing more bugs.. ;) still testing though..
> > 
> > It's still marked RFC since I'm not sure there's better way to go
> > with patches 2 and 10. Also not sure if the condition fixed by
> > patch 7 was not intentional. The rest is fixed/updated version
> > of the v1 changes.
> > 
> > attached patches:
> >  01/10 ftrace: Fix possible NULL dereferencing in __ftrace_hash_rec_update
> >  02/10 ftrace: Change mcount call replacement logic
> >  03/10 ftrace: Add enable/disable ftrace_ops control interface
> >  04/10 ftrace, perf: Add open/close tracepoint perf registration actions
> >  05/10 ftrace, perf: Add add/del tracepoint perf registration actions
> >  06/10 ftrace, perf: Add support to use function tracepoint in perf
> >  07/10 ftrace: Change filter/notrace set functions to return exit code
> >  08/10 ftrace, perf: Distinguish ftrace function event field type
> >  09/10 ftrace, perf: Add filter support for function trace event
> >  10/10 ftrace, graph: Add global_ops filter callback for graph tracing
> > 
> > v2 changes:
> >  01/10 - keeping the old fix instead of adding hash_has_contents func
> >          I'll send separating patchset for this
> >  02/10 - using different way to avoid the issue (3/9 in v1)
> >  03/10 - using the way proposed by Steven for controling ftrace_ops
> >          (4/9 in v1)
> >  06/10 - added check ensuring the ftrace:function event could be used by
> >          root only (7/9 in v1)
> >  08/10 - added more description (8/9 in v1)
> >  09/10 - changed '&&' operator to '||' which seems more suitable
> >          in this case (9/9 in v1)
> > 
> > thanks for comments,
> > jirka
> > ---
> >  include/linux/ftrace.h             |   18 +++-
> >  include/linux/ftrace_event.h       |    9 +-
> >  include/linux/perf_event.h         |    3 +
> >  kernel/trace/ftrace.c              |  202 +++++++++++++++++++++++++++++------
> >  kernel/trace/trace.h               |   11 ++-
> >  kernel/trace/trace_event_perf.c    |  212 +++++++++++++++++++++++++++++-------
> >  kernel/trace/trace_events.c        |   12 ++-
> >  kernel/trace/trace_events_filter.c |  116 ++++++++++++++++++-
> >  kernel/trace/trace_export.c        |   53 ++++++++-
> >  kernel/trace/trace_kprobe.c        |    8 +-
> >  kernel/trace/trace_syscalls.c      |   18 +++-
> >  11 files changed, 562 insertions(+), 100 deletions(-)
