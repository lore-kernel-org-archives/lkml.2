Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1HLRKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:10:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab1HLRKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:10:04 -0400
Date: Fri, 12 Aug 2011 19:09:58 +0200
From: Andrew Jones <drjones@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] ktest: Introduce PASS_COUNT
Message-ID: <20110812170958.GA18363@turtle.usersys.redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
 <1313155932-20092-8-git-send-email-drjones@redhat.com>
 <1313167785.18583.336.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313167785.18583.336.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 12:49:45PM -0400, Steven Rostedt wrote:
> On Fri, 2011-08-12 at 15:32 +0200, Andrew Jones wrote:
> > Add another config variable that defines the number of times a test
> > must pass before it really passes. This is good for boot tests, where
> > the failure doesn't occur every time.
> 
> I'm curious to how this is really different than the ITERATE keyword.
> 
> That is, if we had:
> 
> TEST_START ITERATE 10
> TEST_TYPE = test
> TEST = ssh root@box "/work/runtest"
> 
> Hmm, is this to help in the bisects?

Right. I played with ITERATE, but it didn't look like it would work
for bisecting boot problems that may fail once in some number of
boots. Perhaps I missed something though.

> 
> Maybe it should be called ITERATE as well, just to be consistent.
> 
> TEST_START
> TEST_TYPE = bisect
> ITERATE = 10
> 
> ??
> 
> Or maybe that is confusing too, as that could be used to do the iterate
> within the TEST_START (hmm, I may add that).
> 
> How about PASS_THRESHOLD? or PASS_COUNT_THRESHOLD? As I think that may
> be more descriptive.

PASS_THRESHOLD sounds good. Should I respin with that change now? Or are
you still considering a different design?

> 
> /me rereads his email and sees that he has a tendency to talk to
> himself.
>

/me wonders if he answered himself with a different design idea, so will
hold off on the updated patch for the moment.

Drew
> 
> -- Steve
> 
> 
