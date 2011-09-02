Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1IBRbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:31:36 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56678 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab1IBRbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:31:35 -0400
Date: Sat, 3 Sep 2011 02:31:27 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state
 setting bug in freezer_change_state()
Message-ID: <20110902173127.GA3083@htj.dyndns.org>
References: <20110831102100.GA2828@mtj.dyndns.org>
 <20110902004231.GF1919@count0.beaverton.ibm.com>
 <20110902165839.GA7478@redhat.com>
 <20110902170844.GJ2752@htj.dyndns.org>
 <20110902171517.GA8247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902171517.GA8247@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 02, 2011 at 07:15:17PM +0200, Oleg Nesterov wrote:
> > I guess it depends on the viewpoint.  A simple analogy would be using
> > WARN_ON_ONCE() instead of BUG_ON() so that the mode of failure is
> > softer.  This change isn't likely to make bugs significantly more
> > difficult to discover so why not?
> 
> I agree either way.
> 
> Personally I prefer your current patch. Because it is not clear why
> do we call try_to_freeze_cgroup() if it was already called. And, the
> 2nd call can silently hide the problem if we have some bug.
> 
> But of course, this is up to you and Matt.

I'm okay either way too.  It would make a bug in that area a bit less
annoying and thus may decrease the chance of bug report, but it means
that we ship with built-in easy work around (if it doesn't work at the
first kick, kick again), which can be beneficial in practice.

> > > But I agree either way. Rafael, I think 1-4 are fine, but I think
> > > we need the simple 5/4, will send in a minute...
> >
> > Can you please wait a bit?  The second one was broken (missing unlock)
> 
> Yes, I just noticed the small problem too, hopefully we mean the same
> bug ;)

Yeap, the same one.  I thought it was the second patch instead of the
third. :)

Thanks.

-- 
tejun
