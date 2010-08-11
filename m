Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab0HKUAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:00:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53646 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab0HKUAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jVQF/mr/Hibi5yHagfBtXb1xG3avYvDsZUdLsF/SsagcU2Z3sW0bPdX0q4xb/4e+xQ
         dve7yJlz4nrKWYZ3+QViNjaCTDhreu0/c0ezQZt4g2BBsYbyJnOC6gmPeEuTcHlCfPk1
         nesy0ZOGJItR+G8uH1PJJ2PN31K4oK7RMWtkw=
MIME-Version: 1.0
In-Reply-To: <20100811004223.GH2379@linux.vnet.ibm.com>
References: <20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
	<20100809201822.441905f7@lxorguk.ukuu.org.uk>
	<20100810044541.GA2817@linux.vnet.ibm.com>
	<20100810093849.138e2318@lxorguk.ukuu.org.uk>
	<20100811004223.GH2379@linux.vnet.ibm.com>
Date: Wed, 11 Aug 2010 23:00:42 +0300
Message-ID: <AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 3:42 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Aug 10, 2010 at 09:38:49AM +0100, Alan Cox wrote:
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
> Here is the list of properties distinguishing idle from suspend:
>
> 1.      Idle states are entered by a given CPU only there are no runnable
>        tasks for that CPU.  In contrast, opportunistic suspend can
>        halt the entire system even when there are tasks that are ready,
>        willing, and able to run.  (But please note that this might not
>        apply to real-time tasks.)

But if there are no runnable tasks (which is the target), they behave the same.

> 2.      There can be a set of input events that do not bring the system
>        out of suspend, but which would bring the system out of idle.
>        Exactly which events are in this set depends both on hardware
>        capabilities and on the platform/application policy.  For example,
>        on one of the Android-based smartphones, touchscreen input is
>        ignored when the system is suspended, but is handled when idle.

And in N900 touching the screen doesn't bring the device out of idle,
I guess because it's off.

What devices do what on which circumstances on what platform is
completely irrelevant.

> 3.      The system comes out of idle when a timer expires.  In contrast,
>        timers might or might not bring the system out of suspend,
>        depending on both hardware capabilities and platform/application
>        policy.

Isn't this solved by range timers?

> 4.      Suspend generally forces devices to go into their low-power
>        states immediately.  In contrast, idle generally leaves unused
>        devices at full power, relying on timers to shut down these
>        devices.  Idle thus has shorter average wakeup latencies, but
>        worse energy efficiency.

Only if you make these assumptions
 1) All the applications use suspend-blockers only when they absolutely must
 2) The user has given the right applications the right access

If not, you'll see much worst energy efficiency. So in theory maybe,
but in practice you can't say that.

-- 
Felipe Contreras
