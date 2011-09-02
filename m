Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1IBRI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:08:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63012 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1IBRIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:08:55 -0400
Date: Sat, 3 Sep 2011 02:08:44 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state
 setting bug in freezer_change_state()
Message-ID: <20110902170844.GJ2752@htj.dyndns.org>
References: <20110831102100.GA2828@mtj.dyndns.org>
 <20110902004231.GF1919@count0.beaverton.ibm.com>
 <20110902165839.GA7478@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902165839.GA7478@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 02, 2011 at 06:58:39PM +0200, Oleg Nesterov wrote:
> > This still doesn't look quite right. If the cgroup is FREEZING it should
> > also call try_to_freeze_cgroup(). I think this is what's needed:
> >
> > 		if (freezer->state == CGROUP_THAWED)
> > 			atomic_inc(&system_freezing_cnt);
> > 		freezer->state = CGROUP_FREEZING;
> > 		retval = try_to_freeze_cgroup(cgroup, freezer);
> 
> This is what I mentioned before, to me this looks like a win.
> 
> Why do we need try_to_freeze_cgroup() in this case? "for safety"
> could actually mean "hide the bug" ;)

I guess it depends on the viewpoint.  A simple analogy would be using
WARN_ON_ONCE() instead of BUG_ON() so that the mode of failure is
softer.  This change isn't likely to make bugs significantly more
difficult to discover so why not?

> But I agree either way. Rafael, I think 1-4 are fine, but I think
> we need the simple 5/4, will send in a minute...

Can you please wait a bit?  The second one was broken (missing unlock)
and I made some small adjustments.  Will repost soon.

Thanks.

-- 
tejun
