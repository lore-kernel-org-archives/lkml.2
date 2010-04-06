Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0DFFGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:06:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:38702 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab0DFFGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:06:05 -0400
Date: Tue, 6 Apr 2010 15:05:49 +1000
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@gmail.com>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Subject: Re: Is module refcounting racy?
Message-ID: <20100406050549.GA11191@laptop>
References: <20100318105533.GE25636@laptop>
 <201003291942.56706.rusty@rustcorp.com.au>
 <e619185d1003290958w23037176uc869c7dbc0a48bcc@mail.gmail.com>
 <201003311414.49364.rusty@rustcorp.com.au>
 <20100401080940.GA8356@laptop>
 <alpine.LFD.2.00.1004010852170.3707@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004010852170.3707@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 08:55:59AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 Apr 2010, Nick Piggin wrote:
> > 
> > I think it can be done racelessly with my patch, which is not really too
> > much overhead. I think if this is considered too much, then we should
> > either fix code and preferably de-export and remove module_refcount from
> > drivers, or remove module removal completely.
> 
> I doubt your patch matters too much, but I like it conceptually and it 
> seems to be a nice basis for perhaps doing something clever in the long 
> run.
> 
> [ ie avoiding the stop_machine and instead perhaps doing some optimistic 
>   thing like "see if we seem to be unused right now, then unregister us, 
>   and see - after unregistering - that the usage counts haven't increased, 
>   and re-register if they have. ]

That's true, reducing the requirement for stop_machine is always a nice
thing to have.

Also if anyone else is looking at a way to do _really_ scalable
refcounting elsewhere, this could be a good template (I certainly looked
here first when trying to get ideas for vfsmount refcounting).

 
> So I'd like to apply it as a "good improvement, even if module unloading 
> which is the only thing that _should_ care deeply should already be under 
> stop-machine".
> 
> But I'd like an ack or two first.

Sure, I'll let Rusty push it to you when he's happy with it.

