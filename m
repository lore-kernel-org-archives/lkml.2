Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab2BMPtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:49:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49912 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab2BMPtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:49:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] PM / Sleep: Make enter_state() in kernel/power/suspend.c static
Date: Mon, 13 Feb 2012 16:53:01 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
References: <201202120003.20879.rjw@sisk.pl> <201202131612.26973.rjw@sisk.pl> <4F392D99.7030303@linux.vnet.ibm.com>
In-Reply-To: <4F392D99.7030303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202131653.02013.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 13, 2012, Srivatsa S. Bhat wrote:
> On 02/13/2012 08:42 PM, Rafael J. Wysocki wrote:
> 
> > On Monday, February 13, 2012, Srivatsa S. Bhat wrote:
> >> On 02/13/2012 02:54 AM, Rafael J. Wysocki wrote:
> >>
> >>> On Sunday, February 12, 2012, Srivatsa S. Bhat wrote:
> >>>> On 02/12/2012 04:34 AM, Rafael J. Wysocki wrote:
> >>>>
> >>>>> From: Rafael J. Wysocki <rjw@sisk.pl>
> >>>>>
> >>>>> The enter_state() function in kernel/power/suspend.c should be
> >>>>> static and state_store() in kernel/power/suspend.c should call
> >>>>> pm_suspend() instead of it, so make that happen (which also reduces
> >>>>> code duplication related to suspend statistics).
> >>>>>
> >>>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>>>> ---
> >>>>>  kernel/power/main.c    |    6 +-----
> >>>>>  kernel/power/power.h   |    2 --
> >>>>>  kernel/power/suspend.c |    2 +-
> >>>>>  3 files changed, 2 insertions(+), 8 deletions(-)
> >>>>>
> >>>>> Index: linux/kernel/power/main.c
> >>>>> ===================================================================
> >>>>> --- linux.orig/kernel/power/main.c
> >>>>> +++ linux/kernel/power/main.c
> >>>>> @@ -292,11 +292,7 @@ static ssize_t state_store(struct kobjec
> >>>>>  #ifdef CONFIG_SUSPEND
> >>>>>  	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
> >>>>>  		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
> >>>>> -			break;
> >>>>> -	}
> >>>>> -	if (state < PM_SUSPEND_MAX && *s) {
> >>>>> -		error = enter_state(state);
> >>>>> -		suspend_stats_update(error);
> >>>>> +			error = pm_suspend(state);
> >>>>
> >>>>
> >>>> This code will not stop after calling pm_suspend(). It will try more iterations
> >>>> in the for loop right?
> >>>
> >>> Well, only one string in pm_states[] can be matched at a time, but I agree that
> >>> it doesn't make sense to continue the loop after we've found a match.
> >>>
> >>>> We can probably keep the 'for' loop as it is, and just replace the 'if' block
> >>>> following the 'for' loop by: error = pm_suspend(state);
> >>>
> >>> I think the patch below is correct.
> >>>
> >>> Thanks,
> >>> Rafael
> >>>
> >>> ---
> >>> From: Rafael J. Wysocki <rjw@sisk.pl>
> >>> Subject: PM / Sleep: Make enter_state() in kernel/power/suspend.c static
> >>>
> >>> The enter_state() function in kernel/power/suspend.c should be
> >>> static and state_store() in kernel/power/suspend.c should call
> >>> pm_suspend() instead of it, so make that happen (which also reduces
> >>> code duplication related to suspend statistics).
> >>>
> >>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>> ---
> >>
> >>
> >> Yeah, this version of the patch will work fine.
> >>
> >> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > 
> > Thanks!
> > 
> > I wonder if that should be Reviewed-by, tough?  You evidently have reviewed
> > the patch (actually, all three of them).
> > 
> 
> 
> Anything is fine :-) It is not very clear to me when to use Reviewed-by and
> when to use Acked-by.. so I randomly chose one of them.. :-)
> But please enlighten me as to when to use which one, so that in the future, I
> can use the right one :-)

"Acked-by" means, roughly, "I have no objection" or "looks good to me",
depending on who's saying that, but it doesn't imply that you've had more than
a cursory look at the patch in question.  "Reviewied-by", in contrast, means
something like "I have reviewed the patch in detail and haven't found anything
wrong in it" (which obviously means that you have no objection too, because
otherwise you'd have found _something_ wrong in the patch).

So, "Acked-by" from anyone other than the relevant maintainer is just an
"I'm for" declaration, while "Reviewied-by" from _anyone_ carries some actual
weight. 

Thanks,
Rafael
