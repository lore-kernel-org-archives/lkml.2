Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab2ISQqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:46:33 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:57879 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab2ISQqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:46:32 -0400
Date: Wed, 19 Sep 2012 12:46:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: remove vma arg from page_evictable
Message-ID: <20120919164625.GQ1560@cmpxchg.org>
References: <alpine.LSU.2.00.1209182045370.11632@eggly.anvils>
 <alpine.LSU.2.00.1209182052030.11632@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1209182052030.11632@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 08:53:45PM -0700, Hugh Dickins wrote:
> page_evictable(page, vma) is an irritant: almost all its callers pass
> NULL for vma.  Remove the vma arg and use mlocked_vma_newpage(vma, page)
> explicitly in the couple of places it's needed.  But in those places we
> don't even need page_evictable() itself!  They're dealing with a freshly
> allocated anonymous page, which has no "mapping" and cannot be mlocked yet.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Ying Han <yinghan@google.com>

Much better.  With documentation updates and everything, thank you!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
