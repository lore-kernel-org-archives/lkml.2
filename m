Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab0ERWE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:04:29 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:58485 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0ERWE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:04:27 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
References: <1273810273-3039-1-git-send-email-arve@android.com>
	<AANLkTilQ5wZ_7fMyDMpUBCtu9oD1Wh22JGllyS1EPlxB@mail.gmail.com>
	<87tyq5qj3v.fsf@deeprootsystems.com> <201005182052.28778.rjw@sisk.pl>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 18 May 2010 15:04:22 -0700
In-Reply-To: <201005182052.28778.rjw@sisk.pl> (Rafael J. Wysocki's message of "Tue\, 18 May 2010 20\:52\:28 +0200")
Message-ID: <87y6fgn9y1.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday 18 May 2010, Kevin Hilman wrote:
>> Arve Hjønnevåg <arve@android.com> writes:
>> 
>> >
>> > PM: Opportunistic suspend support.
>> >
>> > Power management features present in the current mainline kernel are
>> > insufficient to get maximum possible energy savings on some platforms,
>> > such as Android, because low power states can only safely be entered
>> > from idle.  Suspend, in its current form, cannot be used, since wakeup
>> > events that occur right after initiating suspend will not be processed
>> > until another possibly unrelated event wake up the system again.
>> 
>> I think the problems with wakeups in the current suspend path need to
>> be described in more detail.  In particular, why check_wakeup_irqs()
>> is not enough etc.
>
> That one is really easy.: because some (the majority of?) architectures
> don't even implement it.

OK, then this problem will still in traditional suspend even after
this series, so calling it out as a the problem to be solved but not
fixing it doesn't seem right.

This problem needs an independent fix, namely implementing
check_wakeup_irqs().

That being said, what exactly is there for architectures to implement
for check_wakeup_irqs()?  IIUC, this all handled by genirq as long as
deferred disable (now the default) is used?

I suspect the platforms that Android currently cares about already
have this functionality.  At least OMAP does already.

>> > On some systems idle combined with runtime PM can enter the same power
>> > state as suspend, but periodic wakeups increase the average power
>> > consumption. Suspending the system also reduces the harm caused by
>> > apps that never go idle. On other systems suspend can enter a much
>> > lower power state than idle.
>> >
>> > To allow Android and similar platforms to save more energy than they
>> > currently can save using the mainline kernel, we introduce a mechanism
>> > by which the system is automatically suspended (i.e. put into a
>> > system-wide sleep state) whenever it's not doing useful work, called
>> > opportunistic suspend.
>> 
>> A definition of "useful work" here would provide clarity and would
>> also help clarify by what criteria other on-going work is determined
>> to be not useful.
>
> Probably "useful" is not the right word here.  I guess it's more like
> "work that can be deferred without visible impact on functionality".

OK, then a definition of "visible impact on functionality" should be
provided and the critera for determining that.

I know this sounds like splitting hairs, but what I'm getting at is
that this series implements a brand new method for making decisions
about when the system is idle.  That fact should be clearly stated and
the criteria for making this decision should be clearly described.

Kevin
