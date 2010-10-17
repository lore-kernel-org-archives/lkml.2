Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab0JQBJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 21:09:49 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:49684 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757164Ab0JQBJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 21:09:47 -0400
Date: Sun, 17 Oct 2010 12:09:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19] fs: Convert nr_inodes and nr_unused to per-cpu
 counters
Message-ID: <20101017010944.GD29677@dastard>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-4-git-send-email-david@fromorbit.com>
 <1287217776.2799.69.camel@edumazet-laptop>
 <20101016100441.GP4681@dastard>
 <1287224852.2799.130.camel@edumazet-laptop>
 <1287250008.1998.123.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287250008.1998.123.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 07:26:48PM +0200, Peter Zijlstra wrote:
> On Sat, 2010-10-16 at 12:27 +0200, Eric Dumazet wrote:
> > 
> > In cases you mention, you want a precise count (aka
> > percpu_counter_sum_positive()), not the approximate one (aka
> > percpu_counter_read_positive()).
> > 
> > The only difference is then the possible/online cpu loop difference.
> > 
> In either case, SGI is screwed, doing millions of for_each_*_cpu() loops
> per second isn't going to work for them.
> 
> fwiw, for_each_*_cpu() takes longer than a single jiffy tick on those
> machines.

Yes, agreed. I'm not sure we need exact summation for these counters,
but I haven't wanted to bring inaccuracies into the code at this
point in time. I need to investigate the effect of using the
approximate summation values in all the cases they are used.

I don't see that there will be a problem doing this, but it's not
something that needs to be cared about right now. After we get to
the store-free path walks in place, we can revisit all these side
issues more fully.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
