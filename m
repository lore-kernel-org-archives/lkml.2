Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1ATLre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:47:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab1ATLrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:47:33 -0500
Date: Thu, 20 Jan 2011 12:47:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Denis Kirjanov <dkirjanov@kernel.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net
Subject: Re: [PATCH] perftools: Fix build error
Message-ID: <20110120114719.GD23661@elte.hu>
References: <20110120093246.GA8031@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120093246.GA8031@hera.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Denis Kirjanov <dkirjanov@kernel.org> wrote:

> Fix perftools build error (ppc64 box) with PERF_VERSION = 2.6.38.rc1.47.g12fcdb
> CC builtin-top.o
> cc1: warnings being treated as errors
> builtin-top.c: In function 'print_sym_table':
> builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'
> 
> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
> ---
>  tools/perf/builtin-top.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 05344c6..8202a2e 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -537,7 +537,7 @@ static void print_sym_table(void)
>  	if (nr_counters == 1 || !display_weighted) {
>  		struct perf_evsel *first;
>  		first = list_entry(evsel_list.next, struct perf_evsel, node);
> -		printf("%Ld", first->attr.sample_period);
> +		printf("%Ld", (unsigned long long)first->attr.sample_period);

Wouldnt %Lu solve this in a cleaner way?

Thanks,

	Ingo
