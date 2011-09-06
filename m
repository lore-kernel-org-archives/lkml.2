Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1IFX1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:27:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab1IFX1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:27:45 -0400
Date: Wed, 7 Sep 2011 01:27:38 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/18] writeback: per task dirty rate limit
Message-ID: <20110906232738.GC31945@quack.suse.cz>
References: <20110904015305.367445271@intel.com>
 <20110904020915.240747479@intel.com>
 <1315324030.14232.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315324030.14232.14.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-09-11 17:47:10, Peter Zijlstra wrote:
> On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> >  /*
> > + * After a task dirtied this many pages, balance_dirty_pages_ratelimited_nr()
> > + * will look to see if it needs to start dirty throttling.
> > + *
> > + * If dirty_poll_interval is too low, big NUMA machines will call the expensive
> > + * global_page_state() too often. So scale it near-sqrt to the safety margin
> > + * (the number of pages we may dirty without exceeding the dirty limits).
> > + */
> > +static unsigned long dirty_poll_interval(unsigned long dirty,
> > +                                        unsigned long thresh)
> > +{
> > +       if (thresh > dirty)
> > +               return 1UL << (ilog2(thresh - dirty) >> 1);
> > +
> > +       return 1;
> > +}
> 
> Where does that sqrt come from? 
  He does 2^{log_2(x)/2} which, if done in real numbers arithmetics, would
result in x^{1/2}. Given the integer arithmetics, it might be twice as
small but still it's some approximation...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
