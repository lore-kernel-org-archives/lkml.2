Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916Ab0FFBQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 21:16:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47238 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab0FFBQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 21:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006060148470.2933@localhost.localdomain>
References: <20100603193045.GA7188@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<1275644619.27810.39462.camel@twins>
	<201006050138.30859.rjw@sisk.pl>
	<alpine.LFD.2.00.1006050148080.2933@localhost.localdomain>
	<AANLkTikGDSzaENwg_0BAtsYf3ulGd_6sGPR30WsvUxMi@mail.gmail.com>
	<alpine.LFD.2.00.1006050246350.2933@localhost.localdomain>
	<AANLkTikU21xF49Z-_Lnrq7U7buNmqw_gyEEST8LuN24z@mail.gmail.com>
	<alpine.LFD.2.00.1006051736040.2933@localhost.localdomain>
	<AANLkTinD39rI47innPbGz1Gi8PsXV5HqkmaQuJ70oQ63@mail.gmail.com>
	<alpine.LFD.2.00.1006052348200.2933@localhost.localdomain>
	<AANLkTikmWDHYJ8wWF2cZapbkHHjV09R39I37yvQXFmor@mail.gmail.com>
	<alpine.LFD.2.00.1006060148470.2933@localhost.localdomain>
Date: Sat, 5 Jun 2010 18:16:49 -0700
Message-ID: <AANLkTikdM79nmARagK9gLveMWEiT6rlk44UELes1k8Ch@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
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

2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
> On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
>> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
>> > On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
>> >> >> > That download might take a minute or two, but that's not an
>> >> >> > justification for the crapplication to run unconfined and prevent
>> >> >> > lower power states.
>> >> >> >
>> >> >>
>> >> >> I agree, but this is not a simple problem to solve.
>> >> >
>> >> > Not with suspend blockers, but with cgroup confinement of crap, it's
>> >> > straight forward.
>> >> >
>> >>
>> >> I don't think is is straight forward. If the a process in the frozen
>> >> group holds a resource that a process in the unfrozen group needs, how
>> >> do deal with that?
>> >
>> > I'm going to fix the framework which puts the group into freeze state
>> > w/o making sure that there is no held shared resource. Come on it's
>> > not rocket science.
>> >
>>
>> I'm not sure which framework you are talking about here, but I don't
>> think there is a single framework that knows about all shared
>> resources.
>
> Damn, it's not me talking about "our framework", you are mentioning
> when it fits your needs.

You said you were going to fix the framework. I did know if you were
talking about the cgroup framework, or the android user-space
frameworks. I don't think either has knowledge about all shared
resources.

>
> If you do not have a clearly defined user space framework, then we
> talk about a completely random conglomeration of applications which
> need to be brought into submission by some global brute force
> approach.
>
> I'm tired of this, really. You just use terminlology as it fits to
> defend the complete design failure of android. But you fail to trick
> me :)
>
> Can you please explain in a consistent way how the application stack
> and the underlying framework (which exists according to android docs)
> is handling events and how the separation of trust level works ?
>

I don't think I can, since I only know small parts of it. I know some
events like input event go though a single thread in our system
process, while other events like network packets (which are also
wakeup events) goes directly to the app.

> We need to know that, otherwise we turn in circles forever.
>
> Thanks,
>
>        tglx



-- 
Arve Hjønnevåg
