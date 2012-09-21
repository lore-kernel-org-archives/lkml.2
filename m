Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2IUMrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:47:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57948 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab2IUMrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:47:19 -0400
Date: Fri, 21 Sep 2012 13:47:15 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm: remove free_page_mlock
Message-ID: <20120921124715.GD11157@csn.ul.ie>
References: <alpine.LSU.2.00.1209182045370.11632@eggly.anvils>
 <alpine.LSU.2.00.1209182055290.11632@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1209182055290.11632@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 08:57:27PM -0700, Hugh Dickins wrote:
> We should not be seeing non-0 unevictable_pgs_mlockfreed any longer.
> So remove free_page_mlock() from the page freeing paths: __PG_MLOCKED
> is already in PAGE_FLAGS_CHECK_AT_FREE, so free_pages_check() will now
> be checking it, reporting "BUG: Bad page state" if it's ever found set.
> Comment UNEVICTABLE_MLOCKFREED and unevictable_pgs_mlockfreed always 0.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Ying Han <yinghan@google.com>

Like Johannes I think you should just drop the counter. I find it very
unlikely that there is a tool that depends on it existing because it's
very hard to draw any useful conclusions from its value unlikes like say
pgscan* or pgfault.

Acked-by: Mel Gorman <mel@csn.ul.ie>

Thanks Hugh.

-- 
Mel Gorman
SUSE Labs
