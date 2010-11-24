Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab0KXKnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:43:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:49668 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885Ab0KXKng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:43:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,247,1288594800"; 
   d="scan'208";a="577103357"
Date: Wed, 24 Nov 2010 18:43:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/13] writeback: per-task rate limit on
 balance_dirty_pages()
Message-ID: <20101124104331.GA6096@localhost>
References: <20101117042720.033773013@intel.com>
 <20101117042849.650810571@intel.com>
 <1290594187.2072.440.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290594187.2072.440.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 06:23:07PM +0800, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:
> > +       if (unlikely(current->nr_dirtied >= current->nr_dirtied_pause ||
> > +                    bdi->dirty_exceeded)) {
> > +               balance_dirty_pages(mapping, current->nr_dirtied);
> > +               current->nr_dirtied = 0;
> >         } 
> 
> Was it a conscious choice to use
>   current->nr_dirtied = 0
> over 
>   current->nr_dirtied -= current->nr_dirtied_pause
> ?
> 
> The former will cause a drift in pause times due to truncation of the
> excess.

It should be fine in either way, as long as the "truncated" number is
passed to balance_dirty_pages():

+               balance_dirty_pages(mapping, current->nr_dirtied);
+               current->nr_dirtied = 0;

or

+               balance_dirty_pages(mapping, current->nr_dirtied_pause);
+               current->nr_dirtied -= current->nr_dirtied_pause;

Thanks,
Fengguang
