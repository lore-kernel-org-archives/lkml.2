Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750869Ab1COENz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 00:13:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1COENy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 00:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=N2CgcRCh+hRxDXtO5JTq61s3JVDCYk9fS1co1LX751qVggeatXPSUBbrcSw+N8sDl2
         gL9U8LF+U+F+89eJU0hg==
MIME-Version: 1.0
In-Reply-To: <1300156794.9910.249.camel@gandalf.stny.rr.com>
References: <1300143236-23233-1-git-send-email-slavapestov@google.com> <1300156794.9910.249.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Mon, 14 Mar 2011 21:13:31 -0700
Message-ID: <AANLkTi=wNWceCfm=_jdfHFSr9SO5uLwBShH0h0Rjh0VU@mail.gmail.com>
Subject: Re: [PATCH] ftrace: add a new 'tail drops' counter for overflow events
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Slava Pestov <slavapestov@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 7:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-03-14 at 15:53 -0700, Slava Pestov wrote:
>> The existing 'overrun' counter is incremented when the ring
>> buffer wraps around, with overflow on (the default). We wanted
>> a way to count requests lost from the buffer filling up with
>> overflow off, too. I decided to add a new counter instead
>> of retro-fitting the existing one because it seems like a
>> different statistic to count conceptually, and also because
>> of how the code was structured.
>
> So this is when we are in producer/consumer mode and the ring buffer
> fills up and events are dropped.
>
> For this we could just add a new ring buffer type. We could use the
> RINGBUF_TYPE_TIME_STAMP as and call it RINGBUF_TYPE_LOST_EVENTS instead.
> I never implemented the TIME_STAMP as I never found a need to ;)
>
> As we currently have a TIME_EXTEND that is still relative from the last
> event but has a total of 59 bits for time. That being nanoseconds we can
> handle events that are 18 years apart. That far apart and never being
> read.
>
> The LOST_EVENTS could store the number of events lost when it starts
> reading again. This way raw readers will know that events were lost and
> how many.

s/reading/writing ? ie, the next time enough space is available, it
would first write a LOST_EVENTS event before returning space for the
next event?

Regardless of whether or not you want to put this info in the trace
itself (I agree it would be very useful to know where events were
dropped), I think it's useful for a user to be able to quickly see the
total number of events that were lost without grepping the trace.


>
> -- Steve
>
>
>>
>> Signed-Off-By: Slava Pestov <slavapestov@google.com>
>
>
>
