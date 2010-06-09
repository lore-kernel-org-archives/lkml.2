Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab0FIRn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 13:43:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756174Ab0FIRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:43:56 -0400
Date: Wed, 9 Jun 2010 10:43:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: tytso@mit.edu
cc: Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       akpm@inux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
In-Reply-To: <20100609173424.GF6162@thunk.org>
Message-ID: <alpine.LFD.2.00.1006091041540.4506@i5.linux-foundation.org>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com> <20100609094850.GA23292@elte.hu> <alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org> <20100609155041.GD6162@thunk.org> <alpine.LFD.2.00.1006090857530.4506@i5.linux-foundation.org>
 <20100609171015.GE6162@thunk.org> <alpine.LFD.2.00.1006091013340.4506@i5.linux-foundation.org> <alpine.LFD.2.00.1006091023341.4506@i5.linux-foundation.org> <20100609173424.GF6162@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, tytso@mit.edu wrote:
> 
> Well, I was thinking about something like this:

No, this is wrong for the case where you end up having to allocate a new 
pidmap and/or overflow max_pid.

It also doesn't set the bit at all.

> There appears to be some interesting uses of the bitmap by
> find_ge_pid() and next_pidmap() that I haven't completely grokked yet,

We need that bitmap to handle the overflow max_pid case. We are _not_ 
returning just increasing pid numbers.

		Linus
