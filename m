Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0KARbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:31:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44984 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0KARbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:31:46 -0400
MIME-Version: 1.0
In-Reply-To: <1287573447.3488.5.camel@twins>
References: <AANLkTinpR5QQUkd5VJMyotiEMLZYZdDs5-Jwn3LQ4pC0@mail.gmail.com>
	<1287573447.3488.5.camel@twins>
Date: Mon, 1 Nov 2010 10:31:44 -0700
Message-ID: <AANLkTimdmvdP7fWiSVz7ojfCLRbWD5s1_01agGmW3xTK@mail.gmail.com>
Subject: Re: [PATCH] sched_fair.c:find_busiest_group(), kernel 2.6.35.7
From: Andrew Dickinson <whydna@whydna.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I agree that getting to root-cause is important, but this is still an
unchecked exception.  Is your concern about "papering over" due to the
fact that this patch doesn't emit an error message/increment a
counter/etc?  I think that there's some middle ground here.  One
wouldn't blindly assume that malloc() returned non-zero, right?
Similarly, if dividing, one should check that the denominator is not
zero. :D

Regarding reproducing this bug.  All of the evidence that I've seen
(both in the BZ reports and my own experience) suggest that this
happens only after 6+ months of uptime on heavily loaded systems.  In
my case, it happened across a fleet of 60+ hosts within a 1-2 week
time-frame; each host is passing an average of 500kpps continuously
during this time-frame.  All of them previously had an uptime of
approximately 7 months.

Is there a middle ground here where we can handle the exception safely
and emit a message to help get more debugging information to try to
track this down?  The BZ report does have a recommended patch to emit
some WARN_ON messages, I'd be happy to include that in this patch as
well.  Would that help?

-A

On Wed, Oct 20, 2010 at 4:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-10-20 at 00:20 -0700, Andrew Dickinson wrote:
>> This is a patch to fix the corner case where we're crashing with
>> divide_error in find_busiest_group (see
>> https://bugzilla.kernel.org/show_bug.cgi?id=16991).
>> I don't fully understand what the case is that causes sds.total_pwr to
>> be zero in find_busiest_group, but this patch guards against the
>> divide-by-zero bug.
>>
>> I also added safe-guarding around other routines in the scheduler code
>> where we're dividing by power; that's more of a just-in-case and I'm
>> definitely open for debate on that.
>
> No.. papering over crap like this is not done. In that BZ there's a
> number of suggestions of how/where to track down the actual root cause,
> but apparently nobody is interested in doing that.
>
> (I can't reproduce so I can't actually do anything about it).
>
