Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2KTQwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:52:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33421 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2KTQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:52:45 -0500
Date: Tue, 20 Nov 2012 17:52:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH, v2] mm, numa: Turn 4K pte NUMA faults into effective
 hugepage ones
Message-ID: <20121120165239.GA18345@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <20121119191339.GA11701@gmail.com>
 <20121119211804.GM8218@suse.de>
 <20121119223604.GA13470@gmail.com>
 <CA+55aFzQYH4qW_Cw3aHPT0bxsiC_Q_ggy4YtfvapiMG7bR=FsA@mail.gmail.com>
 <20121120071704.GA14199@gmail.com>
 <20121120152933.GA17996@gmail.com>
 <20121120160918.GA18167@gmail.com>
 <50ABB06A.9000402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50ABB06A.9000402@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> Performance measurements will show us how much of an impact it 
> makes, since I don't think we have never done apples to apples 
> comparisons with just this thing toggled :)

I've done a couple of quick measurements to characterise it: as 
expected this patch simply does not matter much when THP is 
enabled - and most testers I worked with had THP enabled.

Testing with THP off hurst most NUMA workloads dearly and tells 
very little about the real NUMA story of these workloads. If you 
turn off THP you are living with a constant ~25% regression - 
just check the THP and no-THP numbers I posted:

                [ 32-warehouse SPECjbb test benchmarks ]

      mainline:                 395 k/sec
      mainline +THP:            524 k/sec

      numa/core +patch:         512 k/sec     [ +29.6% ]
      numa/core +patch +THP:    654 k/sec     [ +24.8% ]

The group of testers who had THP disabled was thus very low - 
maybe only Mel alone? The testers I worked with all had THP 
enabled.

I'd encourage everyone to report unusual 'tweaks' done before 
tests are reported - no matter how well intended the purpose of 
that tweak. There's just so many config variations we can test 
and we obviously check the most logically and most scalably 
configured system variants first.

Thanks,

	Ingo
