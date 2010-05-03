Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0ECTBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:01:49 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44320 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755617Ab0ECTBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:01:48 -0400
Date: Mon, 3 May 2010 21:01:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve Hj??nnev??g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100503190136.GA4173@ucw.cz>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <201005022210.54018.rjw@sisk.pl>
 <20100502205238.GC9051@elf.ucw.cz>
 <201005022329.48309.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005022329.48309.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > As I explained before (and got no reply),  the proposed interface is
> > > > ugly. It uses one sysfs file to change semantics of another one.
> > > 
> > > In fact this behavior was discussed at the LF Collab Summit and no one
> > > involved had any problem with that.
> > 
> > Well, I explained why I disliked in previous mail in more details,
> 
> We do exactly the same thing with 'pm_test', so I'm not sure what the problem is.
> 
> > and neither you nor Arve explained why it is good solution.
> 
> Because it's less confusing.  Having two different attributes returning
> almost the same contents and working in a slightly different way wouldn't be
> too clean IMO.

No, I don't think it is similar to pm_test. pm_test is debug-only, and
orthogonal to state -- all combinations make sense.

With 'oportunistic > policy', state changes from blocking to
nonblocking (surprise!). Plus, it is not orthogonal:

(assume we added s-t-flash on android for powersaving... or imagine I
get oportunistic suspend working on PC --I was there with limited
config on x60).

policy: oportunistic forced

state: on mem disk

First disadvantage of proposed interface is that while 'opportunistic
mem' is active, I can't do 'forced disk' to save bit more power.

Next, not all combinations make sense.

oportunistic on == forced <nothing>

oportunistic disk -- probably something that will not be implemented
any time soon.

oportunistic mem -- makes sense.

forced on -- NOP

forced mem  -- makes sense.

forced disk -- makes sense.

So we have matrix of 7 possibilities, but only 4 make sense... IMO its confusing.



								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
