Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab1LFNpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:45:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55226 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab1LFNpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:45:44 -0500
Date: Tue, 6 Dec 2011 11:45:26 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-perf-users@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        devel@openvz.org, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Arun Sharma <asharma@fb.com>
Subject: Re: [Devel] [PATCH 0/7] Profiling sleep times (v3)
Message-ID: <20111206134526.GB10709@infradead.org>
References: <1322471015-107825-1-git-send-email-avagin@openvz.org>
 <4EDDC0FB.6080005@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDDC0FB.6080005@openvz.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 11:15:07AM +0400, Andrey Vagin escreveu:
> Hello Arnaldo,
> 
> I found, that you commit patches for perf. Could you review this part?
> 
> Arun Sharma said, that the second versions of patches works ok for him.
> (Arun is the first user of this functionality after me.)

I'm going to check if the patches still apply and then review,

- Arnaldo
 
> Thanks.
> 
> On 11/28/2011 01:03 PM, Andrew Vagin wrote:
> >Do you want to know where your code waits locks for a long time?
> >Yes! It's for you. This feature helps you to find bottlenecks.
> >
> >It's not artificial task. Once one of my colleague was investigating a
> >scalability problem. He pressed sysrq-t some times and tried to merge
> >call-chains by hand. But perf can do that.
> >
> >Problem:
> >The problem is that events sched_stat_* contain call-chains of
> >non-target tasks.
> >About month ago I sent series of patches:
> >
> >[PATCH 0/3] trace: add ability to collect call chains of non current task.
> >
> >Peter and Frederic explained me, that this solve isn't good and will be
> >better to make it in userspace.
> >
> >Now it's in userspace. This series expands "perf inject" to be able to
> >merge sched_switch events and sched_stat* events. sched_switch events
> >contain correct call-chains and sched_stat contains a correct time
> >slices.
> >
> >v2:
> >* Removed all known issues. Now it works completely.
> >* Improved usability of sched-stat scripts according with Arun's comments.
> >v3: fixed accoding to comments from David Ahem
> >
> >Andrew Vagin (7):
> >   perf: use event_name() to get an event name
> >   perf: add ability to record event period
> >   perf: add ability to change event according to sample (v2)
> >   perf: teach "perf inject" to work with files
> >   perf: teach perf inject to merge sched_stat_* and sched_switch events
> >   perf: add scripts for profiling sleep times (v2)
> >   event: add tracepoint for accounting block time
> >
> >  include/trace/events/sched.h                    |    7 ++
> >  kernel/sched_fair.c                             |    2 +
> >  tools/perf/builtin-inject.c                     |  120 ++++++++++++++++++++++-
> >  tools/perf/builtin-record.c                     |    5 +
> >  tools/perf/scripts/python/bin/sched-stat-record |   65 ++++++++++++
> >  tools/perf/scripts/python/bin/sched-stat-report |    5 +
> >  tools/perf/util/event.h                         |    2 +
> >  tools/perf/util/evsel.c                         |   74 ++++++++++++++
> >  tools/perf/util/header.c                        |    2 +-
> >  tools/perf/util/session.h                       |    9 ++
> >  10 files changed, 288 insertions(+), 3 deletions(-)
> >  create mode 100644 tools/perf/scripts/python/bin/sched-stat-record
> >  create mode 100644 tools/perf/scripts/python/bin/sched-stat-report
> >
> >_______________________________________________
> >Devel mailing list
> >Devel@openvz.org
> >https://openvz.org/mailman/listinfo/devel
