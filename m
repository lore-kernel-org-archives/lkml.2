Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0JVAp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:45:58 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:33514 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968Ab0JVApz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:45:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYEAB98wEx5LdoFgWdsb2JhbAChXRYBARYiIr8ahUoE
Date: Fri, 22 Oct 2010 11:45:40 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101022004540.GA5920@amd>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <20101021050422.GP32255@dastard>
 <20101021132034.GB13620@amd>
 <20101021235227.GI12506@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021235227.GI12506@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 10:52:27AM +1100, Dave Chinner wrote:
> On Fri, Oct 22, 2010 at 12:20:34AM +1100, Nick Piggin wrote:
> > It seems we are at an impasse.
> > 
> > It doesn't help that you are ignoring the most important concerns
> > I've been raising with these patches. The locking model and the
> > patch split up. I'd really like not to get deadlocked on this (haha),
> > so please let's try to debate points. I've tried to reply to each
> > point others have questioned me about, whether I agree or not I've
> > given reasons.
> > 
> > So, you know my objections to this approach already... I've got an
> > update on my patchset coming, so I'd like to get some discussion
> > going. I've cut out some of the stuff from mine so we don't get
> > bogged down in boring things like per-zone locking or changing of
> > the hash table data structure.
> 
> No point appealing to me, Nick, it's not me that you have to
> convince. As I've said from the start, all I really care about is
> getting the code into shape that is acceptable to the reviewers.

"The reviewers"? I _am_ a reviewer of your code, and I've made
some points, and you've ignored them.

When you've reviewed my code and had comments, I've responded to
them every time. I might not have agreed, but I tried to give you
answers.

 
> As such, I don't think there is anything _new_ to discuss - I'd
> simply be rehashing the same points I've already made to you over
> the past couple of weeks. That has done nothing to change you mind
> about anything, so it strikes me as a continuing exercise in
> futility.

No you didn't make these points to me over the past couple of weeks.
Specifically, do you agree or disagree about these points:
- introducing new concurrency situations from not having a single lock
  for an inode's icache state is a negative?
- if yes, then what aspect of your locking model justifies and outweighs
  it?
- before the inode_lock is lifted, locking changes should be as simple
  and verifiable as absolutely possible, so that bisection has less
  chance of hitting the inode_lock wall?
- further locking changes making the locking less regular and more
  complex should be done in small steps, after inode_lock is lifted

And I have kept saying I would welcome your idea to reduce i_lock width
in a small incremental patch. I still haven't figured out quite what
is so important that can't be achieved in simpler ways (like rcu, or
using a seperate inode lock).

 
> We have different ways of acheiving the same thing which have their
> pros and cons, and I think that the reviewers of the patch sets are
> aware of this. The reviewers are the people that will make the
> decision on the best way to proceed, and I'll follow their lead
> exactly as I have been since I started this process.

Everybody is a reviewer. You need to be able to defend your work.

 
> So, if you want to continue arguing that your locking model is the
> One True Way, you need to convince the reviewers of the fact, not
> me.

Yes of course I want to continue to argue that, because that is what
my opinion is. What I need from you is to know why you believe yours
is better, that I might concede I was wrong; point out where you are
wrong; or show that one can be extended to have the positive aspects
of another etc.


