Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0FQGRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:17:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab0FQGRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:17:11 -0400
Date: Thu, 17 Jun 2010 02:16:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100617061647.GA21277@infradead.org>
References: <1276514273-27693-13-git-send-email-mel@csn.ul.ie>
 <4C16A567.4080000@redhat.com>
 <20100615114510.GE26788@csn.ul.ie>
 <4C17815A.8080402@redhat.com>
 <20100615135928.GK26788@csn.ul.ie>
 <4C178868.2010002@redhat.com>
 <20100615141601.GL26788@csn.ul.ie>
 <20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com>
 <20100616050640.GA10687@infradead.org>
 <20100617092538.c712342b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617092538.c712342b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 09:25:38AM +0900, KAMEZAWA Hiroyuki wrote:
> 
> BTW, why xbf_buf_create() use GFP_KERNEL even if it can be blocked ?
> memory cgroup just limits pages for users, then, doesn't intend to
> limit kernel pages.

You mean xfs_buf_allocate?  It doesn't in the end.  It goes through the
xfs_kmem helper which clear __GFP_FS if we're currently inside a
filesystem transaction (PF_FSTRANS is set) or a caller specificly
requested it to be disabled even without that by passig the
XBF_DONT_BLOCK flag.

