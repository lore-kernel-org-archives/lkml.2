Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0LWNIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:08:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51407 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab0LWNIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:08:39 -0500
Date: Thu, 23 Dec 2010 14:08:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: buggy perf callgraph output
Message-ID: <20101223130820.GA7680@elte.hu>
References: <20101208164015.GA5444@amd>
 <20101208214809.GG1709@nowhere>
 <20101215130245.GA10004@amd>
 <20101216114755.GA1687@nowhere>
 <20101217053258.GC3282@amd>
 <20101223125535.GA1769@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223125535.GA1769@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Dec 17, 2010 at 04:32:58PM +1100, Nick Piggin wrote:
> > That would be great, thanks! It's a really awesome tool, I appreciate
> > your effort on it.
> 
> Thanks :)
> 
> So the below patch should fix the issue. Tell me if you encounter it
> again, or anything else.
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index d503670..c749ba6 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -356,7 +356,7 @@ static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
>  
>  static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
>  				     int depth, int depth_mask, int period,
> -				     u64 total_samples, int hits,
> +				     u64 total_samples, u64 hits,
>  				     int left_margin)

Hmm ... nice fix but why didnt GCC warn about the loss of half of the 'cumul' bits 
in this call:

                        ret += ipchain__fprintf_graph(fp, chain, depth,
                                                      new_depth_mask, i++,
                                                      new_total,
                                                      cumul,
                                                      left_margin);

We really, really want GCC to warn about this - it's such a common mistake. What 
disabled that warning? Very weird.

Thanks,

	Ingo
