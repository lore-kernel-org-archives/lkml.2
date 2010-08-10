Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab0HJOML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:12:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35468 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab0HJOMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:12:08 -0400
Date: Tue, 10 Aug 2010 15:11:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paulmck@linux.vnet.ibm.com, "Ted Ts'o" <tytso@mit.edu>,
        Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100810141107.GA12873@srcf.ucam.org>
References: <20100807061558.GA28087@thunk.org> <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com> <20100808155719.GB3635@thunk.org> <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com> <20100808213821.GD3635@thunk.org> <20100809112453.77210acc@lxorguk.ukuu.org.uk> <20100809181638.GI3026@linux.vnet.ibm.com> <20100809201822.441905f7@lxorguk.ukuu.org.uk> <20100810044541.GA2817@linux.vnet.ibm.com> <20100810093849.138e2318@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810093849.138e2318@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 09:38:49AM +0100, Alan Cox wrote:
> > situation you call out can occur with manual suspend-to-RAM already:
> > the fact is that this is a design choice.  You could indeed make a
> 
> Losing data is a design choice ? The application set a timer, the OS
> shouldn't be ignoring it in that situation. It might want to delay it, it
> might want to warn the user its hogging things it shouldnt (powertop,
> battery usage monitors in Android etc)

So we should remove explicit system suspend from the kernel?

> > Hmmm...  Exactly which part do you consider flawed?  Let's take it
> > one sentence at a time.  The devices that I know of that lack suspend
> > blockers also lack opportunistic suspend.  Therefore, all applications on
> > such devices run as would an application that acquired a suspend blocker
> > when it started and did not release that suspend blocker until it exited.
> > Pretty straightforward.
> 
> What do you mean by "opportunistic suspend", lots of systems drop into
> lowest power states whenever they can. "Suspend is different" is a bit of
> Android religion that I am dubious has any basis in reality as seen from
> the application end of the universe.
> 
> You may also wish to review the earlier parts of the discussion where it
> was explicitly stated by several developers that they were using
> "suspend" type modes as power states already and not using suspend
> blockers. So it's being done, today on ARM and your statement is directly
> contradicting the code. Modern ARM processors and x86 MID devices can
> suspend and resume extremely fast (fast enough that the fact Linux x86
> rewriting all the SMP alternatives on suspend/resume is a measurable
> problem). If this same property doesn't end up on big PC boxes in time
> then I'd be very surprised. At that point the openoffice with suspend
> blockers or oracle with suspend blockers question becomes rather relevant.

There's a clear and absolute difference between system suspend and 
entering the same hardware state from the idle loop. That difference is 
that processes aren't scheduled until an explicit wakeup event occurs. 
Android is entirely capable of entering the same low power state at idle 
(it's done with a hardcoded idle loop on Qualcomm, cpuidle on omap), but 
if you have more than 0 scheduling wakeups a second then your power draw 
is going to be greater. 

I agree that we should be targetting 0 wakeups per second. I don't agree 
that it's realistic to insist that a use model that assumes imperfect 
software is an invalid use model.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
