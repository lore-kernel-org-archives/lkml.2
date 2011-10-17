Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1JQSTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:19:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58991 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751076Ab1JQSTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:19:53 -0400
Date: Mon, 17 Oct 2011 14:19:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: John Stultz <john.stultz@linaro.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative suspend/hibernate
 mode
In-Reply-To: <1318870100.3125.30.camel@work-vm>
Message-ID: <Pine.LNX.4.44L0.1110171417070.1749-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, John Stultz wrote:

> So, the alarmtimer code is a bit more simple then what you describe
> above (alarmtimers are just like regular posix timers, only enable an
> RTC wakeup for the soonest event when the system goes into suspend).
> 
> However, such a dual-timer style behavior seems like it could work for
> timer driven wakeups (and have been suggested to me by others as well).
> Just to reiterate my understanding so that we're sure we're on the same
> wavelength:
> 
> For any timer-style wakeup event, you set another non-wakeup timer for
> some small period of time before the wakeup timer. Then when the
> non-wakeup timer fires, the application inhibits suspend and waits for
> the wakeup timer.  
> 
> Thus if the system is supended, the system will stay asleep until the
> wakeup event, where we'll hold off suspend for a timeout length so the
> task can run. If the system is not suspended, the early timer inhibits
> suspend to block the possible race.
> 
> So yes, while not a very elegant solution in my mind (as its still racy
> like any timeout based solution), it would seem to be workable in
> practice, assuming wide error margins are used as the kernel does not
> guarantee that timers will fire at a specific time (only after the
> requested time). 
> 
> And this again assumes we'll see no timing issues as a result of system
> load or realtime task processing.

It shouldn't have to be this complicated.  If a program wants the
system to be awake at a certain target time, it sets a wakeup timer for
that time.  Then it vetoes any suspend requests that occur too close to 
the target time, and continues to veto them until it has finished its 
job.

Alan Stern

