Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2CHHXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:23:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2CHHXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:23:13 -0500
Date: Thu, 8 Mar 2012 08:22:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 2/2] perf: Add a new sort order: SORT_INCLUSIVE
Message-ID: <20120308072258.GB20784@elte.hu>
References: <1331160079-13821-1-git-send-email-asharma@fb.com>
 <1331160079-13821-3-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331160079-13821-3-git-send-email-asharma@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arun Sharma <asharma@fb.com> wrote:

> @@ -71,8 +71,12 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
>  	}
>  
>  	cursor = &evsel->hists.callchain_cursor;
> -	he = __hists__add_entry_single(&evsel->hists, al, parent,
> -				       cursor, sample->period);
> +	if (sort__first_dimension == SORT_INCLUSIVE)
> +		he = __hists__add_entry_inclusive(&evsel->hists, al, parent,
> +						  cursor, sample->period);
> +	else
> +		he = __hists__add_entry_single(&evsel->hists, al, parent,
> +					       cursor, sample->period);

If sort__first_dimension is available to hist.c then I think 
there should still be a simple __hists__add_entry() function in 
hist.c, which perf_evsel__add_hist_entry() calls - which then 
calls the static inline __hists__add_entry_inclusive() and 
__hists__add_entry_single() functions within hist.c.

I.e. this refactoring and splitup of the function into two parts 
is not a detail that should matter to builtin-report.c's 
perf_evsel__add_hist_entry().

Thanks,

	Ingo
