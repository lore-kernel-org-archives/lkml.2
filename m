Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2DZGLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:11:18 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46892 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2DZGLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:11:17 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-8e-4f98e6ff6520
From: Namhyung Kim <namhyung.kim@lge.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, eranian@google.com,
        robert.richter@amd.com
Subject: Re: [PATCHv2 0/6] perf, tool: event parsing enhancements/fixes
References: <1335371102-11358-1-git-send-email-jolsa@redhat.com>
Date: Thu, 26 Apr 2012 15:10:21 +0900
In-Reply-To: <1335371102-11358-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 25 Apr 2012 18:24:56 +0200")
Message-ID: <87liljf2gi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 25 Apr 2012 18:24:56 +0200, Jiri Olsa wrote:
> Hi,
> adding some enhancements/fixies for perf event parsing.
>
> v2 changes:
>    - rebased to current tip tree
>    - 2/6 - ommitting pmu tests in case there's no pmu sysfs record

Nice! It bothered me somewhat so I was thinking about fixing it.
I guess we have a same problem on x86 rdpmc test too?

Thanks,
Namhyung


>    - 6/6 - default the pmu event name to raw 0x<perf_event_attr::config>
>
> Attached patches:
>   1/6 perf, tool: Split term type into value type and term type
>   2/6 perf, tool: Move parse event automated tests to separated object
>   3/6 perf, tool: Add support for displaying event parser debug info
>   4/6 perf, tool: Use allocated list for each parsed event
>   5/6 perf, tool: Separate 'mem:' event scanner bits
>   6/6 perf, tool: Add hardcoded name term for pmu events
>
> thanks,
> jirka
> ---
>  tools/perf/Makefile                 |   13 +-
>  tools/perf/builtin-test.c           |  552 +------------------------------
>  tools/perf/util/parse-events-test.c |  625 +++++++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c      |  114 +++++--
>  tools/perf/util/parse-events.h      |   42 ++-
>  tools/perf/util/parse-events.l      |   26 ++-
>  tools/perf/util/parse-events.y      |   93 ++++--
>  tools/perf/util/pmu.c               |   74 +++--
>  8 files changed, 883 insertions(+), 656 deletions(-)
