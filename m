Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0FFKNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:13:50 -0400
Received: from mail.lang.hm ([64.81.33.126]:42204 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab0FFKNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:13:49 -0400
Date: Sun, 6 Jun 2010 03:12:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Vitaly Wool <vitalywool@gmail.com>
cc: Brian Swetland <swetland@google.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1006060305060.17462@asgard.lang.hm>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu> <20100603232302.GA16184@elte.hu> <AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com> <20100604071354.GA14451@elte.hu> <AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
 <20100604083423.GD15181@elte.hu> <AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com> <1275653210.27810.39762.camel@twins> <AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com> <1275731653.27810.41078.camel@twins> <20100605092851.6ee15f13@infradead.org>
 <AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com> <AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com> <AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com> <AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
 <AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com> <AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010, Vitaly Wool wrote:

> On Sun, Jun 6, 2010 at 11:21 AM, Brian Swetland <swetland@google.com> wrote:
>> In any case, I'm saying that suspending for minutes at a time
>> (typical, 10s of minutes or more in some cases, hours in others), does
>> happen and it does represent an improvement over suspending or
>> otherwise entering your lowest power state for seconds at a time.
>
> That's for sure, if _all_ the other parameters *are* *equal*. This is
> obviously not the case.

and while it will represent an improvement, is the cost worth the 
relativly minor benifit that going from 10s of seconds of sleep to 10s of 
minuites of sleep give you?

a system that wakes up every 10 seconds, but only wakes the portion of the 
system needed for the wakeup can easily outlast one that wakes up far less 
frequently, but when it's awake is fully awake.

as an example (taken from this thread).

system A needs to wake up to get a battery reading, store it and go 
back to sleep, It does so every 10 seconds. But when it does so it only 
runs the one process and then goes back to sleep.

system B has the same need, but wakes up every 10 minutes. but when it 
does so it fully wakes up and this allows the mail app to power up the 
radio, connect to the Internet and start checking for new mail before 
oppurtunistic sleep shuts things down (causing the mail check to fail)

System A will last considerably longer on a battery than System B.

David Lang
