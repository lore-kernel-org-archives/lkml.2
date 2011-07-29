Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1G2Aqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 20:46:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55741 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1G2Aqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 20:46:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=L0a0xvEr9WMaBz2vwstYg88090G1I1PK3KUVSSdRXOyrqHTMOCyMP5qVwuy37UY9r
	sYZfPst5F3occtnA1ZVBw==
MIME-Version: 1.0
In-Reply-To: <20110725124451.GA2866@redhat.com>
References: <1311271873-10879-1-git-send-email-zakmagnus@google.com>
	<20110722195340.GF3765@redhat.com>
	<CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
	<20110725124451.GA2866@redhat.com>
Date: Thu, 28 Jul 2011 17:16:00 -0700
Message-ID: <CAAuSN93Qjk4eEAvm_Xn=O-0t+qhAyKmxy6HyPuyzJ35tX2u_CQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
From: ZAK Magnus <zakmagnus@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No news?

I've been testing and looking into issues and I realized dump_stack()
calls touch_nmi_watchdog(). That wrecks what the patch is trying to do
so I'm changing it to save the trace and print it later after the
stall has completed. This would also resolve some other things you
were saying weren't so good. Hopefully the logic is similar enough
that some things you may have learned still apply.

On Mon, Jul 25, 2011 at 5:44 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, Jul 22, 2011 at 03:34:37PM -0700, ZAK Magnus wrote:
>> On Fri, Jul 22, 2011 at 12:53 PM, Don Zickus <dzickus@redhat.com> wrote:
>>
>> > So I played with the hardlockup case and I kinda like the timestamp thing.
>> > It seems to give useful data.  In fact I feel like I can shrink the
>> > hardlockup window, run some tests and see where the latencies are in a
>> > system.  The patch itself I think is ok, I'll review on Monday or Tuesday
>> > when I get some more free time.
>> >
>> > However, I ran the softlockup case and the output was a mess.  I think
>> > rcu_sched stalls were being detected and as a result it was NMI dumping
>> > stack traces for all cpus.  I can't tell if it was your patch or some
>> > uncovered bug.
>> >
>> > I'll dig into on Monday.  Not sure if you were able to see that.
>> >
>> > Thanks,
>> > Don
>> >
>> I'm not sure what you mean. One problem could be the wording I used.
>> For the soft stalls I just called it LOCKUP, mostly to be very showy
>> in order to cover that case where it's unclear what exactly is
>> happening. This doesn't do much to distinguish soft and hard lockups,
>> and I see LOCKUP otherwise seems to refer to hard lockup, so maybe
>> that's misleading.
>
> It had nothing to do with the wording.  It was spewing a ton of stack
> traces.  Most of them related to rcu_sched stalls which requested stack
> traces for each cpu (and the machine I as on had 16 cpus) repeatedly.
>
> So from a user perspective, I just saw a flood of stack traces scroll
> across the screen forever for a minute.  It was impossible to determine
> what was going on without reviewing the logs once everything calmed down.
> That is never a good thing.  It probably has nothing to do with your
> patch, but it is something that should be looked at.
>
> I'll try and poke today or tomorrow.
>
> Cheers,
> Don
>
