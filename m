Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0J0Pdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:33:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46952 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab0J0Pdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:33:38 -0400
Date: Wed, 27 Oct 2010 17:33:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brian Gerst <brgerst@gmail.com>, tj@kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
Message-ID: <20101027153331.GA21789@elte.hu>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
 <AANLkTim_3vhuJt2gYQEM5p=wxVU1Jsm6reTgQZsu_o7B@mail.gmail.com>
 <20101027153053.GA20243@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027153053.GA20243@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Ingo, can you take care of this all, or should I just take the patch and remove 
> > the multipage stuff manually?
> 
> Sure, i'm queuing up Brian's patch (initially wanted to wait for the NUMA-aware 
> version) and will remove all the multipage pcpu bits - will send you a pull 
> request later today, after a bit of testing.

Btw., the NUMA stuff never really worked percpu alloc, as per Eric's observation:

 | Anyway, I just discovered per_cpu data on my machine (NUMA capable) all sit on a 
 | single node, if 32bit kernel used.

... and in practice it's not really relevant on 32-bit anyway. So we can decouple 
the two issues just fine.

Thanks,

	Ingo
