Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0LPGCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 01:02:46 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:53096 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab0LPGCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 01:02:45 -0500
Date: Thu, 16 Dec 2010 07:02:36 +0100
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>, Dipankar Sarma <dipankar@in.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rculist: fix borked __list_for_each_rcu() macro
Message-ID: <20101216060236.GB4826@mako-laptop>
References: <1292451072-5095-1-git-send-email-mk@lab.zgora.pl>
 <20101215232005.GB6595@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101215232005.GB6595@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 03:20:05PM -0800, Paul E. McKenney wrote:
> On Wed, Dec 15, 2010 at 11:11:12PM +0100, Mariusz Kozlowski wrote:
> > This restores parentheses blance.
> 
> Good catch, queued!!!
> 
> This does not actually appear to be in use anywhere in the kernel any
> more, so I queued this for 2.6.38 rather than in the 2.6.37 urgent queue.
> So, just out of curiosity, how did you find this one?

Some years ago I wrote a dumb script that walks trees of () and {}.
It catches unbalanced trees. It's dumb enough to fail with #ifdef etc,
but most of the time it does its job. It reaches unreachable code
and unused one too.

> Hmmm...  Maybe we should just delete __list_for_each_rcu.  ;-)
> 
> 							Thanx, Paul
> 
> > Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
> > ---
> >  include/linux/rculist.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > index f31ef61..70d3ba5 100644
> > --- a/include/linux/rculist.h
> > +++ b/include/linux/rculist.h
> > @@ -244,7 +244,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
> >  #define __list_for_each_rcu(pos, head) \
> >  	for (pos = rcu_dereference_raw(list_next_rcu(head)); \
> >  		pos != (head); \
> > -		pos = rcu_dereference_raw(list_next_rcu((pos)))
> > +		pos = rcu_dereference_raw(list_next_rcu(pos)))
> > 
> >  /**
> >   * list_for_each_entry_rcu	-	iterate over rcu list of given type
> > -- 
> > 1.7.0.4
> > 

-- 
Mariusz Kozlowski
