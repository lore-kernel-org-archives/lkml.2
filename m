Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab0FEWKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 18:10:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39784 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933087Ab0FEWKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 18:10:47 -0400
MIME-Version: 1.0
In-Reply-To: <201006052025.11526.rjw@sisk.pl>
References: <20100603193045.GA7188@elte.hu>
	<20100605011826.GB21016@count0.beaverton.ibm.com>
	<AANLkTim3MMfJ6oa9OhUJch_v1qGyxSfrfxF3zDZhxqHk@mail.gmail.com>
	<201006052025.11526.rjw@sisk.pl>
Date: Sat, 5 Jun 2010 15:10:46 -0700
Message-ID: <AANLkTilP0uyJRuUq6BlVeHDydPYi4oJsf37VvSAixwgN@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matt Helsley <matthltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/5 Rafael J. Wysocki <rjw@sisk.pl>:
> On Saturday 05 June 2010, Arve Hjønnevåg wrote:
>> 2010/6/4 Matt Helsley <matthltc@us.ibm.com>:
>> > On Fri, Jun 04, 2010 at 05:39:17PM -0700, Arve Hjønnevåg wrote:
>> >> On Fri, Jun 4, 2010 at 5:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> > On Sat, 5 Jun 2010, Rafael J. Wysocki wrote:
>> >
>> > <snip>
>> >
>> >>
>> >> >     With the cgroup freezer you can "suspend" them right away and
>> >> >     just keep the trusted background task(s) alive which allows us to
>> >> >     go into deeper idle states instead of letting the crapplications
>> >> >     run unconfined until the download finished and the suspend
>> >> >     blocker goes away.
>> >> >
>> >>
>> >> Yes this would be better, but I want it in addition to suspend, not
>> >> instead of it. It is also unclear if our user-space code could easily
>> >> make use of it since our trusted code calls into untrusted code.
>> >>
>> >
>> > Perhaps I'm misunderstanding, but suspend and the cgroup freezer
>> > interoperate well today -- you don't have to choose one or the other.
>> > If you've discovered otherwise I'd consider it a bug and would like to
>> > hear more about it.
>> >
>>
>> I'm not aware of any bug with combining both, but we cannot use
>> suspend at all without suspend blockers in the kernel (since wakeup
>> events may be ignored)
>
> The more I think of it, the more it appears to me that the problem of
> lost wakeup events can actually be solved without suspend blockers.
> I'll send a bunch of patches to address this issue, probably tomorrow.
>

I know of two ways to prevent lost wakeup events. Reset a timeout
every time you receive a wakeup event or prevents suspend until you
know the event has been fully processed. Does your solution fall onto
one of these two categories, or do you have a third way?

>> and I don't know how we can safely freeze
>> cgroups without funneling all potential wakeup events through a
>> process that never gets frozen.
>
> If your untrusted apps get called by the trusted ones, they aren't really
> untrusted in the first place.
>
That is not a correct statement. A trusted apps can call into an
untrusted app, it just has to validate the response and handle not
getting a response at all. There are also different levels of trust. I
may have trusted an app to provide a contact pictures, but not trusted
it to block suspend. When the phone rings the app will be called to
provide the picture for the incoming call dialog, but if it is frozen
at this point the more trusted app that handles the incoming phone
call will not be able to get the picture.

> From what you're saying it follows that you're not really willing to accept
> any solution different to your suspend blockers.  Is that really the case?
>
I don't think that is a fair way to put it. We need to support our
user-space framework and I have not seen an alternative solution that
clearly will work (other than replacing suspend_blockers with pm_qos
constraints that do the same thing).

-- 
Arve Hjønnevåg
