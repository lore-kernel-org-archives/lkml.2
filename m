Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab0FIPuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:50:52 -0400
Received: from THUNK.ORG ([69.25.196.29]:49846 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab0FIPuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:50:51 -0400
Date: Wed, 9 Jun 2010 11:50:41 -0400
From: tytso@mit.edu
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       akpm@inux-foundation.org, linux-kernel@vger.kernel.org,
       tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100609155041.GD6162@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
	akpm@inux-foundation.org, linux-kernel@vger.kernel.org,
	tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
 <20100609094850.GA23292@elte.hu>
 <alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 08:39:00AM -0700, Linus Torvalds wrote:
> 
> So I had to read the patch _and_ go read the code it patched, in order to 
> at all understand what it did. I think the patch explanation should have 
> done it, and I also think this would need a bit comment at the top.
> 
> [ In fact, I'd argue that the _old_ code would have needed a big comment 
>   at the top about last_pid usage, but i somebody had done that, they'd 
>   probably also have seen the race while explaning how the code worked ;]
>

Salman had created a very nice ASCII art diagram of the race in the
mail thread with the internal bug reporter who noticed the problem.
We could include that, if you don't mind the commit description
growing by 30-40 lines.  :-) I agree though that better documentation
n the source code about _how_ alloc_pidmap was supposed to avoid all
possible races would have probably been a good idea.

> [ Or Ted's version: as mentioned, I don't think the complexity is actually 
>   in the final cmpxchg loop itself, but in the bigger picture, so I don't 
>   think the differences between Ted's and Salman's versions are that big ]

Yah, I had been staring at the code for a while, so I had the feeling
that my intuition of which patch would be clearer was probably biased.

We do need to deal with pid wrap possibility just to be completely
correct, although the chance of hitting _that_ are pretty remote.

	 	      	     		- Ted
