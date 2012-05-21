Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab2EUXOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:14:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:47624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab2EUXOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:14:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169403981"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        riel@redhat.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] mm/mpol: Lazy migrate a process/vma
References: <tip-pdhg3wh71m4eu8xerantpvln@git.kernel.org>
Date: Mon, 21 May 2012 16:14:15 -0700
In-Reply-To: <tip-pdhg3wh71m4eu8xerantpvln@git.kernel.org> (tip-bot for Peter
	Zijlstra's message of "Fri, 18 May 2012 03:33:08 -0700")
Message-ID: <m2r4ud86uw.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> +
> +	/*
> +	 * Obtain a more-or-less correct nodemask to find which pages we need
> +	 * to unmap so that MoF can put them right again.
> +	 *
> +	 * Not quite correct for INTERLEAVE, that would need us doing
> +	 * offset_il_node() from check_pte_entry().
> +	 *
> +	 * Also not quite correct for task policies since we don't have a task,
> +	 * approximate by having @node function as local / task-home-node.

Hmm, so this destroys existing numa policies for already running processes?

Andrea's original THP had a similar problem, and it caused serious
performance problems before it was fixed.

I also seem to miss the benchmark numbers justifying all that code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
