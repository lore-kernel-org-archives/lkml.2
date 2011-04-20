Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1DTNVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:21:02 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39805 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752227Ab1DTNVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:21:00 -0400
Date: Wed, 20 Apr 2011 12:36:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [RFC PATCH] PM / Core: suspend_again cb for syscore_ops
Message-ID: <20110420103641.GA1789@ucw.cz>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> A system or a device may need to control suspend/wakeup events. It may
> want to wakeup the system after a predefined amount of time or at a
> predefined event decided while entering suspend for polling or delayed
> work. Then, it may want to enter suspend again if its predefined wakeup
> condition is the only wakeup reason and there is no outstanding events;
> thus, it does not wakeup the userspace unnecessary and keeps suspended
> as long as possible (saving the power).

Nice. Zaurus needs it, exactly due to this reason:

> 2. Execute critical "delayed work" at suspend.
>  A driver or a system/board may have a delayed work (or any similar
> things) that it wants to execute at the requested time.
>  For example, some chargers want to check the battery voltage some
> time (e.g., 30 seconds) after the battery is fully charged and the
> charger stops. Then, the charger restarts charging if the voltage has
> dropped more than a threshold, which is smaller than "restart-charger"
> voltage, which is a threshold to restart charging regardless of the
> time passed.

Yep, and zaurus also needs it to stop charging.

> The system enters the suspend again if and only if all of the following
> conditions are met:
> 1. None of suspend_again ops returned "I want to stop suspend"
> (suspend_again returns SUSPEND_AGAIN_STOP).
> 2. At least one of suspend_again ops returned "I want to suspend again"
> (suspend_again returns SUSPEND_AGAIN_CONTINUE)

Better naming  could be SUSPEND_AGAIN and VETO_RESUSPEND or
SUSPEND_AGAIN_VETO .

> Anyway, the following features may need to be added later:
> 1. An API to allow devices to express next desired wakeup-time. Then,
> the framework will combine them and setup RTC alarm accordingly and
> save/restore previously registered RTC alarms.

Yep.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
