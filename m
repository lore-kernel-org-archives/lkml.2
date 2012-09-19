Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab2ISRVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:21:45 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:57895 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab2ISRVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:21:42 -0400
Date: Wed, 19 Sep 2012 13:21:36 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm: remove free_page_mlock
Message-ID: <20120919172136.GS1560@cmpxchg.org>
References: <alpine.LSU.2.00.1209182045370.11632@eggly.anvils>
 <alpine.LSU.2.00.1209182055290.11632@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1209182055290.11632@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 08:57:27PM -0700, Hugh Dickins wrote:
> We should not be seeing non-0 unevictable_pgs_mlockfreed any longer.
> So remove free_page_mlock() from the page freeing paths: __PG_MLOCKED
> is already in PAGE_FLAGS_CHECK_AT_FREE, so free_pages_check() will now
> be checking it, reporting "BUG: Bad page state" if it's ever found set.
> Comment UNEVICTABLE_MLOCKFREED and unevictable_pgs_mlockfreed always 0.

I would have just removed it because I don't see too many users
relying on it being there.  But I'm fine with keeping it for now.

> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Ying Han <yinghan@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
