Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2LMXKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:10:12 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40145 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2LMXKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:10:10 -0500
MIME-Version: 1.0
In-Reply-To: <20121213150015.e497a585.akpm@linux-foundation.org>
References: <1355432225-5878-1-git-send-email-fweisbec@gmail.com>
	<20121213131809.122fdd61.akpm@linux-foundation.org>
	<CAFTL4hxPAq0pNOAhMc01iOygqdx=Ja=b5u9ozzdRmPLbtxMn+A@mail.gmail.com>
	<20121213150015.e497a585.akpm@linux-foundation.org>
Date: Fri, 14 Dec 2012 00:10:09 +0100
Message-ID: <CAFTL4hw=OorY4=Y4RRQv5qZVZCmv201dpNECGH37neDArc4wpg@mail.gmail.com>
Subject: Re: [PATCH] context_tracking: Add comments on interface and internals
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/14 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 13 Dec 2012 23:50:23 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> >
>> >> + * This call supports re-entrancy.
>> >
>> > Presumably the explanation for user_exit() applies here.
>>
>> Not sure what you mean here.
>
> It's unclear what it means to say "user_enter() supports reentrancy".
> I mean, zillions of kernel functions are surely reentrant - so what?
> It appears that you had something in mind when pointing this out, but
> what was it?  The comment over user_exit() appears to tell us.

Ah ok. Yeah indeed, the fact user_exit() is reentrant is very
important because I have precise usecases in mind. For user_enter() I
don't, so probably I don't need to inform about it.

>
>> > It's mainly this bit which makes me wonder why the code is in lib/.  Is
>> > there any conceivable prospect that any other subsystem will use this
>> > code for anything?
>>
>> So that's because of that cputime accounting on dynticks CPUs which
>> will need to know about user/kernel transitions. I'm preparing that
>> for the 3.9 merge window.
>
> Oh.  That's really the entire reason for the patch and should have been
> in the changelog!

I mentioned it in the changelog:

commit 91d1aa43d30505b0b825db8898ffc80a8eca96c7 "context_tracking: New
context tracking susbsystem"
"""
    We need to pull this up from RCU into this new level of indirection
    because this tracking is also going to be used to implement an "on
    demand" generic virtual cputime accounting. A necessary step to
    shutdown the tick while still accounting the cputime.
"""

Another reason, more implicit this time, was to avoid that RCU handles
those reentrancy things and context tracking all around by itself.
