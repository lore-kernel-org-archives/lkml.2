Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0E0Frt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:47:49 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48831 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0E0Frr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:47:47 -0400
Date: Thu, 27 May 2010 01:47:29 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Milton Miller <miltonm@bga.com>
Cc: Len Brown <len.brown@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: (No subject header)
In-reply-to: <1274937929_9182@mail4.comsite.net>
Message-id: <alpine.LFD.2.00.1005270138320.8496@localhost.localdomain>
References: <4a831611847e8965ed5f3328e52fe8758115b951.1274926772.git.len.brown@intel.com>
 <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
 <1274937929_9182@mail4.comsite.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Milton Miller wrote:

> 
> [Hmm, why did this not appear in patchwork.kernel.org?  Now
> I have to guess a CC list.]
> 
> On Wed, 26 May 2010 around 22:43:50 -0400 (EDT), Len Brown wrote:
> > From: Len Brown <len.brown@intel.com>
> > 
> > TS_POLLING set tells the scheduler a task will poll
> > need_resched() to look for work.
> > 
> 
> True
> 
> > TS_POLLING clear tells resched_task() and wake_up_idle_cpu()
> > that the remote CPU is sleeping in idle, and thus requires
> > a reschedule interrupt to wake them to notice work.
> 
> No, that only applies to the idle task.
> 
> 
> > 
> > Update the description of TS_POLLING to reflect how it works.
> > "cleared when sleeping in idle, requiring reschedule interrupt"
> 
> That would imply its set for every normal task that is not in some
> kind of sleep state.

you're right, just the idle task sets this flag.

> > Signed-off-by: Len Brown <len.brown@intel.com>
> > Acked-by: Peter Zijlstra <peterz@infradead.org>
> 
> > -#define TS_POLLING		0x0004	/* true if in idle loop
> > -					   and not sleeping */
> > +#define TS_POLLING		0x0004	/* clear when sleeping in idle
> > +					   requiring reschedule interrupt */
> 
> How about "idle task polling need_resched, skip sending interrupt"?

I think that is an improvement over my wording.

Though technically we're not polling need_resched in the case
I have in mind.  The hardware is snooping any write to the thread flags
via MONITOR/MWAIT trigger address.

cheers,
-Len Brown, Intel Open Source Technology Center




