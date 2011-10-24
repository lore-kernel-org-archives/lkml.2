Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab1JXODe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:03:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46564 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab1JXODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:03:33 -0400
Date: Mon, 24 Oct 2011 12:03:28 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Deng-Cheng Zhu <dczhu@mips.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/2] tools/perf: Make group_fd static and move its
 place in __perf_evsel__open()
Message-ID: <20111024140328.GA5770@ghostprotocols.net>
References: <1319453820-12992-1-git-send-email-dczhu@mips.com>
 <1319453820-12992-3-git-send-email-dczhu@mips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319453820-12992-3-git-send-email-dczhu@mips.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 24, 2011 at 06:57:00PM +0800, Deng-Cheng Zhu escreveu:
> __perf_evsel__open() is called per event, it does not work for all the
> grouped events at one time. So, currently group_fd will alway be -1 for
> the events in a group. This patch fixes it.
> 
> Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> ---
>  tools/perf/util/evsel.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index e389815..7bd0d9d 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -219,9 +219,8 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>  	}
>  
>  	for (cpu = 0; cpu < cpus->nr; cpu++) {
> -		int group_fd = -1;
> -
>  		for (thread = 0; thread < threads->nr; thread++) {
> +			static int group_fd = -1;
>  
>  			if (!evsel->cgrp)
>  				pid = threads->map[thread];

Lets not do it that way, using statics for this is humm, ugly, IMHO.

Just pass an integer pointer that is a member of perf_evlist, I'll work
on a patch now.

Thanks for reporting the bug tho! 

- Arnaldo
