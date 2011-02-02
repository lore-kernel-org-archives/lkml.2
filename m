Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1BBKxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:53:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62276 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1BBKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:53:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ikZ66mX2GQIlUT23dnep4AkeIQZ4vMKPoXsNzvwJUuBLIAI4Nyk14mIioY3fDBV/eB
         KJd5RfJMASsPOImNhFqpCQb3blMOBd29GkTnHyT0l4H5tNqxjTmZDhB09PXOozhkf7Bb
         ynoKmqke9a6BBTFKFWV/+lUzJZOS19vMFpTDY=
Date: Wed, 2 Feb 2011 11:53:03 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 08/10] ptrace: participate in group stop from
 ptrace_stop() iff the task is trapping for group stop
Message-ID: <20110202105303.GD24115@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-9-git-send-email-tj@kernel.org>
 <20110128213009.340C7183C1E@magilla.sf.frob.com>
 <20110131112634.GG7459@htj.dyndns.org>
 <20110202055711.368B6183D88@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202055711.368B6183D88@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 01, 2011 at 09:57:11PM -0800, Roland McGrath wrote:
> > The problem is that those loose ends can't be tied up without breaking
> > the current users.  PTRACE_CONT has priority over group stop and it's
> > a very visible from userland.  I'm afraid the window of opportunity to
> > make that behavior the default had already passed quite some time ago.
> 
> I am not convinced of that at all, though I certainly wouldn't say now
> that it's a settled question yet.  The userland expectations are
> pretty convoluted too.  I suspect that what you are calling the
> userland expectations for PTRACE_CONT to ignore the state of a pending
> group stop are in fact just fallout of userland confusion about what's
> a job control stop and what's a ptrace stop.

Okay, but that doesn't change the fact that currently PTRACE_CONT is
superior to group stop.  You're suggesting to reverse the priority.  I
can't see how that would be possible.  I'm confused because that's a
_MUCH_ bigger change than the ones suggested here or in the whole
series.  If we can change that, it's almost free for all, which I
dont't mind, but isn't consistent with how things have progressed upto
now.

We can introduce new interface which behaves that way but I don't
think we can reverse the priority without breaking a lot of userland
visible behaviors.

> I don't think I follow your logic and I certainly don't agree with
> your conclusion.  It's simple: if a stop signal is actually delivered,
> then every thread stops.  If one thread is traced and another is not,
> then the tracer can prevent a signal from being delivered to one
> thread and cannot prevent it from being delivered to another.

I suppose it depends on POV and I can see your point too.

> > > Once a group stop is complete, then probably the ideal is that
> > > PTRACE_CONT would not resume a thread until a real SIGCONT cleared
> > > the job control stop condition.  But it's likely that existing
> > > ptrace users have expectations contrary to that, so we'll have to
> > > see.
> > 
> > So, no, I don't think that would be possible or even desirable.
> 
> Of course it's possible.  We have to work out the entire web of
> assumptions and ramifications to be sure what's desireable given
> practical compatibility constraints.  I think it's just plain obvious
> that it's the desireable thing in the abstract--that tracing stops and
> job control stops should be independent functions.

You'll have to show a lot more details on how to untangle "the entire
web of assumptions and ramifications" so that we can reverse the
current priority without causing noticeable behavior differences to
the existing users.  I don't agree what you suggest is "plain
obviously desirable" but that's almost beside the point.  I really
can't see how that would be realistically possible at this point.

So, can you please elaborate how to reverse that and at the same time
avoid breaking existing assumptions?

Thanks.

-- 
tejun
