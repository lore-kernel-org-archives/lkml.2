Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab2KAKtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:49:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab2KAKtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:49:50 -0400
Date: Thu, 1 Nov 2012 10:49:45 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 07/31] sched, numa, mm, s390/thp: Implement pmd_pgprot()
 for s390
Message-ID: <20121101104945.GQ3888@suse.de>
References: <20121025121617.617683848@chello.nl>
 <20121025124832.996734608@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121025124832.996734608@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:16:24PM +0200, Peter Zijlstra wrote:
> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> This patch adds an implementation of pmd_pgprot() for s390,
> in preparation to future THP changes.
> 

The additional pmd_pgprot implementations only are necessary if we want
to preserve the PROT_NONE protections across a split but that somewhat
forces that PROT_NONE be used as the protection bit across all
architectures. Is that possible? I think I would prefer that
prot-protection-across-splits just went away until it was proven
necessary and potentially recoded in terms of _PAGE_NUMA and friends
instead.

-- 
Mel Gorman
SUSE Labs
