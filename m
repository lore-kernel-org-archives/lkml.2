Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2KUSEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:04:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44397 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2KUSEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:04:39 -0500
Date: Wed, 21 Nov 2012 19:04:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
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
Message-ID: <20121121180432.GA29590@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <alpine.DEB.2.00.1211191644340.24618@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1211191703270.24618@chino.kir.corp.google.com>
 <20121120060014.GA14065@gmail.com>
 <alpine.DEB.2.00.1211192213420.5498@chino.kir.corp.google.com>
 <20121120074445.GA14539@gmail.com>
 <alpine.DEB.2.00.1211200001420.16449@chino.kir.corp.google.com>
 <20121120090637.GA14873@gmail.com>
 <CA+55aFyR9FsGYWSKkgsnZB7JhheDMjEQgbzb0gsqawSTpetPvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyR9FsGYWSKkgsnZB7JhheDMjEQgbzb0gsqawSTpetPvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...] And not look at vsyscalls or anything, but look at what 
> schednuma does wrong!

I have started 4 independent lines of inquiry to figure out 
what's wrong on David's system, and all four are in the category 
of 'what does our tree do to cause a regression':

  - suboptimal (== regressive) 4K fault handling by numa/core

  - suboptimal (== regressive) placement by numa/core on David's 
    assymetric-topology system

  - vsyscalls escallating numa/core page fault overhead
    non-linearly

  - TLB flushes escallating numacore page fault overhead
    non-linearly

I have sent patches for 3 of them, one is still work in 
progress, because it's non-trivial.

I'm absolutely open to every possibility and obviously any 
regression is numa/core's fault, full stop.

What would you have done differently to handle this particular 
regression?

Thanks,

	Ingo
