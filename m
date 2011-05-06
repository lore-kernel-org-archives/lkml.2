Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab1EFVK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:10:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34550 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1EFVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:10:56 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=Ev-mm6w7t5DsACkrcGAA:9 a=lFnyZK4mzMqTg_0429kA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
References: <4DC45537.6070609@linux.intel.com>
	 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 06 May 2011 17:10:55 -0400
Message-ID: <1304716255.25414.2540.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 13:51 -0700, Linus Torvalds wrote:
> On Fri, May 6, 2011 at 1:20 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I strongly NACK this!
> 
> Doesn't matter.
> 
> Binary compatibility is more important.
> 
> And if binaries don't use the interface to parse the format (or just
> parse it wrongly - see the fairly recent example of adding uuid's to
> /proc/self/mountinfo), then it's a regression.
> 
> And regressions get reverted, unless there are security issues or
> similar that makes us go "Oh Gods, we really have to break things".

Um, this is an internal tracepoint. Does this mean that all internal
data inside the kernel that is exported with trace events are locked
down?

> 
> I don't understand why this simple logic is so hard for some kernel
> developers to understand. Reality matters. Your personal wishes matter
> NOT AT ALL.

This isn't a personal wish. This brings every advancement that I was
planning on making this year to a dead halt. We were really about to
restructure the events to make them lighter weight and faster.

Also, this isn't the first time this structure has changed. It just
happens that something started using it. This field did not even exist
until recently.


> 
> If you made an interface that can be used without parsing the
> interface description, then we're stuck with the interface. Theory
> simply doesn't matter.

I never had an interface used this way. It was just by luck. Damn, I
should have listened to Peter Zijlstra when he recommended that every
boot restructures the data in the format differently. Then this would
never have happened. But doing that would have slowed things down
tremendously (or remove the ease of TRACE_EVENT).

> 
> You could help fix the tools, and try to avoid the compatibility
> issues that way. There aren't that many of them.

As I said, I have a library (.so even) that does the parsing for you. If
I get powertop to use it, can we hold off on this patch?

Note, I'm about to leave to Budapest. I could try to get this done on
the trip.

-- Steve


