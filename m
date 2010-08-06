Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab0HFAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:16:57 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44022 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0HFAQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:16:54 -0400
Subject: Re: [PATCH] [RFC] notify userspace about time changes
From: john stultz <johnstul@us.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alexander Shishkin <virtuoso@slind.org>, gregkh@suse.de,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimNEbVacF6EzFAjdyvY6G8xa0nXCi0Do_i=FSaY@mail.gmail.com>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
	 <1280937526.28884.21.camel@work-vm>
	 <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com>
	 <1281042665.3405.15.camel@localhost.localdomain>
	 <AANLkTi=Gxk7FwmyCqNwXQEg7OsvDh4p2Mg3Fhiy1g5pv@mail.gmail.com>
	 <1281047390.3405.22.camel@localhost.localdomain>
	 <AANLkTimNEbVacF6EzFAjdyvY6G8xa0nXCi0Do_i=FSaY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 17:16:29 -0700
Message-ID: <1281053789.3405.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 01:50 +0200, Kay Sievers wrote:
> On Fri, Aug 6, 2010 at 00:29, john stultz <johnstul@us.ibm.com> wrote:
> > On Fri, 2010-08-06 at 00:17 +0200, Kay Sievers wrote:
> >> On Thu, Aug 5, 2010 at 23:11, john stultz <johnstul@us.ibm.com> wrote:
> >> > On Thu, 2010-08-05 at 15:33 +0300, Alexander Shishkin wrote:
> >> >> On 4 August 2010 18:58, john stultz <johnstul@us.ibm.com> wrote:
> >> >> > Is there a actual use case that you need this for?  I don't really have
> >> >> > an issue with the code I just really want to make sure the feature would
> >> >> > be useful enough to justify the API and code maintenance going forward.
> >>
> >> Basically everything that schedules an action based on an absolute
> >> time specification, like at 3pm today, and not in 3 hours from now,
> >> needs to track such system time changes. Otherwise it has to do
> >> nonsense like cron does, to wake up every minute to check the current
> >> time.
> >
> > time_create(CLOCK_REALTIME,...) creates absolute (not relative) timers
> > that should be adjusted when the clock is changed. Is that not the case?
> 
> That works, yes. The created timer is still is a fixed value, and it
> gets automatically adjusted when the system time changes.
> 
> This is the example Lennart and I thought about when we considered
> adding cron-like stuff to systemd's timer configs, but didn't want to
> do silly things like scheduled checks for the actual time, so we
> delayed this feature until such a notification becomes available.
> 
> Consider we want stuff like "wakeup every day at 3pm", the next wakeup
> might be earlier than the timer we calculated last time, on system
> time changes. We need to re-calculate it. This is necessary for all
> repeating events.
> 
> Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
> hours. Now the system time changes to 2pm, and we would expect to
> wakeup in one hour, but we take 25.

Ah. Yea. So its not really an issue scheduling absolute times, but
issues around absolute recurrences when time might go backwards.

So yea, that's another good example in favor of Alexander's patch (at
least the basic functionality, modulo the interface
details/documentation).

Thanks for the clarification!
-john




