Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2JaGBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:01:49 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57855 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2JaGBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:01:48 -0400
X-AuditID: 9c930197-b7c0bae00000042f-ed-5090beca25f8
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        ming.m.lin@intel.com
Subject: Re: [Patch v1 08/10] perf report: add support for mem access profiling
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-9-git-send-email-eranian@google.com>
Date: Wed, 31 Oct 2012 15:01:45 +0900
In-Reply-To: <1351523752-4215-9-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Mon, 29 Oct 2012 16:15:50 +0100")
Message-ID: <87ehkf5gdy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 16:15:50 +0100, Stephane Eranian wrote:
> This patch adds the --mem-mode option to perf report.
>
> This mode requires a perf.data file created with memory
> access samples.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
[snip]
> +	cost = mi->cost;
> +	if (!cost)
> +		cost = 1;
> +
> +	/*
> +	 * The report shows the percentage of total branches captured
> +	 * and not events sampled. Thus we use a pseudo period of 1.

But cost won't be 1 anymore if PERF_SAMPLE_COST set, right?


> +	 * Only in the newt browser we are doing integrated annotation,
> +	 * so we don't allocated the extra space needed because the stdio
> +	 * code will not use it.

Yes, and gtk too.


> +	 */
> +	he = __hists__add_mem_entry(&evsel->hists, al, parent, mi,
> +				    cost);
> +	if (!he)
> +		return -ENOMEM;
> +
> +	if (sort__has_sym && he->ms.sym && use_browser > 0) {

So I'd rather write 'use_browser == 1' instead of '> 0'.


> +		struct annotation *notes = symbol__annotation(he->ms.sym);
> +
> +		assert(evsel != NULL);
> +
> +		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
> +			goto out;
> +
> +		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
> +		if (err)
> +			goto out;
> +	}
> +
> +	if (sort__has_sym && he->mem_info->daddr.sym && use_browser > 0) {

Ditto.

Thanks,
Namhyung
