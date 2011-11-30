Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab1K3Loq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:44:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603Ab1K3Loo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:44:44 -0500
Date: Wed, 30 Nov 2011 12:44:38 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/9] readahead: add vfs/readahead tracing event
Message-ID: <20111130114438.GD4541@quack.suse.cz>
References: <20111129130900.628549879@intel.com>
 <20111129131456.797240894@intel.com>
 <20111129152228.GO5635@quack.suse.cz>
 <20111130004235.GB11147@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130004235.GB11147@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-11-11 08:42:35, Wu Fengguang wrote:
> On Tue, Nov 29, 2011 at 11:22:28PM +0800, Jan Kara wrote:
> > On Tue 29-11-11 21:09:07, Wu Fengguang wrote:
> > > This is very useful for verifying whether the readahead algorithms are
> > > working to the expectation.
> > > 
> > > Example output:
> > > 
> > > # echo 1 > /debug/tracing/events/vfs/readahead/enable
> > > # cp test-file /dev/null
> > > # cat /debug/tracing/trace  # trimmed output
> > > readahead-initial(dev=0:15, ino=100177, req=0+2, ra=0+4-2, async=0) = 4
> > > readahead-subsequent(dev=0:15, ino=100177, req=2+2, ra=4+8-8, async=1) = 8
> > > readahead-subsequent(dev=0:15, ino=100177, req=4+2, ra=12+16-16, async=1) = 16
> > > readahead-subsequent(dev=0:15, ino=100177, req=12+2, ra=28+32-32, async=1) = 32
> > > readahead-subsequent(dev=0:15, ino=100177, req=28+2, ra=60+60-60, async=1) = 24
> > > readahead-subsequent(dev=0:15, ino=100177, req=60+2, ra=120+60-60, async=1) = 0
> > > 
> > > CC: Ingo Molnar <mingo@elte.hu>
> > > CC: Jens Axboe <axboe@kernel.dk>
> > > CC: Steven Rostedt <rostedt@goodmis.org>
> > > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Acked-by: Rik van Riel <riel@redhat.com>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> >   Looks OK.
> > 
> >   Acked-by: Jan Kara <jack@suse.cz>
> 
> Thank you.
> 
> > > +	TP_printk("readahead-%s(dev=%d:%d, ino=%lu, "
> > > +		  "req=%lu+%lu, ra=%lu+%d-%d, async=%d) = %d",
> > > +			ra_pattern_names[__entry->pattern],
> > > +			MAJOR(__entry->dev),
> > > +			MINOR(__entry->dev),
> 
> One thing I'm not certain is the dev=MAJOR:MINOR. The other option
> used in many trace events are bdi=BDI_NAME_OR_NUMBER. Will bdi be more
> suitable here?
  Probably bdi name will be more consistent (e.g. with writeback) but I
don't think it makes a big difference in practice.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
