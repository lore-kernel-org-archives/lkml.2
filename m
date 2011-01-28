Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1A1Ukk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:40:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab1A1Ukf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:40:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
In-Reply-To: Tejun Heo's message of  Thursday, 27 January 2011 18:48:57 +0100 <20110127174857.GG24925@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
	<20110118021417.D347A1807B7@magilla.sf.frob.com>
	<20110127154600.GE24925@htj.dyndns.org>
	<20110127174857.GG24925@htj.dyndns.org>
X-Zippy-Says: I love ROCK 'N ROLL!  I memorized the all WORDS to ``WIPE-OUT'' in 1965!!
Message-Id: <20110128204030.52D31183C1E@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 12:40:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Okay, just finished ran make check with and without the patchset.
> Without the patchset, 2.6.38-rc2 failed five tests.  

Hmm.  I didn't think we were in that poor a state, but it has been quite a
while since I looked.  I wonder if that's a regression from a few releases
back, or what.  Oleg and Jan should know better than I do about the state
of these tests.

> With the patchset six.  The one extra test which failed was
> attach-sigcont-wait because the tracee now always enters TRACED after
> PTRACE_ATTACH, which I think is the correct behavior because the previous
> behavior where a stopped task honors SIGCONT unconditionally if it was
> delivered before the next ptrace call (any operation other than detach)
> doesn't make any sense to me in addition to the fact that it was buggy
> regarding the arch hook.

Well, I can't say I'm at all sure I agree with your assessment about that.
But we can investigate further before I make any particular assertions.

> Is there an actual use case which requires this behavior?  We can try
> to emulate the original behavior but I don't think it's a sane one.

Most of those cases were added when Jan ran into a particular problem while
working on GDB, and some of them from issues that arose with ptrace.  Jan
is probably the person who knows best about the requirements each test was
meant to verify.

> Another difference was how stopped-detach-sleeping failed.  It failed
> both with and without the patchset but with the patchset it triggered
> an assert().  The difference was because the assert() was testing
> whether the task was in STOPPED state after attach - it's now in
> TRACED state instead.  With the assert removed, it failed the same
> way.

This is probably something that can change in the test.  I think some of
those /proc/pid/status checks in the tests were either just to match
expectations based on manifest kernel behavior, but they might also have
been because it really did matter somehow and it was just easier to discern
that way than to write a test that reliably found the important race
condition or whatever it was.  So again we need Jan to help us understand
the intent of the test and the specific GDB requirements it represents.


Thanks,
Roland
