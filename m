Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2KULO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:14:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab2KULO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:14:57 -0500
Date: Wed, 21 Nov 2012 11:14:50 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
Message-ID: <20121121111450.GW8218@suse.de>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <20121119191339.GA11701@gmail.com>
 <20121119211804.GM8218@suse.de>
 <20121119223604.GA13470@gmail.com>
 <CA+55aFzQYH4qW_Cw3aHPT0bxsiC_Q_ggy4YtfvapiMG7bR=FsA@mail.gmail.com>
 <20121120071704.GA14199@gmail.com>
 <alpine.DEB.2.00.1211192329090.14460@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211192329090.14460@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 11:37:01PM -0800, David Rientjes wrote:
> On Tue, 20 Nov 2012, Ingo Molnar wrote:
> 
> > No doubt numa/core should not regress with THP off or on and 
> > I'll fix that.
> > 
> > As a background, here's how SPECjbb gets slower on mainline 
> > (v3.7-rc6) if you boot Mel's kernel config and turn THP forcibly
> > off:
> > 
> >   (avg: 502395 ops/sec)
> >   (avg: 505902 ops/sec)
> >   (avg: 509271 ops/sec)
> > 
> >   # echo never > /sys/kernel/mm/transparent_hugepage/enabled
> > 
> >   (avg: 376989 ops/sec)
> >   (avg: 379463 ops/sec)
> >   (avg: 378131 ops/sec)
> > 
> > A ~30% slowdown.
> > 
> > [ How do I know? I asked for Mel's kernel config days ago and
> >   actually booted Mel's very config in the past few days, 
> >   spending hours on testing it on 4 separate NUMA systems, 
> >   trying to find Mel's regression. In the past Mel was a 
> >   reliable tester so I blindly trusted his results. Was that 
> >   some weird sort of denial on my part? :-) ]
> > 
> 
> I confirm that numa/core regresses significantly more without thp than the 
> 6.3% regression I reported with thp in terms of throughput on the same 
> system.  numa/core at 01aa90068b12 ("sched: Use the best-buddy 'ideal cpu' 
> in balancing decisions") had 99389.49 SPECjbb2005 bops whereas 
> ec05a2311c35 ("Merge branch 'sched/urgent' into sched/core") had 122246.90 
> SPECjbb2005 bops, a 23.0% regression.
> 

I also see different regressions and gains depending on the number of
warehouses. For low number of warehouses without THP the regression was
severe but flat for higher number of warehouses. I explained in another
mail that specjbb reports based on peak figures and regressions outside
the peak can be missed as a result so we should watch out for that.

-- 
Mel Gorman
SUSE Labs
