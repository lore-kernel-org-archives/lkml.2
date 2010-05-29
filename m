Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0E2AnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 20:43:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36502 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab0E2AnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 20:43:12 -0400
MIME-Version: 1.0
In-Reply-To: <1275030704.32462.11.camel@laptop>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<1275030704.32462.11.camel@laptop>
Date: Fri, 28 May 2010 17:43:12 -0700
Message-ID: <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 12:11 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-05-28 at 00:31 -0400, tytso@mit.edu wrote:
>> Keep in mind, though, that a solution which is acceptable for Android
>> has to include making sure that crappy applications don't cause the
>> battery to get drained.  There seem to be some people who seem
>> adamently against this requirement.
>
> Again, Alan, Thomas and myself don't argue against that, what we do
> however argue against is suspend running apps as a form of power
> management.
>

You seem to argue that android is not allowed to use suspend because
the hardware we have shipped on can enter the same power state from
idle. From my point of view, since we need to support suspend on some
hardware we should be allowed to leverage this solution on the better
hardware platforms as well if it improves our battery life.

> If you were to read Alan's latest posts he clearly outlines how you can
> contain crappy apps.
>

I have not seen any suggestions for how to deal with all our
interprocess dependencies when pausing a subset of processes. Without
a solution to that we can only pause a subset of the processes we want
to pause.

> A combination of weakening QoS guarantees (delaying wakeups etc.)
> blocking on resources (delay servicing requests) and monitoring resource
> usage (despite all that its still not idle) and taking affirmative
> action (shoot it in the head).
>
> If we pose that a well behaved application is one that listens to the
> environment hints and idles when told to, we can let regular power
> management kick in and let deep idle states do their thing.
>
> If a bad application ignores those hints and manages to avoid getting
> blocked on denied resources, we can easily spot it and promote an
> attitude of violence toward it in the form of SIGXCPU, SIGSTOP, SIGTERM
> and SIGKILL, possibly coupled with a pop-up dialog -- much like we get
> today when we try to close a window and the app isn't responding.
>
> If we then also let the environment maintain a shitlist of crappy apps
> (those it had to take affirmative action against) and maybe set up a
> service that allows people to share their results, it provides an
> incentive to the app developers to fix their thing.
>
> How is this not working?
>

These solutions do not allow us to use suspend. They may get us closer
to the power consumption we get from suspend on the good hardware or
even surpass it, but we still need suspend on some hardware, and we
would get event better results by using these solutions in addition to
suspend compared to using them instead of suspend.

-- 
Arve Hjønnevåg
