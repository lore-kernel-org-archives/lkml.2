Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1IBRTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:19:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab1IBRTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:19:22 -0400
Date: Fri, 2 Sep 2011 19:15:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state
	setting bug in freezer_change_state()
Message-ID: <20110902171517.GA8247@redhat.com>
References: <20110831102100.GA2828@mtj.dyndns.org> <20110902004231.GF1919@count0.beaverton.ibm.com> <20110902165839.GA7478@redhat.com> <20110902170844.GJ2752@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902170844.GJ2752@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Tejun Heo wrote:
>
> Hello,
>
> On Fri, Sep 02, 2011 at 06:58:39PM +0200, Oleg Nesterov wrote:
> > > This still doesn't look quite right. If the cgroup is FREEZING it should
> > > also call try_to_freeze_cgroup(). I think this is what's needed:
> > >
> > > 		if (freezer->state == CGROUP_THAWED)
> > > 			atomic_inc(&system_freezing_cnt);
> > > 		freezer->state = CGROUP_FREEZING;
> > > 		retval = try_to_freeze_cgroup(cgroup, freezer);
> >
> > This is what I mentioned before, to me this looks like a win.
> >
> > Why do we need try_to_freeze_cgroup() in this case? "for safety"
> > could actually mean "hide the bug" ;)
>
> I guess it depends on the viewpoint.  A simple analogy would be using
> WARN_ON_ONCE() instead of BUG_ON() so that the mode of failure is
> softer.  This change isn't likely to make bugs significantly more
> difficult to discover so why not?

I agree either way.

Personally I prefer your current patch. Because it is not clear why
do we call try_to_freeze_cgroup() if it was already called. And, the
2nd call can silently hide the problem if we have some bug.

But of course, this is up to you and Matt.



> > But I agree either way. Rafael, I think 1-4 are fine, but I think
> > we need the simple 5/4, will send in a minute...
>
> Can you please wait a bit?  The second one was broken (missing unlock)

Yes, I just noticed the small problem too, hopefully we mean the same
bug ;)

Oleg.

