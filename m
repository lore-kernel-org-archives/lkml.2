Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1DTQkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:40:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1DTQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:40:45 -0400
Date: Wed, 20 Apr 2011 12:39:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm/vmalloc: remove block allocation bitmap
Message-ID: <20110420163954.GA7297@infradead.org>
References: <20110414211656.GB1700@cmpxchg.org>
 <20110419093118.GB23041@csn.ul.ie>
 <20110419233905.GA2333@cmpxchg.org>
 <20110420094647.GB1306@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420094647.GB1306@csn.ul.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:46:47AM +0100, Mel Gorman wrote:
> It'd be interesting but for the purposes of this patch I think it
> would be more useful to see the results of some benchmark that is vmap
> intensive. Something directory intensive running on XFS should do the
> job just to confirm no regression, right? A profile might indicate
> how often we end up scanning the full list, finding it dirty and
> calling new_vmap_block but even if something odd showed up there,
> it would be a new patch.

Note that the default mkfs.xfs options will not trigger any vmap
calls at runtime.  You'll need a filesystem with a large directory
block size to trigger heavy vmap usage.

