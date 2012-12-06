Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946098Ab2LFQxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:53:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422960Ab2LFQxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:53:33 -0500
Date: Thu, 6 Dec 2012 17:53:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/5] perf hists: Exchange order of comparing items when
 collapsing hists
Message-ID: <20121206165325.GE1080@krava.brq.redhat.com>
References: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
 <1354806581-5316-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354806581-5316-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 12:09:38AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> When comparing entries for collapsing put the given entry first, and
> then the iterated entry.  This is not the case of hist_entry__cmp()
> when called if given sort keys don't require collapsing.  So change
> the order for the sake of consistency.  It will be required for
> matching and/or linking multiple hist entries.

As discussed with Arnadlo, this change seems like changing the
sort order... could you ellaborate how it is usefull in future?

thanks,
jirka

> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/hist.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 82df1b26f0d4..d4471c21ed17 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -285,7 +285,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
>  		parent = *p;
>  		he = rb_entry(parent, struct hist_entry, rb_node_in);
>  
> -		cmp = hist_entry__cmp(entry, he);
> +		cmp = hist_entry__cmp(he, entry);
>  
>  		if (!cmp) {
>  			he_stat__add_period(&he->stat, period);
> @@ -729,7 +729,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
>  		parent = *p;
>  		he = rb_entry(parent, struct hist_entry, rb_node);
>  
> -		cmp = hist_entry__cmp(pair, he);
> +		cmp = hist_entry__cmp(he, pair);
>  
>  		if (!cmp)
>  			goto out;
> @@ -759,7 +759,7 @@ static struct hist_entry *hists__find_entry(struct hists *hists,
>  
>  	while (n) {
>  		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
> -		int64_t cmp = hist_entry__cmp(he, iter);
> +		int64_t cmp = hist_entry__cmp(iter, he);
>  
>  		if (cmp < 0)
>  			n = n->rb_left;
> -- 
> 1.7.9.2
> 
