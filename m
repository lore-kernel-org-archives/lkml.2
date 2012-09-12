Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2ILBLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:11:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62605 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2ILBLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:11:38 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-c5-504fe147ee66
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 15/18] perf sched: Use perf_tool as ancestor
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
	<1347407590-30960-16-git-send-email-acme@infradead.org>
Date: Wed, 12 Sep 2012 10:04:43 +0900
In-Reply-To: <1347407590-30960-16-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Tue, 11 Sep 2012 20:53:07 -0300")
Message-ID: <87wr009hlg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012 20:53:07 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> So that we can remove all the globals.
>
> Before:
>
>    text	   data	    bss	    dec	    hex	filename
> 1586833	 110368	1438600	3135801	 2fd939	/tmp/oldperf
>
> After:
>
>    text	   data	    bss	    dec	    hex	filename
> 1629329	  93568	 848328	2571225	 273bd9	/root/bin/perf
>

Just a nitpick below.

[snip]
> -static void print_bad_events(void)
> +static void print_bad_events(struct perf_sched *sched)
>  {
> -	if (nr_unordered_timestamps && nr_timestamps) {
> +	if (sched->nr_unordered_timestamps && sched->nr_timestamps) {
>  		printf("  INFO: %.3f%% unordered timestamps (%ld out of %ld)\n",
> -			(double)nr_unordered_timestamps/(double)nr_timestamps*100.0,
> -			nr_unordered_timestamps, nr_timestamps);
> +			(double)sched->nr_unordered_timestamps/(double)sched->nr_timestamps*100.0,

Isn't it sufficient to use this?

			100.0 * sched->nr_unordered_timestamps / sched->nr_timestamps;

Ditto for belows.

Thanks,
Namhyung


> +			sched->nr_unordered_timestamps, sched->nr_timestamps);
>  	}
> -	if (nr_lost_events && nr_events) {
> +	if (sched->nr_lost_events && sched->nr_events) {
>  		printf("  INFO: %.3f%% lost events (%ld out of %ld, in %ld chunks)\n",
> -			(double)nr_lost_events/(double)nr_events*100.0,
> -			nr_lost_events, nr_events, nr_lost_chunks);
> +			(double)sched->nr_lost_events/(double)sched->nr_events * 100.0,
> +			sched->nr_lost_events, sched->nr_events, sched->nr_lost_chunks);
>  	}
> -	if (nr_state_machine_bugs && nr_timestamps) {
> +	if (sched->nr_state_machine_bugs && sched->nr_timestamps) {
>  		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
> -			(double)nr_state_machine_bugs/(double)nr_timestamps*100.0,
> -			nr_state_machine_bugs, nr_timestamps);
> -		if (nr_lost_events)
> +			(double)sched->nr_state_machine_bugs/(double)sched->nr_timestamps*100.0,
> +			sched->nr_state_machine_bugs, sched->nr_timestamps);
> +		if (sched->nr_lost_events)
>  			printf(" (due to lost events?)");
>  		printf("\n");
>  	}
> -	if (nr_context_switch_bugs && nr_timestamps) {
> +	if (sched->nr_context_switch_bugs && sched->nr_timestamps) {
>  		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
> -			(double)nr_context_switch_bugs/(double)nr_timestamps*100.0,
> -			nr_context_switch_bugs, nr_timestamps);
> -		if (nr_lost_events)
> +			(double)sched->nr_context_switch_bugs/(double)sched->nr_timestamps*100.0,
> +			sched->nr_context_switch_bugs, sched->nr_timestamps);
> +		if (sched->nr_lost_events)
>  			printf(" (due to lost events?)");
>  		printf("\n");
>  	}
>  }
