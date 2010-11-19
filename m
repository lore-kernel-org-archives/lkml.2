Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0KSLfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:35:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55410 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab0KSLfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:35:18 -0500
Date: Fri, 19 Nov 2010 11:35:03 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: David Sterba <dsterba@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>, Andy Whitcroft <apw@canonical.com>,
        David Rientjes <rientjes@google.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Matt Mackall <mpm@selenic.com>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] mm: remove call to find_vma in pagewalk for
	non-hugetlbfs
Message-ID: <20101119113503.GF28613@csn.ul.ie>
References: <1290127197-20360-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1290127197-20360-1-git-send-email-dsterba@suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 01:39:57AM +0100, David Sterba wrote:
> Commit d33b9f45 introduces a check if a vma is a hugetlbfs one and
> later in 5dc37642 is moved under #ifdef CONFIG_HUGETLB_PAGE but
> a needless find_vma call is left behind and it's result not used
> anywhere else in the function.
> 
> The sideefect of caching vma for @addr inside walk->mm is neither
> utilized in walk_page_range() nor in called functions.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Wu Fengguang <fengguang.wu@intel.com>

Well spotted.

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
