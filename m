Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2LRPjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:39:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab2LRPjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:39:33 -0500
Date: Tue, 18 Dec 2012 16:39:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 06/14] perf hists: Resort hist entries using group
 members for output
Message-ID: <20121218153922.GM1283@krava.brq.redhat.com>
References: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
 <1355726345-29553-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355726345-29553-7-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 03:38:57PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>

SNIP

> +static int hist_entry__sort_on_period(struct hist_entry *a,
> +				      struct hist_entry *b)
> +{
> +	int ret;
> +	int i, nr_members;
> +	struct perf_evsel *evsel;
> +	struct hist_entry *pair;
> +	u64 *periods_a, *periods_b;
> +
> +	ret = period_cmp(a->stat.period, b->stat.period);
> +	if (ret || !symbol_conf.event_group)
> +		return ret;
> +
> +	evsel = hists_to_evsel(a->hists);
> +	nr_members = evsel->nr_members;
> +	if (nr_members <= 1)
> +		return ret;
> +
> +	periods_a = zalloc(sizeof(periods_a) * nr_members);
> +	periods_b = zalloc(sizeof(periods_b) * nr_members);

alloca might be more convenient, but not necessary I guess

but as this place would be changed if (when) I send the
patch for linking hist_entries via array.. I'm ok ;-)

Acked-by: Jiri Olsa <jolsa@redhat.com>
