Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934180Ab2HWSdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:33:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:35928 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555Ab2HWSdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:33:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,301,1344236400"; 
   d="scan'208";a="190584352"
Date: Thu, 23 Aug 2012 14:33:14 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alex Shi <alex.shi@intel.com>
Subject: Re: [RFC PATCH 2/2] mm: Batch page_check_references in
 shrink_page_list sharing the same i_mmap_mutex
Message-ID: <20120823183314.GD6960@linux.intel.com>
References: <1345251998.13492.235.camel@schen9-DESK>
 <1345480982.13492.239.camel@schen9-DESK>
 <20120821132129.GC6960@linux.intel.com>
 <1345596500.13492.264.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345596500.13492.264.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:48:20PM -0700, Tim Chen wrote:
> Thanks to Matthew's suggestions on improving the patch. Here's the
> updated version.  It seems to be sane when I booted my machine up.  I
> will put it through more testing when I get a chance.

Looks good.

> +int __try_to_munlock(struct page *page)

Nit: I think this can be static.  There aren't any users of it other
than try_to_munlock() itself.

