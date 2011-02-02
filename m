Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1BBFjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:39:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab1BBFjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:39:35 -0500
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
In-Reply-To: Tejun Heo's message of  Monday, 31 January 2011 16:41:17 +0100 <20110131154117.GK7459@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
	<20110118021417.D347A1807B7@magilla.sf.frob.com>
	<20110127154600.GE24925@htj.dyndns.org>
	<20110127174857.GG24925@htj.dyndns.org>
	<20110128204030.52D31183C1E@magilla.sf.frob.com>
	<20110131154117.GK7459@htj.dyndns.org>
X-Windows: complex nonsolutions to simple nonproblems.
Message-Id: <20110202053931.3E6BC183D88@magilla.sf.frob.com>
Date: Tue,  1 Feb 2011 21:39:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, the first test of xcheck seems to enter infinite loop.

It's a test for race-condition bugs, where the original test was to run the
infinite loop until it crashed.  As now written, it runs the loop until
$TESTTIME seconds have passed, defaulting to 10.  With various buggy
kernels in various configurations and on various machines, the time it
takes to get to a crash has varied widely.

> I see.  Yeah, if there are users which expect /proc/pid/status to be
> certain value, we can either emulate it or delay TRACED transition to
> the next PTRACE call *after* ATTACH/wait(2) sequence, but I think both
> are quite ugly and would like to avoid if at all possible.

I agree.  We just need to be more clearly sure about userland requirements
before we make changes.  I hope the answer is that nothing other than these
synthetic test cases actually relies on which one /proc/pid/status reports.
(That is, if they do check it, they only notice the "T".)


Thanks,
Roland
