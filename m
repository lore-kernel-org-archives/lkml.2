Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2LCRLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:11:34 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38919 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab2LCRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:11:32 -0500
Date: Mon, 3 Dec 2012 18:11:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/52] RFC: Unified NUMA balancing tree, v1
Message-ID: <20121203171126.GA18394@gmail.com>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
 <50BCCAA3.6060604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BCCAA3.6060604@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> >Rik van Riel (1):
> >   sched, numa, mm: Add credits for NUMA placement
> 
> Where did the TLB flush optimizations go? :)

They are still very much there, unchanged for a long time and 
acked by everyone - I thought I'd spare a few electrons by not 
doing a 60+ patches full resend.

Here is how it looks like in the full diffstat:

 Rik van Riel (6):
      mm/generic: Only flush the local TLB in ptep_set_access_flags()
      x86/mm: Only do a local tlb flush in ptep_set_access_flags()
      x86/mm: Introduce pte_accessible()
      mm: Only flush the TLB when clearing an accessible pte
      x86/mm: Completely drop the TLB flush from ptep_set_access_flags()
      sched, numa, mm: Add credits for NUMA placement

I'm really fond of these btw., they make a real difference.

Thanks,

	Ingo
