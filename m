Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab0E0Pkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:40:49 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35767 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755034Ab0E0Pkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:40:47 -0400
Date: Thu, 27 May 2010 17:41:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Florian Mickler <florian@mickler.org>, Arve Hj??nnev??g <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100527154152.GF1957@elf.ucw.cz>
References: <1273810273-3039-1-git-send-email-arve@android.com>
 <20100520111111.333beb73@schatten.dmk.lab>
 <20100520112642.74d93d26@schatten.dmk.lab>
 <201005210018.43576.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005210018.43576.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Yeah, one file selects behavior of another file, and to read available
> > > > states for opportunistic, you have to write to file first.
> > > > 
> > > > I still don't like the interface.
> > > > 
> > > 
> > > Actually, what would be a better interface? 
> > > 
> > > I wonder why it is not like this:
> 
> Because I think the "forced" and "opportunistic" suspend "modes" are mutually
> exclusive in practice and the interface as proposed reflects that quite well.

Why should they be? Forced disk while opportunistic mem is active
makes a lot of sense. If code can't support it now, just return
-EINVAL, but please don't cripple the interface just because of that.

> > > /sys/power/state 
> > > 	no change, works with and without opportunistic suspend the
> > > 	same. Ignores suspend blockers. Really no change. (From user
> > > 	perspective)
> > > 
> > > /sys/power/opportunistic
> > > 	On / Off
> > > 	While Off the opportunistic suspend is off.
> > > 	While On, the opportunistic suspend is on and if there are no
> > > 	suspend blockers the system goes to suspend. 
> > > 
> > 
> > I forgot, of course there needs to be another knob to implement the
> > "on" behaviour  in the opportunistic mode
> > 
> >  /sys/power/block_opportunistic_suspend
> > 
> > There you have it. One file, one purpose. 
> 
> That's getting messy IMHO.
> 
> In addition to that you get a nice race when the user writes "mem"
> to /sys/power/state and opportunistic suspend happens at the same
> time.

It should not opportunistically suspend when it has work to do (like
entering forced suspend).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
