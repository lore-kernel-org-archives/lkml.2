Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1LFHPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:15:48 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:44160 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1LFHPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:15:48 -0500
Message-ID: <4EDDC0FB.6080005@openvz.org>
Date: Tue, 06 Dec 2011 11:15:07 +0400
From: Andrey Vagin <avagin@openvz.org>
Reply-To: avagin@openvz.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-perf-users@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        devel@openvz.org, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Arun Sharma <asharma@fb.com>
Subject: Re: [Devel] [PATCH 0/7] Profiling sleep times (v3)
References: <1322471015-107825-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1322471015-107825-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnaldo,

I found, that you commit patches for perf. Could you review this part?

Arun Sharma said, that the second versions of patches works ok for him.
(Arun is the first user of this functionality after me.)

Thanks.

On 11/28/2011 01:03 PM, Andrew Vagin wrote:
> Do you want to know where your code waits locks for a long time?
> Yes! It's for you. This feature helps you to find bottlenecks.
>
> It's not artificial task. Once one of my colleague was investigating a
> scalability problem. He pressed sysrq-t some times and tried to merge
> call-chains by hand. But perf can do that.
>
> Problem:
> The problem is that events sched_stat_* contain call-chains of
> non-target tasks.
> About month ago I sent series of patches:
>
> [PATCH 0/3] trace: add ability to collect call chains of non current task.
>
> Peter and Frederic explained me, that this solve isn't good and will be
> better to make it in userspace.
>
> Now it's in userspace. This series expands "perf inject" to be able to
> merge sched_switch events and sched_stat* events. sched_switch events
> contain correct call-chains and sched_stat contains a correct time
> slices.
>
> v2:
> * Removed all known issues. Now it works completely.
> * Improved usability of sched-stat scripts according with Arun's comments.
> v3: fixed accoding to comments from David Ahem
>
> Andrew Vagin (7):
>    perf: use event_name() to get an event name
>    perf: add ability to record event period
>    perf: add ability to change event according to sample (v2)
>    perf: teach "perf inject" to work with files
>    perf: teach perf inject to merge sched_stat_* and sched_switch events
>    perf: add scripts for profiling sleep times (v2)
>    event: add tracepoint for accounting block time
>
>   include/trace/events/sched.h                    |    7 ++
>   kernel/sched_fair.c                             |    2 +
>   tools/perf/builtin-inject.c                     |  120 ++++++++++++++++++++++-
>   tools/perf/builtin-record.c                     |    5 +
>   tools/perf/scripts/python/bin/sched-stat-record |   65 ++++++++++++
>   tools/perf/scripts/python/bin/sched-stat-report |    5 +
>   tools/perf/util/event.h                         |    2 +
>   tools/perf/util/evsel.c                         |   74 ++++++++++++++
>   tools/perf/util/header.c                        |    2 +-
>   tools/perf/util/session.h                       |    9 ++
>   10 files changed, 288 insertions(+), 3 deletions(-)
>   create mode 100644 tools/perf/scripts/python/bin/sched-stat-record
>   create mode 100644 tools/perf/scripts/python/bin/sched-stat-report
>
> _______________________________________________
> Devel mailing list
> Devel@openvz.org
> https://openvz.org/mailman/listinfo/devel

