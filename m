Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2KML4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:56:10 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62900 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2KML4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:56:08 -0500
Date: Tue, 13 Nov 2012 12:55:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/8] sched, numa, mm: Add last_cpu to page flags
Message-ID: <20121113115556.GG21522@gmail.com>
References: <20121112160451.189715188@chello.nl>
 <20121112161215.685202629@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121112161215.685202629@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A cleanliness side note, this bit does not belong into this 
patch:

> Index: linux/include/linux/mm_types.h
> ===================================================================
> --- linux.orig/include/linux/mm_types.h
> +++ linux/include/linux/mm_types.h
> @@ -398,6 +403,10 @@ struct mm_struct {
>  #ifdef CONFIG_CPUMASK_OFFSTACK
>  	struct cpumask cpumask_allocation;
>  #endif
> +#ifdef CONFIG_SCHED_NUMA
> +	unsigned long numa_next_scan;
> +	int numa_scan_seq;
> +#endif
>  	struct uprobes_state uprobes_state;
>  };
>  

I've moved it over into the 5th patch.

Thanks,	

	Ingo
