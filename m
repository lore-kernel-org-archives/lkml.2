Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2I1GEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:04:21 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64686 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2I1GEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:04:12 -0400
X-AuditID: 9c93016f-b7b1eae000000815-61-50653ddbd43f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 03/14] perf hists: Separate overhead and baseline columns
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
	<1348744175-11115-4-git-send-email-jolsa@redhat.com>
Date: Fri, 28 Sep 2012 14:56:01 +0900
In-Reply-To: <1348744175-11115-4-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 27 Sep 2012 13:09:24 +0200")
Message-ID: <87zk4au1vy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 13:09:24 +0200, Jiri Olsa wrote:
> Currently the overhead and baseline columns are handled within
> single function and the distinction is made by 'baseline hists'
> pointer passed by 'struct perf_hpp::ptr'.
>
> Since hists pointer is now part of each hist_entry, it's possible
> to locate paired hists pointer directly from the passed struct
> hist_entry pointer.
>
> Also separating those 2 columns makes the code more obvious.

Yes, it was thinking about something like this.


>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
[snip]
> +static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
> +{
> +	double percent = baseline_percent(he);
> +
> +	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);

Is it possible to have a baseline value over 100%?  I changed 'overhead'
colum format from '2 spaces + %5.2f + %' to '1 space + %6.2f + %' for
the case.  Probably it'd better using it here too for consistency.


> +}
> +
> +static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
> +{
> +	double percent = baseline_percent(he);
> +	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%%";

Ditto.

Thanks,
Namhyung

> +
> +	return scnprintf(hpp->buf, hpp->size, fmt, percent);
> +}
> +
