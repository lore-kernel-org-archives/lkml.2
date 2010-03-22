Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0CVJ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 05:28:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42918 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab0CVJ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 05:28:29 -0400
Date: Mon, 22 Mar 2010 10:28:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: yinghai@kernel.org, benh@kernel.crashing.org, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
Message-ID: <20100322092809.GA20607@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
 <20100321.210023.209981130.davem@davemloft.net>
 <4BA6F1F6.3070102@kernel.org>
 <20100321.213350.176660494.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100321.213350.176660494.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


( Cc:-ed Andrew and Linus as this is a general design/policy matter wrt. 
  memory management. )

* David Miller <davem@davemloft.net> wrote:

> From: Yinghai Lu <yinghai@kernel.org>
> Date: Sun, 21 Mar 2010 21:28:38 -0700
> 
> >> 
> >> That action means you absolutely don't value our feedback at all.
> > 
> > [PATCH 01/20] x86: add find_e820_area_node
> > is addressing your concern that early_res didn't handle memory cross the nodes problem.
> 
> Now I know that you _REALLY_ aren't listening to us.

[ He has done a bit more than just to simply listen: he seems to have written 
  a patch which he thinks is addressing the concerns you pointed out. It might
  not be the response you wished for (and it might be inadequate) for but it
  sure gives me the impression of him listening to you - unless by 'listening' 
  you mean 'follow my exact opinion without argument'. ]

> We said to use LMB because 1) it already exists 2) many platforms have been 
> using it for years and 3) it doesn't lack the features you're now having to 
> add to e820.

The thing is, lib/lmb.c was librarized two years ago by you (much after 
early_res has been written for x86), but was not properly integrated into the 
core kernel nor into x86. It was first suggested by you in the early_res 
context about ten days ago, when Yinghai started posting Sparc64 patches.

Which is about half a year after the whole very difficult early_res/bootmem 
work was started by Yinghai :-(

I dont mind LMB per se, logically it seems quite similar to the early_res bits 
Yinghai has generalized (to a certain degree), and is quite a bit cleaner as 
you are writing very clean code.

Note the other side of the coin: LMB appears to be deployed on only 4 non-x86 
architectures that muster ~1% of the Linux boxes while early_res is deployed 
on more than 95%.

So there's a very real hardship of testing and conversion here that we cannot 
ignore and an even better path may be to gradually transform the more tested 
and more deployed early_res code to meet the interface details of LMB.

Please also realize the difficulties Yinghai has gone through already: 
converting and generalizing _all_ of the x86 early allocation code to a more 
generic core kernel approach, with essentially zero interest from _any_ 
non-x86 person ...

Those early_res patches were posted all over on lkml, it was literally 
hundreds of difficult patches, and now, months down the line, after we've 
tested and upstreamed it (with many nasty regressions fixed on x86 during the 
development of it) you come with a rigid "do it some other way, convert all of 
x86 over again or else" position.

I really wish non-x86 architectures apprecitated (and helped) the core kernel 
work x86 is doing, because it is subsidizing non-x86 architectures all the 
time.

For example when LMB was plopped into lib/lmb.c in 2008 why was it not ported 
to x86, our most popular architecture? Did you consider posting LMB patches 
for x86 instead of expecting Yinghai to post Sparc64, PowerPC, SH and 
Microblaze patches?

Anyway, i'm sure we can work out an approach, and yes, LMB looks pretty good 
and could be picked up if it can be done gradually - given some mutual 
willingness to work on this as equals.

Thanks,

	Ingo
