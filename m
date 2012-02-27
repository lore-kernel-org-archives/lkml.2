Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2B0L5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:57:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab2B0L5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:57:09 -0500
Date: Mon, 27 Feb 2012 12:56:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] hw breakpoint: Fix possible memory leak
Message-ID: <20120227115652.GA9943@elte.hu>
References: <1330311739-24302-1-git-send-email-namhyung.kim@lge.com>
 <1330338785.11248.49.camel@twins>
 <20120227104452.GA6082@elte.hu>
 <1330340694.11248.64.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330340694.11248.64.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2012-02-27 at 11:44 +0100, Ingo Molnar wrote:
> > I edited that code earlier today - is the form below OK, or can 
> > you see a simpler method? It's not yet pushed out so can still 
> > edit it. 
> 
> I think something like the below should do, but then I didn't really
> think much about it, my thoughts went like:
> 
> ... *shees* that's ugly
>   ... that error path already does a loop
>     ... what the problem is!? -- reread changelog
>       ... err_cpu == cpu is placed wrong!
> 
> 
> So I replied and marked read.. waiting to either hear if there's a good
> reason to do ugly or find a new (tested) patch in my inbox.. :-)
> 
> ---
>  kernel/events/hw_breakpoint.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index b0309f7..3330022 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -658,10 +658,10 @@ int __init init_hw_breakpoint(void)
>  
>   err_alloc:
>  	for_each_possible_cpu(err_cpu) {
> -		if (err_cpu == cpu)
> -			break;
>  		for (i = 0; i < TYPE_MAX; i++)
>  			kfree(per_cpu(nr_task_bp_pinned[i], cpu));
> +		if (err_cpu == cpu)
> +			break;
>  	}

Looks a lot nicer - I'll wait for an updated patch.

Thanks,

	Ingo
