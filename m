Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab1DZWOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:14:24 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37902 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752904Ab1DZWOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:14:23 -0400
Date: Wed, 27 Apr 2011 00:14:20 +0200
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
Message-ID: <20110426221420.GC29092@elf.ucw.cz>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
 <1303781471-2477-1-git-send-email-myungjoo.ham@samsung.com>
 <201104261347.21811.rjw@sisk.pl>
 <20110426131737.GA13597@suse.de>
 <20110426203853.GC27140@elf.ucw.cz>
 <20110426205745.GB20381@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426205745.GB20381@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > What is the root problem that this is trying to solve?
> > 
> > It is trying to fix machines that need to run periodic kernel tasks
> > even when user asked them to sleep. Zaurus needs to periodicaly wake
> > up to be able to charge battery in s2ram state, for example.
> 
> That sounds like a bug in userspace you are trying to work around.  Why
> not solve it there first?

Can you be more specific?

The userspace is standard Debian; or maybe even init=/bin/bash. I want
to sleep the machine before I move, so I do echo mem >
/sys/power/state, as I do on PC.

Then I do plug the machine into AC when I move near outlet. In PC,
embedded controller wakes up and starts charging. In Zaurus, it is
kernel (SPI+charging drivers) that wake up, start charging, and go
back to sleep.

Then I (the user) press the power button and get "bash#" back. Where
is the userspace bug?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
