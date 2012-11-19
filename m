Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2KSWgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:36:13 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49868 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2KSWgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:36:12 -0500
Date: Mon, 19 Nov 2012 23:36:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
Message-ID: <20121119223604.GA13470@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <20121119191339.GA11701@gmail.com>
 <20121119211804.GM8218@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119211804.GM8218@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> Ok.
> 
> In response to one of your later questions, I found that I had 
> in fact disabled THP without properly reporting it. [...]

Hugepages is a must for most forms of NUMA/HPC. This alone 
questions the relevance of most of your prior numa/core testing 
results. I now have to strongly dispute your other conclusions 
as well.

Just a look at 'perf top' output should have told you the story.

Yet time and time again you readily reported bad 'schednuma' 
results for a slow 4K memory model that neither we nor other 
NUMA testers I talked to actually used, without stopping to look 
why that was so...

[ I suspect that if such terabytes-of-data workloads are forced 
  through such a slow 4K pages model then there's a bug or 
  mis-tuning in our code that explains the level of additional 
  slowdown you saw - we'll fix that.

  But you should know that behavior under the slow 4K model 
  tells very little about the true scheduling and placement 
  quality of the patches... ]

Please report proper THP-enabled numbers before continuing.

Thanks,

	Ingo
