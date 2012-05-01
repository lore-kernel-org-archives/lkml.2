Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2EAJ4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 05:56:04 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:44008 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab2EAJ4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 05:56:03 -0400
Date: Tue, 1 May 2012 11:55:43 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] mm + fs: provide refault distance to page cache
 instantiations
Message-ID: <20120501095543.GA2112@cmpxchg.org>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
 <1335861713-4573-5-git-send-email-hannes@cmpxchg.org>
 <1335864640.13683.116.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335864640.13683.116.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 11:30:40AM +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-01 at 10:41 +0200, Johannes Weiner wrote:
> > Every site that does a find_or_create()-style allocation is converted
> > to pass this refault information to the page_cache_alloc() family of
> > functions, which in turn passes it down to the page allocator via
> > current->refault_distance. 
> 
> That is rather icky..

Fair enough, I just went with the easier solution to get things off
the ground instead of dealing with adding an extra parameter to layers
of config-dependent gfp API.  I'll revisit this for v2.
