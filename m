Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab0FHAFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:05:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54265 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0FHAFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006061236350.2933@localhost.localdomain>
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
	<AANLkTikdM79nmARagK9gLveMWEiT6rlk44UELes1k8Ch@mail.gmail.com>
	<alpine.LFD.2.00.1006061236350.2933@localhost.localdomain>
Date: Mon, 7 Jun 2010 17:05:32 -0700
Message-ID: <AANLkTimWasxjM5wGu6fypktpdidFkvccd8202XqrRX12@mail.gmail.com>
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

2010/6/6 Thomas Gleixner <tglx@linutronix.de>:
> On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
>> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
>> >
>> > Can you please explain in a consistent way how the application stack
>> > and the underlying framework (which exists according to android docs)
>> > is handling events and how the separation of trust level works ?
>> >
>>
>> I don't think I can, since I only know small parts of it. I know some
>
> Sigh, thats the whole reason why this discussion goes nowhere.
>

Please keep in mind that we also have third party applications and
that it is not acceptable to break them. So even if I was able to tell
you everything our framework does, you still need to make sure your
solution does not break existing apps.

> How in heavens sake should we be able to decide whether suspend
> blockers are the right and only thing which solves a problem, when the
> folks advocating suspend blockers are not able to explain the problem
> in the first place ?
>
>> events like input event go though a single thread in our system
>> process, while other events like network packets (which are also
>> wakeup events) goes directly to the app.
>
> Yes, we know that already, but that's a completely useless information
> as it does not describe the full constraints and dependencies.
>
> Lemme summarize:
>
>  Android needs suspend blockers, because it works, but cannot explain
>  why it works and why it only works that way.
>
> A brilliant argument to merge them - NOT.
>

Your solution changes the programming model in a way that suspend does
not. Linux allow processes to communicate with each other, and if you
freeze individual processes this breaks. For the android framework
code a lack of a timely response from an application is treated as an
error, and the user is notified that the application is misbehaving.
It may be possible to change the framework to make sure that no
processes are frozen while it is waiting for a response, but this is a
major change and applications that receive wakeup events directly from
the kernel will still be broken.

-- 
Arve Hjønnevåg
