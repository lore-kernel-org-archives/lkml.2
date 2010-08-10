Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab0HJSJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:09:45 -0400
Received: from mail.lang.hm ([64.81.33.126]:55607 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756272Ab0HJSJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:09:40 -0400
Date: Tue, 10 Aug 2010 11:07:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, paulmck@linux.vnet.ibm.com,
        "Ted Ts'o" <tytso@mit.edu>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <20100810141107.GA12873@srcf.ucam.org>
Message-ID: <alpine.DEB.2.00.1008101057090.23481@asgard.lang.hm>
References: <20100807061558.GA28087@thunk.org> <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com> <20100808155719.GB3635@thunk.org> <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com> <20100808213821.GD3635@thunk.org>
 <20100809112453.77210acc@lxorguk.ukuu.org.uk> <20100809181638.GI3026@linux.vnet.ibm.com> <20100809201822.441905f7@lxorguk.ukuu.org.uk> <20100810044541.GA2817@linux.vnet.ibm.com> <20100810093849.138e2318@lxorguk.ukuu.org.uk>
 <20100810141107.GA12873@srcf.ucam.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010, Matthew Garrett wrote:

> On Tue, Aug 10, 2010 at 09:38:49AM +0100, Alan Cox wrote:
>>> Hmmm...  Exactly which part do you consider flawed?  Let's take it
>>> one sentence at a time.  The devices that I know of that lack suspend
>>> blockers also lack opportunistic suspend.  Therefore, all applications on
>>> such devices run as would an application that acquired a suspend blocker
>>> when it started and did not release that suspend blocker until it exited.
>>> Pretty straightforward.
>>
>> What do you mean by "opportunistic suspend", lots of systems drop into
>> lowest power states whenever they can. "Suspend is different" is a bit of
>> Android religion that I am dubious has any basis in reality as seen from
>> the application end of the universe.
>>
>> You may also wish to review the earlier parts of the discussion where it
>> was explicitly stated by several developers that they were using
>> "suspend" type modes as power states already and not using suspend
>> blockers. So it's being done, today on ARM and your statement is directly
>> contradicting the code. Modern ARM processors and x86 MID devices can
>> suspend and resume extremely fast (fast enough that the fact Linux x86
>> rewriting all the SMP alternatives on suspend/resume is a measurable
>> problem). If this same property doesn't end up on big PC boxes in time
>> then I'd be very surprised. At that point the openoffice with suspend
>> blockers or oracle with suspend blockers question becomes rather relevant.
>
> There's a clear and absolute difference between system suspend and
> entering the same hardware state from the idle loop. That difference is
> that processes aren't scheduled until an explicit wakeup event occurs.
> Android is entirely capable of entering the same low power state at idle
> (it's done with a hardcoded idle loop on Qualcomm, cpuidle on omap), but
> if you have more than 0 scheduling wakeups a second then your power draw
> is going to be greater.
>
> I agree that we should be targetting 0 wakeups per second. I don't agree
> that it's realistic to insist that a use model that assumes imperfect
> software is an invalid use model.

If the primary difference between sleep and suspend is not scheduling 
processes, instead of messing with oppurtinistic suspend/suspend 
blockers/wakelocks/etc, why not just 'temporarily' change the timer fuzz 
value to a very large value (say an hour). That would still let things 
like openoffice saves ahve a fair chance to trigger before the battery 
died completely, but would wake the system so infrequently that it will be 
effectivly the same as a full suspend.

David Lang
