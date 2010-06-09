Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab0FIR0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 13:26:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757946Ab0FIR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:26:14 -0400
Date: Wed, 9 Jun 2010 10:25:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: tytso@mit.edu
cc: Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       akpm@inux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
In-Reply-To: <alpine.LFD.2.00.1006091013340.4506@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006091023341.4506@i5.linux-foundation.org>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com> <20100609094850.GA23292@elte.hu> <alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org> <20100609155041.GD6162@thunk.org> <alpine.LFD.2.00.1006090857530.4506@i5.linux-foundation.org>
 <20100609171015.GE6162@thunk.org> <alpine.LFD.2.00.1006091013340.4506@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Linus Torvalds wrote:
>
> Otherwise you have three threads, two of which pick the same pid (because 
> the test-and-set isn't atomic), and a third of which picks a new one.

In fact, I don't think you need three threads at all. It's perfectly ok to 
just have two threads, and they'd both end up picking the same 'pid' 
without the atomicity guarantees of that 'test_and_set()' bitmap access.

And they'd both be perfectly fine setting last_pid to that (shared) pid if 
I read that cmpxchg loop right. No?

		Linus
