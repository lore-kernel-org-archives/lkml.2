Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2KTHRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:17:12 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64385 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2KTHRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:17:11 -0500
Date: Tue, 20 Nov 2012 08:17:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>,
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
Message-ID: <20121120071704.GA14199@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <20121119191339.GA11701@gmail.com>
 <20121119211804.GM8218@suse.de>
 <20121119223604.GA13470@gmail.com>
 <CA+55aFzQYH4qW_Cw3aHPT0bxsiC_Q_ggy4YtfvapiMG7bR=FsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzQYH4qW_Cw3aHPT0bxsiC_Q_ggy4YtfvapiMG7bR=FsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Nov 19, 2012 at 12:36 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Hugepages is a must for most forms of NUMA/HPC. This alone
> > questions the relevance of most of your prior numa/core testing
> > results. I now have to strongly dispute your other conclusions
> > as well.
> 
> Ingo, stop doing this kind of crap.
> 
> Let's make it clear: if the NUMA patches continue to regress 
> performance for reasonable loads (and that very much includes 
> "no THP") then they won't be merged.
> 
> You seem to be in total denial. Every time Mel sends out 
> results that show that your patches MAKE PERFORMANCE WORSE you 
> blame Mel, or blame the load, and never seem to admit that 
> performance got worse.

No doubt numa/core should not regress with THP off or on and 
I'll fix that.

As a background, here's how SPECjbb gets slower on mainline 
(v3.7-rc6) if you boot Mel's kernel config and turn THP forcibly
off:

  (avg: 502395 ops/sec)
  (avg: 505902 ops/sec)
  (avg: 509271 ops/sec)

  # echo never > /sys/kernel/mm/transparent_hugepage/enabled

  (avg: 376989 ops/sec)
  (avg: 379463 ops/sec)
  (avg: 378131 ops/sec)

A ~30% slowdown.

[ How do I know? I asked for Mel's kernel config days ago and
  actually booted Mel's very config in the past few days, 
  spending hours on testing it on 4 separate NUMA systems, 
  trying to find Mel's regression. In the past Mel was a 
  reliable tester so I blindly trusted his results. Was that 
  some weird sort of denial on my part? :-) ]

Every time a regression is reported I take it seriously - and 
there were performance regression reports against numa/core not 
just from Mel and I'm sure there will be more in the future. For 
example I'm taking David Rijentje's fresh performance regression 
report seriously as well.

What I have some problem with is Mel sending me his kernel 
config as the thing he tested, and which config included:

  CONFIG_TRANSPARENT_HUGEPAGE=y
  CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y

but he apparently went and explicitly disabled THP on top of 
that - which was just a weird choice of 'negative test tuning' 
to keep unreported. That made me waste quite some time booting 
and debugging his config and made the finding of the root cause 
of the testing difference unnecessarily hard for me.

Again, that's not an excuse for the performance regression in 
the numa/core tree in any way and I'll fix it.

Thanks,

	Ingo
