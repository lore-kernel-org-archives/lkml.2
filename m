Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab0GKFle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 01:41:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63519 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0GKFlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 01:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PY5ca2yYjSrKAj32mciQo1u7F+Unp0+ZbNWf6Ykmv6JX6jDedI46VKcn1+SRlF7q4S
         jN60E1KXXnjMgz1z6f/EP3pqgzqdTrN5Tp4NCJ+5se/uWpnLADQDm5jVODeVpP8ROOo8
         mFvW+zAy1wG5HZyWm3fCgVCk9rB7ApCMOWOms=
MIME-Version: 1.0
In-Reply-To: <1278798752.4918.24.camel@Palantir>
References: <1278682707.6083.227.camel@Palantir>
	<1278685800.1900.212.camel@laptop>
	<AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com>
	<1278786710.1998.63.camel@laptop>
	<AANLkTin0sj6ONjNcwX6IJHSgi7gKnCzkvD_jaLyOFNjs@mail.gmail.com>
	<1278798752.4918.24.camel@Palantir>
Date: Sun, 11 Jul 2010 07:41:31 +0200
Message-ID: <AANLkTikqMGeDO0cSOz-o12NmcQmjB2tC0NtEGCYlLDgE@mail.gmail.com>
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Harald Gustafsson <hgu1972@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/10 Raistlin <raistlin@linux.it>:
> Indeed. I think things might be done step by step, relaxing the
> constraints as long as we find better solutions.
Yes, I definitely think the step by step approach is best here. So
that eventually its possible to use hard deadline RT also for more
complex task activation patterns.

>> > Embedded people can of course easily hack in whatever they well fancy,
>> > and adding the 'yes_I_really_want_this_anyway' flag or even taking out
>> > admission control all together is something the GPL allows them to do.
>>
>> Not an option I would like to pursue, it should be possible to get a
>> working solution without this.
>>
> Yeah, I see your point and agree with it. Btw, I think that, even in the
> configuration described by Peter, if you --as an embedded system
> engineer-- have the full control of your device/product, you can avoid
> having any hard-rt task. Then, if you only have soft ones, you'll get
> the benefit of having the possibility of setting D!=P without suffering
> of any interference... Am I right?

Yes, this is exactly what I mean. As long as the interface gives the
user control to be able to demote a task to soft RT even if the
admission control could allow it into the hard RT policy. Then later
when we have managed to include more complex admission controls into
the kernel, the system designer could when his system setup is handled
move over to always use hard RT. This would also mean that people
would start using the DL scheduler and having a motivation of
improving the admission control, because it is preferred to have the
benefit of reliable isolation between tasks.

> I think this could be a viable solution, at least until we have
> something better to relax assumptions on the schedulability test for
> hard tasks, isn't it?
Yes, I agree.

Regards,
  Harald
