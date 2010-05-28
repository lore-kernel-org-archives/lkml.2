Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab0E1GoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:44:15 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37689 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752391Ab0E1GoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:44:12 -0400
Date: Fri, 28 May 2010 08:43:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100528064356.GA2455@ucw.cz>
References: <20100505202826.GB7450@linux.intel.com>
 <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
 <20100505234755.GI29604@atomide.com>
 <l2ra55d774e1005051656wbf4f3d7cr8cc9de0478e509f1@mail.gmail.com>
 <20100506000552.GJ29604@atomide.com>
 <g2yd6200be21005052116n5dd8708fk33eaf8944379bfc2@mail.gmail.com>
 <20100506170420.GB30928@atomide.com>
 <i2od6200be21005061710mae9a437by90b22f61cbc2ae15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <i2od6200be21005061710mae9a437by90b22f61cbc2ae15@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> >> How often would we retry suspending?
> >> >
> >> > Well based on some timer, the same way the screen blanks? Or five
> >> > seconds of no audio play? So if the suspend fails, then reset whatever
> >> > userspace suspend policy timers.
> >> >
> >> >> If we fail to suspend, don't we have to resume all the drivers that
> >> >> suspended before the one that failed?  (Maybe I'm mistaken here)
> >> >
> >> > Sure, but I guess that should be a rare event that only happens when
> >> > you try to suspend and something interrupts the suspend.
> >> >
> >>
> >> This is not a rare event. For example, the matrix keypad driver blocks
> >> suspend when a key is down so it can scan the matrix.
> >
> > Sure, but how many times per day are you suspending?
> 
> How many times we successfully suspend is irrelevant here. If the
> driver blocks suspend the number of suspend attempts depend on your
> poll frequency.

Actually, this is quite interesting question I'd like answer here:

"Sure, but how many times per day are you suspending?"

I suspect it may be in 1000s, but it would be cool to get better
answer -- so that people knew what we are talking about here.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
