Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab2DJN6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:58:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab2DJN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:58:46 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=hzoqAax4KOoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M29pHIjLk_o7-QnifkkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334066322.23924.204.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH]sched_rt.c: Avoid unnecessary dequeue and enqueue of
 pushable tasks in set_cpus_allowed_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Date: Tue, 10 Apr 2012 09:58:42 -0400
In-Reply-To: <654301331942324@web109.yandex.ru>
References: <1322774765.8386.2.camel@hp>
	 <20120213172316.GA24145@home.goodmis.org> <944171329661049@web81.yandex.ru>
	 <654301331942324@web109.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-17 at 03:58 +0400, Kirill Tkhai wrote:
> Steven, what is about the patch from my previous message? Is everything ok?

You're timing is impeccable. I was in Chemnitz, Germany when you sent
this, and it too was lost in the noise ;-)

I'll take a look at it today.

Thanks!

-- Steve

 
> 
> Regards,
> Kirill
> 
> 19.02.2012, 18:17, "Kirill Tkhai" <tkhai@yandex.ru>:
> > 13.02.2012, 21:23, "Steven Rostedt" <rostedt@goodmis.org>:
> >
> >>  I wasn't on the Cc of the original message, but it was bounced to me
> >>  awhile ago. I'm cleaning out my email and came across it.
> >>
> >>  Can you send me the latest version of this patch, either against latest
> >>  Linus, or against tip/master.
> >>
> >>  Thanks,
> >>
> >>  -- Steve
> >>
> >>  P.S. I'll be at ELC this week so it may not get processed right away.
> >
> > Migration status depends on a difference of weight from 0 and 1.
> > If weight > 1 (<= 1) and old weight <= 1 (> 1) then task becomes
> > pushable (or not pushable). We are not insterested in its exact
> > values, is it 3 or 4, for example.
> >
> > Now if we are changing affinity from a set of 3 cpus to a set of 4, the-
> > task will be dequeued and enqueued sequentially without important
> > difference in comparison with initial state. The only difference is in
> > internal representation of plist queue of pushable tasks and the fact
> > that the task may won't be the first in a sequence of the same priority
> > tasks. But it seems to me it gives nothing.
> >
> > Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>


