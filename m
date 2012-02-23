Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2BWV5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:57:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:21623 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2BWV5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:57:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120687770"
From: Andi Kleen <andi@firstfloor.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, hughd@google.com
Subject: Re: [PATCH -mm 2/2] mm: do not reset mm->free_area_cache on every single munmap
References: <20120223145417.261225fd@cuia.bos.redhat.com>
	<20120223150034.2c757b3a@cuia.bos.redhat.com>
Date: Thu, 23 Feb 2012 13:57:42 -0800
In-Reply-To: <20120223150034.2c757b3a@cuia.bos.redhat.com> (Rik van Riel's
	message of "Thu, 23 Feb 2012 15:00:34 -0500")
Message-ID: <m2vcmxp609.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel <riel@redhat.com> writes:

> Some programs have a large number of VMAs, and make frequent calls
> to mmap and munmap. Having munmap constantly cause the search
> pointer for get_unmapped_area to get reset can cause a significant
> slowdown for such programs. 

This would be a much nicer patch if you split it into one that merges
all the copy'n'paste code and another one that actually implements
the new algorithm.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
