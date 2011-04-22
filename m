Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1DVQ7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:59:19 -0400
Received: from mail.sharma-home.net ([184.82.71.199]:51636 "EHLO
	sharma-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab1DVQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:59:18 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Apr 2011 12:59:18 EDT
Date: Fri, 22 Apr 2011 09:50:07 -0700
From: arun@sharma-home.net
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110422165007.GA18401@vps.sharma-home.net>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422105211.GB1948@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 12:52:11PM +0200, Ingo Molnar wrote:
> 
> Using the generalized cache events i can run:
> 
>  $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array
> 
>  Performance counter stats for './array' (10 runs):
> 
>          6,719,130 cycles:u                   ( +-   0.662% )
>          5,084,792 instructions:u           #      0.757 IPC     ( +-   0.000% )
>          1,037,032 l1-dcache-loads:u          ( +-   0.009% )
>          1,003,604 l1-dcache-load-misses:u    ( +-   0.003% )
> 
>         0.003802098  seconds time elapsed   ( +-  13.395% )
> 
> I consider that this is 'bad', because for almost every dcache-load there's a 
> dcache-miss - a 99% L1 cache miss rate!

One could argue that all you need is cycles and instructions. If there is an
expensive load, you'll see that the load instruction takes many cycles and
you can infer that it's a cache miss.

Questions app developers typically ask me:

* If I fix all my top 5 L3 misses how much faster will my app go?
* Am I bottlenecked on memory bandwidth?
* I have 4 L3 misses every 1000 instructions and 15 branch mispredicts per
  1000 instructions. Which one should I focus on?

It's hard to answer some of these without access to all events.
While your approach of having generic events for commonly used counters
might be useful for some use cases, I don't see why exposing all vendor
defined events is harmful.

A clear statement on the last point would be helpful.

 -Arun
