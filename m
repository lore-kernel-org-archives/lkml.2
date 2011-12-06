Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1LFOCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:02:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:51010 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1LFOCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:02:16 -0500
Date: Tue, 6 Dec 2011 12:02:03 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu, asharma@fb.com, devel@openvz.org, dsahern@gmail.com,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 2/7] perf: add ability to record event period
Message-ID: <20111206140203.GC10709@infradead.org>
References: <1322471015-107825-1-git-send-email-avagin@openvz.org>
 <1322471015-107825-3-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322471015-107825-3-git-send-email-avagin@openvz.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 28, 2011 at 12:03:30PM +0300, Andrew Vagin escreveu:
> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> ---
>  tools/perf/builtin-record.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

This patch doesn't apply in current tip/perf/core as this logic was
moved to perf_evsel/perf_evlist, so that it can be used by other tools.

Please add the 'period' variable to struct perf_record_opts and the
sample_type or'ing to perf_evsel__config().

I suggest you use https://github.com/acmel/linux/commits/perf/core for
that.

- Arnaldo
 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 6ab58cc..e3b7fc4 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -62,6 +62,7 @@ static bool			no_samples			=  false;
>  static bool			sample_address			=  false;
>  static bool			sample_time			=  false;
>  static bool			no_buildid			=  false;
> +static bool			period				=  false;
>  static bool			no_buildid_cache		=  false;
>  static struct perf_evlist	*evsel_list;
>  
> @@ -185,6 +186,9 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
>  	if (evlist->nr_entries > 1)
>  		attr->sample_type |= PERF_SAMPLE_ID;
>  
> +	if (period)
> +		attr->sample_type |= PERF_SAMPLE_PERIOD;
> +
>  	/*
>  	 * We default some events to a 1 default interval. But keep
>  	 * it a weak assumption overridable by the user.
> @@ -803,6 +807,7 @@ const struct option record_options[] = {
>  	OPT_BOOLEAN('d', "data", &sample_address,
>  		    "Sample addresses"),
>  	OPT_BOOLEAN('T', "timestamp", &sample_time, "Sample timestamps"),
> +	OPT_BOOLEAN('P', "period", &period, "Sample period"),
>  	OPT_BOOLEAN('n', "no-samples", &no_samples,
>  		    "don't sample"),
>  	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid_cache,
> -- 
> 1.7.1
