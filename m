Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0JOOLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:11:49 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:57113 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab0JOOLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:11:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALf7t0x5Ld+3/2dsb2JhbAChIXK/D4VJBI9K
Date: Sat, 16 Oct 2010 01:11:41 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015141141.GA4359@amd>
References: <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
 <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
 <20101015105943.GE32255@dastard>
 <20101015130259.GA3207@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015130259.GA3207@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 12:03:00AM +1100, Nick Piggin wrote:
> On Fri, Oct 15, 2010 at 09:59:43PM +1100, Dave Chinner wrote:
> > On Fri, Oct 15, 2010 at 05:41:50PM +1100, Nick Piggin wrote:
> > > - inode io lists and locking made per-bdi
> > 
> > And I've pulled that in done that, too while dropping all the messy
> > list manipulation loops as the wrong bdi problem is fixed upstream now.
> > 
> > Nothing I've done prevents RCU-ising the inode cache, but I've
> > discovered some issues that you've missed in moving straight to
> > fine-grained per-zone LRU lists and locking. I think the code is
> > cleaner (no trylocks or loops to get locks out of order), the series
> > is cleaner and it has gone through a couple of rounds of review
> > already.  This is why I'd like you to try rebasing your tree on top
> > of it to determine if my assertions that there are no inhernet
> > problems are correct....
> 
> You have it upside down, I think. I've got way more work sitting
> here that has been tested and in my opinion has the better set
> of steps to transform the locking.

I mean, come on. You've done 2 _whole_ weeks of work on this,
(how many hours of testing, how many workloads, what sizes of
machines? google? intel? people who are actually reporting real
world problems?) and you want _me_ to rebase my entire tree on
some bits of yours that I don't even entirely agree with, and you
want me to tell you if you've stuffed anything up and that I
should go away and retest the whole stack and ask everyone else
to redo their testing results again? 

What do you want here? Do you think it's actually going to give
some results more quickly to go through with that?

