Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab0K3TWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:22:30 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59966 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756266Ab0K3TW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:22:29 -0500
Date: Tue, 30 Nov 2010 20:22:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Marcus Meissner <meissner@suse.de>, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/time: Make /proc/timer_list mode 0400
Message-ID: <20101130192223.GE5295@ucw.cz>
References: <20101117170822.GW20727@suse.de>
 <1290014312.2109.1065.camel@laptop>
 <20101117123039.d975aa70.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1011172137040.2900@localhost6.localdomain6>
 <20101118081241.GA23481@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118081241.GA23481@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > iirc powertop parses this..
> > > 
> > > I bet it doesn't look at the kernel address (why was that added in the
> > > first place, anyway?)
> > > 
> > > I'd suggest that the risk of breakage would be much less if we left the
> > > file permissions alone and arranged for those addresses to be
> > > 0000000000000000 for non-root readers.
> > 
> > You beat me to it. Having the full information is quite helpful at
> > times.
> 
> We should do something like:
> 
> 	if (!capable(CAP_SYS_ADMIN))
> 		print_ptr = NULL;
> 
> 	sprintf(s, "%p", print_ptr);

Having single file that contains different stuff based on capable() is
very very ugly.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
