Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab0FIRKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 13:10:25 -0400
Received: from THUNK.ORG ([69.25.196.29]:43533 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0FIRKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:10:24 -0400
Date: Wed, 9 Jun 2010 13:10:15 -0400
From: tytso@mit.edu
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       akpm@inux-foundation.org, linux-kernel@vger.kernel.org,
       tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100609171015.GE6162@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
	akpm@inux-foundation.org, linux-kernel@vger.kernel.org,
	tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
 <20100609094850.GA23292@elte.hu>
 <alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org>
 <20100609155041.GD6162@thunk.org>
 <alpine.LFD.2.00.1006090857530.4506@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006090857530.4506@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 09:06:37AM -0700, Linus Torvalds wrote:
> 
> That seems to be purely an artifact of the cleverness of avoiding re-doing 
> the whole loop, no? If we _had_ re-done the whole loop (the "normal" 
> cmpxchg model), we would have re-started the whole pid search and handled 
> the overflow in the existing overflow handling code.

This brings up a question.  If we're going to use a cmpxchg() loop, is
there any point to doing the test-and-set game with the bitmap?  It
should be just as fast to just use cmpxchg as it is to do the
test-and-set, and isn't it more likely that various CPU architectures
will have the cmpxchg than test-and-set-bit?

We might be able to radically simplify alloc_pidmap().  Would that
cause a huge problem on some non-Intel architectures, though?

					- Ted
