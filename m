Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab1DZUi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:38:57 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43791 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754901Ab1DZUi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:38:56 -0400
Date: Tue, 26 Apr 2011 22:38:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for
 device PM.
Message-ID: <20110426203853.GC27140@elf.ucw.cz>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
 <1303781471-2477-1-git-send-email-myungjoo.ham@samsung.com>
 <201104261347.21811.rjw@sisk.pl>
 <20110426131737.GA13597@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426131737.GA13597@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > To conclude, I'm not sure about the approach.  In particular, I'm not sure
> > if the benefit is worth the effort and the resulting complications (ie. the
> > possibility of having to deal with wakeup signals not requested by user
> > space) seem to be a bit too far reaching.
> > 
> > Greg, what do you think?
> 
> I agree with you in that I don't think that this type of feature is
> valid at the moment.

Our current "solution" is low level suspend code on Zaurus directly
looking at charger state and doing the "wakeup or not" decision by hand. 

> I don't understand why our current situation doesn't work, what are we
> lacking that is needed for these systems that we have not seen
> before?

It works, but it is ugly; and it seems samsung now needs similar
hacks.

> What is the root problem that this is trying to solve?

It is trying to fix machines that need to run periodic kernel tasks
even when user asked them to sleep. Zaurus needs to periodicaly wake
up to be able to charge battery in s2ram state, for example.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
