Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2KUTjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:39:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab2KUTjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:39:13 -0500
Date: Wed, 21 Nov 2012 19:39:08 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 36/46] mm: numa: Use a two-stage filter to restrict pages
 being migrated for unlikely task<->node relationships
Message-ID: <20121121193908.GN8218@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <1353493312-8069-37-git-send-email-mgorman@suse.de>
 <20121121182537.GB29893@gmail.com>
 <20121121191547.GM8218@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121121191547.GM8218@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 07:15:47PM +0000, Mel Gorman wrote:
> I've added a note now to that effect now. For all the patches with notes
> or any other ones, I'll be very happy to add the Signed-offs back on if
> the original authors acknowledge they are ok with the end result. If you
> recall, in the original V1 of this series I said;
> 
> 	This series steals very heavily from both autonuma and schednuma
> 	with very little original code. In some cases I removed the
> 	signed-off-bys because the result was too different. I have noted
> 	in the changelog where this happened but the signed-offs can be
> 	restored if the original authors agree.
> 
> Just to compare, this is the wording in "autonuma: memory follows CPU
> algorithm and task/mm_autonuma stats collection"
> 
> +/*
> + * In this function we build a temporal CPU_node<->page relation by
> + * using a two-stage autonuma_last_nid filter to remove short/unlikely
> + * relations.
> + *
> + * Using P(p) ~ n_p / n_t as per frequentest probability, we can
> + * equate a node's CPU usage of a particular page (n_p) per total
> + * usage of this page (n_t) (in a given time-span) to a probability.
> + *
> + * Our periodic faults will then sample this probability and getting
> + * the same result twice in a row, given these samples are fully
> + * independent, is then given by P(n)^2, provided our sample period
> + * is sufficiently short compared to the usage pattern.
> + *
> + * This quadric squishes small probabilities, making it less likely
> + * we act on an unlikely CPU_node<->page relation.
> + */
> 
> If this was the basis for the sched/numa patch then I'd point out that
> I'm not the only person that failed to preserve history perfectly.
> 

Which to be clear, it isn't. The original source is sched/numa according
to https://lkml.org/lkml/2012/8/22/629 

-- 
Mel Gorman
SUSE Labs
