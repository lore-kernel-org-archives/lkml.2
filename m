Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2HJAu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 20:50:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:53882 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2HJAu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 20:50:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,743,1336374000"; 
   d="scan'208";a="183867285"
From: Andi Kleen <andi@firstfloor.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@kernel.org, riel@redhat.com,
        oleg@redhat.com, pjt@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] mm/mpol: Remove NUMA_INTERLEAVE_HIT
References: <20120731191204.540691987@chello.nl>
	<20120731192808.459705289@chello.nl>
	<20120809214111.GF10459@redhat.com>
Date: Thu, 09 Aug 2012 17:50:55 -0700
In-Reply-To: <20120809214111.GF10459@redhat.com> (Andrea Arcangeli's message
	of "Thu, 9 Aug 2012 23:41:11 +0200")
Message-ID: <m2ipcrd0y8.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <aarcange@redhat.com> writes:

> Hi,
>
> On Tue, Jul 31, 2012 at 09:12:06PM +0200, Peter Zijlstra wrote:
>> Since the NUMA_INTERLEAVE_HIT statistic is useless on its own; it wants
>> to be compared to either a total of interleave allocations or to a miss
>> count, remove it.
>> 
>> Fixing it would be possible, but since we've gone years without these
>> statistics I figure we can continue that way.
>> 
>> Also NUMA_HIT fully includes NUMA_INTERLEAVE_HIT so users might
>> switch to using that.
>> 
>> This cleans up some of the weird MPOL_INTERLEAVE allocation exceptions.
>
> It's not apparent why you need to remove it for sched-numa. I think I
> see it but it'd be nicer if it would explained so one doesn't need to
> read an internal bit of several patches later to understand why this
> is needed.

Also it still breaks the numactl test suite, as already explained 
multiple times. Without the HIT counter there is no way to check
interleave actually happened.

I'm a bit concerned about patch kits like this ignoring review feedback?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
