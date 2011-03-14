Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab1CNTXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:23:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:50238 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1CNTXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:23:18 -0400
Date: Mon, 14 Mar 2011 16:23:03 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf lock: fix sorting by wait_min
Message-ID: <20110314192303.GB9388@ghostprotocols.net>
References: <20110222174715.GC9687@joi.lan> <20110314165458.GA2693@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314165458.GA2693@joi.lan>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 14, 2011 at 05:54:58PM +0100, Marcin Slusarz escreveu:
> On Tue, Feb 22, 2011 at 06:47:15PM +0100, Marcin Slusarz wrote:
> > if lock was uncontended, wait_time_min == ULLONG_MAX, so we need to handle
> > this case differently to show high wait times first
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > ---
> >  tools/perf/builtin-lock.c |   13 ++++++++++++-
> >  1 files changed, 12 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> > index 0305a40..812ad26 100644
> > --- a/tools/perf/builtin-lock.c
> > +++ b/tools/perf/builtin-lock.c
> > @@ -202,9 +202,20 @@ static struct thread_stat *thread_stat_findnew_first(u32 tid)
> >  SINGLE_KEY(nr_acquired)
> >  SINGLE_KEY(nr_contended)
> >  SINGLE_KEY(wait_time_total)
> > -SINGLE_KEY(wait_time_min)
> >  SINGLE_KEY(wait_time_max)
> >  
> > +static int lock_stat_key_wait_time_min(struct lock_stat *one,
> > +					struct lock_stat *two)
> > +{
> > +	u64 s1 = one->wait_time_min;
> > +	u64 s2 = two->wait_time_min;
> > +	if (s1 == ULLONG_MAX)
> > +		s1 = 0;
> > +	if (s2 == ULLONG_MAX)
> > +		s2 = 0;
> > +	return s1 > s2;
> > +}
> > +
> >  struct lock_key {
> >  	/*
> >  	 * name: the value for specify by user
> > -- 
> 
> Anything wrong with this patch?
> I can't find it in linux-next.

Hitoshi-san, can I have your acked-by for this one?

Thanks,

- Arnaldo
