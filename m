Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab1DZWG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:06:58 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46427 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756552Ab1DZWG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:06:57 -0400
Date: Wed, 27 Apr 2011 00:06:53 +0200
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
Message-ID: <20110426220653.GA29092@elf.ucw.cz>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
 <201104262249.22564.rjw@sisk.pl>
 <20110426211159.GB28033@elf.ucw.cz>
 <201104262336.56347.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104262336.56347.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > It certainly looks a lot like s2ram to the user.
> > 
> > Now, your PC wakes up periodically in s2ram, too; but it is keyboard
> > controller that wakes up, not CPU, so you do not know.
> 
> I seriously doubt it's a keyboard controller in contemporary machines.

> Yes, there are parts of them that don't actually sleep, but that's not
> under OS control.

Ok, so it is called "embedded controller" these days. But you got the
idea.

> > On Zaurus, you do not know, either; nothing visible happens and
> > userspace is shielded from these details.
> 
> If you wake up device drivers, it _is_ visible.  Maybe not to user
> space, but that's a semantic difference.

Just to clarify; not _all_ device drivers need to be woken up. Just
SPI + charger code is enough... and I guess it would be prefered
because spinning up disk just to toggle charger would be nasty.

> > Should user really have to know if battery charger is implemented on
> > keyboard controller or on main cpu before he selects which interface
> > to use?
> 
> Please don't confuse user space with the user.  You can resume all the
> way to user space without turning the backlight on and the user will not
> notice, right?

The user has to type "echo mem > /sys/power/state" :-). And you better
turn him the backlight on, typing blind is bad.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
