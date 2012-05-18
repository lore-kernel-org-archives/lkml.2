Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2EROmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:42:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab2EROmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:42:31 -0400
Date: Fri, 18 May 2012 16:42:17 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] lib: Proportions with flexible period
Message-ID: <20120518144217.GC6875@quack.suse.cz>
References: <1337096583-6049-1-git-send-email-jack@suse.cz>
 <1337096583-6049-2-git-send-email-jack@suse.cz>
 <1337291805.4281.97.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337291805.4281.97.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-05-12 23:56:45, Peter Zijlstra wrote:
> On Tue, 2012-05-15 at 17:43 +0200, Jan Kara wrote:
> > +void fprop_fraction_percpu(struct fprop_global *p,
> > +                          struct fprop_local_percpu *pl,
> > +                          unsigned long *numerator, unsigned long *denominator)
> > +{
> > +       unsigned int seq;
> > +       s64 den;
> > +
> > +       do {
> > +               seq = read_seqcount_begin(&p->sequence);
> > +               fprop_reflect_period_percpu(p, pl);
> > +               *numerator = percpu_counter_read_positive(&pl->events);
> > +               den = percpu_counter_read(&p->events);
> > +               if (den <= 0)
> > +                       den = percpu_counter_sum(&p->events);
> > +               *denominator = den;
> > +       } while (read_seqcount_retry(&p->sequence, seq));
> > +} 
> 
> 
> why not use percpu_counter_read_positive(&p->events) and ditch
> percpu_counter_sum()? That sum can be terribly expensive..
  Yes. I'm actually not sure why I used the _sum here... Thanks for
spotting this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
