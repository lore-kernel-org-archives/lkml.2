Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0ETRwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:52:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983Ab0ETRwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:52:53 -0400
Date: Thu, 20 May 2010 10:49:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [RFC PATCH] fuse: support splice() reading from fuse device
In-Reply-To: <E1OF3kc-00084X-Hi@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.2.00.1005201043321.23538@i5.linux-foundation.org>
References: <E1OF3kc-00084X-Hi@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 May 2010, Miklos Szeredi wrote:
> 
> With Jens' pipe growing patch and additional fuse patches it was
> possible to achieve a 20GBytes/s write throghput on my laptop in a
> "null" filesystem (no page cache, data goes to /dev/null).

Btw, I don't think that is a very interesting benchmark.

The reason I say that is that many man years ago I played with doing 
zero-copy pipe read/write system calls (no splice, just automatic "follow 
the page tables, mark things read-only etc" things). It was considered 
sexy to do things like that during the mid-90's - there were all the crazy 
ukernel people with Mach etc doing magic things with moving pages around.

It got me a couple of gigabytes per second back then (when memcpy() speeds 
were in the tens of megabytes) on benchmarks like lmbench that just wrote 
the same buffer over and over again without ever touching the data.

It was totally worthless on _any_ real load. In fact, it made things 
worse. I never found a single case where it helped.

So please don't ever benchmark things that don't make sense, and then use 
the numbers as any kind of reason to do anything. It's worse than 
worthless. It actually adds negative value to show "look ma, no hands" for 
things that nobody does. It makes people think it's a good idea, and 
optimizes the wrong thing entirely.

Are there actual real loads that get improved? I don't care if it means 
that the improvement goes from three orders of magnitude to just a couple 
of percent. The "couple of percent on actual loads" is a lot more 
important than "many orders of magnitude on a made-up benchmark".

		Linus
