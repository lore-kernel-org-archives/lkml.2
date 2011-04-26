Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab1DZVME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:12:04 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47387 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758342Ab1DZVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:12:02 -0400
Date: Tue, 26 Apr 2011 23:11:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for
 device PM.
Message-ID: <20110426211159.GB28033@elf.ucw.cz>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
 <20110426131737.GA13597@suse.de>
 <20110426203853.GC27140@elf.ucw.cz>
 <201104262249.22564.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104262249.22564.rjw@sisk.pl>
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
> Well, if you wake up periodically, it's not S2RAM any more, I'd say.

It certainly looks a lot like s2ram to the user.

Now, your PC wakes up periodically in s2ram, too; but it is keyboard
controller that wakes up, not CPU, so you do not know.

On Zaurus, you do not know, either; nothing visible happens and
userspace is shielded from these details.

Should user really have to know if battery charger is implemented on
keyboard controller or on main cpu before he selects which interface
to use?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
