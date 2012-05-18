Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2EROZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:25:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2EROY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:24:59 -0400
Date: Fri, 18 May 2012 16:24:43 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] block: Convert BDI proportion calculations to
 flexible proportions
Message-ID: <20120518142443.GA6875@quack.suse.cz>
References: <1337096583-6049-1-git-send-email-jack@suse.cz>
 <1337096583-6049-3-git-send-email-jack@suse.cz>
 <1337292273.4281.101.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337292273.4281.101.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 18-05-12 00:04:33, Peter Zijlstra wrote:
> On Tue, 2012-05-15 at 17:43 +0200, Jan Kara wrote:
> > +static struct timer_list writeout_period_timer =
> > +               TIMER_DEFERRED_INITIALIZER(writeout_period, 0, 0); 
> 
> So the problem with using a deferred timer is that it 'ignores' idle
> time. So if a very busy period is followed by a real quiet period you'd
> expect all the proportions to have aged to 0, but they won't have.
  Ah, I see. Thanks for warning me.

> One way to solve that is to track a jiffies count of the last time the
> timer triggered and compute the missed periods from that and extend
> fprop_new_period() to deal with period increments of more than 1.
  Yeah, that should be easy enough so I'll try it that way since I presume
it's nicer to power usage to use deferred timers if it's reasonably
possible.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
