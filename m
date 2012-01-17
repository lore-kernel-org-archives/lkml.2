Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2AQJvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:51:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57818 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2AQJvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:51:08 -0500
Date: Tue, 17 Jan 2012 10:50:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Update scheduler stat documentation.
Message-ID: <20120117095056.GF10397@elte.hu>
References: <1326389222.9115.2.camel@localhost.localdomain>
 <20120116075639.GG15641@elte.hu>
 <CADZ9YHjxuqJ2YpEonqXjRsJZGsihy7ao_cA-NRwXoOM1KF3Tpw@mail.gmail.com>
 <20120116083615.GB23622@elte.hu>
 <CADZ9YHh9rnTom8dRk5PBdY0Qu6WQVNpUr2jJDeyqg7fxTiu1gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHh9rnTom8dRk5PBdY0Qu6WQVNpUr2jJDeyqg7fxTiu1gg@mail.gmail.com>
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


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> On Mon, Jan 16, 2012 at 2:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >
> > Yes - but we should also change it to export a value of zero.
> > The field is a legacy 'array expirations' field, and as such it
> > should be zero.
> >
> 
> Ok, thanks for suggestions. Please, look at the following patch, it's
> been roughly created to address your suggestion. If it looks okay,
> then I can send formal patch (perhaps two separate patches?). In this
> way, I think we can also remove rq->sched_switch field (not done in
> this patch)?
> 
> diff --git a/Documentation/scheduler/sched-stats.txt
> b/Documentation/scheduler/sched-stats.txt
> index 1cd5d51..cc2d107 100644
> --- a/Documentation/scheduler/sched-stats.txt
> +++ b/Documentation/scheduler/sched-stats.txt
> @@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
>       1) # of times sched_yield() was called
> 
>  Next three are schedule() statistics:
> -     2) # of times we switched to the expired queue and reused it
> +     2) This field is a legacy array expiration field used in O(1) scheduler.
> +	But still kept for ABI integrity.

I'd formulate it like this:

> +     2) This field is a legacy array expiration count field
> +        used in the O(1) scheduler. We kept it for ABI
> +        compatibility, but it is always set to zero.


> +		int rq_sched_switch = 0;
>  #ifdef CONFIG_SMP
>  		struct sched_domain *sd;
>  		int dcount = 0;
> @@ -34,7 +35,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  		seq_printf(seq,
>  		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
>  		    cpu, rq->yld_count,
> -		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
> +		    rq_sched_switch, rq->sched_count, rq->sched_goidle,

printf can print a 0 value just fine as part of the format 
string ... :-)

But yeah, this logic is what i had in mind.

Thanks,

	Ingo
