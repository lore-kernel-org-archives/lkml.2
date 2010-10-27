Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab0J0PbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:31:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56920 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab0J0PbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:31:07 -0400
Date: Wed, 27 Oct 2010 17:30:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brian Gerst <brgerst@gmail.com>, tj@kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
Message-ID: <20101027153053.GA20243@elte.hu>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
 <AANLkTim_3vhuJt2gYQEM5p=wxVU1Jsm6reTgQZsu_o7B@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim_3vhuJt2gYQEM5p=wxVU1Jsm6reTgQZsu_o7B@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Oct 26, 2010 at 10:43 PM, Brian Gerst <brgerst@gmail.com> wrote:
> > The percpu allocator cannot handle alignments larger than one page.
> > Allocate the irq stacks seperately, and only keep the pointers as
> > percpu data.
> 
> Ok, so I definitely want this (although it sounds like it would be good to do the 
> allocation numa-aware - possibly a separate issue).
> 
> However, I also want to remove all the crap that got added for the multi-page 
> percpu support. It was ugly, and apparently never really worked. All the 
> PER_CPU_MULTIPAGE_ALIGNED crud just needs to go away.
> 
> Ingo, can you take care of this all, or should I just take the patch and remove 
> the multipage stuff manually?

Sure, i'm queuing up Brian's patch (initially wanted to wait for the NUMA-aware 
version) and will remove all the multipage pcpu bits - will send you a pull request 
later today, after a bit of testing.

Thanks,

	Ingo
