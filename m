Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab0DAQBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:01:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757277Ab0DAQAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:00:53 -0400
Date: Thu, 1 Apr 2010 08:55:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@gmail.com>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Subject: Re: Is module refcounting racy?
In-Reply-To: <20100401080940.GA8356@laptop>
Message-ID: <alpine.LFD.2.00.1004010852170.3707@i5.linux-foundation.org>
References: <20100318105533.GE25636@laptop> <201003291942.56706.rusty@rustcorp.com.au> <e619185d1003290958w23037176uc869c7dbc0a48bcc@mail.gmail.com> <201003311414.49364.rusty@rustcorp.com.au> <20100401080940.GA8356@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Apr 2010, Nick Piggin wrote:
> 
> I think it can be done racelessly with my patch, which is not really too
> much overhead. I think if this is considered too much, then we should
> either fix code and preferably de-export and remove module_refcount from
> drivers, or remove module removal completely.

I doubt your patch matters too much, but I like it conceptually and it 
seems to be a nice basis for perhaps doing something clever in the long 
run.

[ ie avoiding the stop_machine and instead perhaps doing some optimistic 
  thing like "see if we seem to be unused right now, then unregister us, 
  and see - after unregistering - that the usage counts haven't increased, 
  and re-register if they have. ]

So I'd like to apply it as a "good improvement, even if module unloading 
which is the only thing that _should_ care deeply should already be under 
stop-machine".

But I'd like an ack or two first.

		Linus
