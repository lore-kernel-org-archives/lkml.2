Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0EKQMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:12:54 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61892 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0EKQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:12:53 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19XReAfePK0nyxrfz3O5GNL
Date: Tue, 11 May 2010 09:12:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100511161227.GD13600@atomide.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <87wrvl5479.fsf@deeprootsystems.com>
 <87632vhbs8.fsf@deeprootsystems.com>
 <201005102225.52431.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005102225.52431.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [100510 13:27]:
> On Monday 10 May 2010, Kevin Hilman wrote:
> > Hello,
> 
> Hi Kevin,
> 
> > I think many folks are still confused about exactly the problem being
> > solved by this series as well as mixed up between opportunistic
> > suspend and suspend blockers.  Also, how this series impatcs the rest
> > of the kernel (especially PM-aware drivers and subsystems) has caused
> > a bit of confusion.
> > 
> > To help with the confusion, I think a much clearer description of the
> > problem being solved and the proposed solution is needed.  
> > 
> > To that end, I created a starting point for that below which
> > summarizes how I understand the problem and the proposed solution, but
> > of course this should be filled out in more detail and updated as part
> > of the documentation that goes with this series.
> > 
> > Hope this helps improve the understanding of this feature,
> 
> Yes, I think this is helpful.
> 
> > Table of Contents
> > =================
> > 1 Problem Statement 
> > 2 Solution: Opportunistic suspend 
> >     2.1 When to use a suspend blocker 
> >     2.2 Usage in PM aware drivers 
> > 
> > 
> > 1 Problem Statement 
> > ~~~~~~~~~~~~~~~~~~~~
> > 
> > Want to to hit deep power state, even when the system is not actually
> > idle.
> > 
> > Why?
> > 
> > - some hardware is not capable of deep power states in idle
> > - difficulty getting userspace and/or kernel to be idle
> > 
> > 2 Solution: Opportunistic suspend 
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Create an additional "idle path" which has new rules for determining
> > idleness.  When this new "idle" is reached, trigger full-system
> > suspend.  Since a suspend is triggered whenever the opportunity
> > arises, this is called opportunistic suspend.

I agree, this is is the right way to handle when to enter suspend.

Especially if the system needs to run while waiting for something
to happen before being able to suspend.

> > The new rules for making the idleness decision are simple:
> > 
> > 1.  system may suspend if and only if no suspend blockers are held

To me it sounds like this should only be allowed to happen when you do:

# echo 1 > /sys/power/suspend_while_idle

As it kills the timers and leads to non-standard behaviour of the apps
as they won't run :)

And then the remaining question is how to make sure the use cases
below can be handled in a clean way.
 
> > 2.1 When to use a suspend blocker 
> > ==================================
> > 
> > [A list of reasons why suspend blockers might be used would be very
> >  helpful here.] 
> > 
> > - ensure wakeup events propagate to userspace (e.g. keypad example in doc)
> > 
> > - screen is on
> > 
> > - someone mentioned "Google use cases"
> >   (would be nice to hear about more of these)
> 
> Yes, I think the Android developers know quite a few cases where suspend
> blockers are useful.
> 
> > 2.2 Usage in PM aware drivers 
> > ==============================
> > 
> > [An example of how a driver already using runtime PM would use 
> >  a suspend blocker would also be helpful.
> 
> When we have any drivers using both in the tree, they will be used as examples
> here.
> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
