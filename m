Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830Ab0FPXtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:49:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756041Ab0FPXtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:49:06 -0400
Date: Wed, 16 Jun 2010 16:48:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 09/12] vmscan: Setup pagevec as late as possible in
 shrink_page_list()
Message-Id: <20100616164801.9d3c0d99.akpm@linux-foundation.org>
In-Reply-To: <1276514273-27693-10-git-send-email-mel@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	<1276514273-27693-10-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 12:17:50 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> shrink_page_list() sets up a pagevec to release pages as according as they
> are free. It uses significant amounts of stack on the pagevec. This
> patch adds pages to be freed via pagevec to a linked list which is then
> freed en-masse at the end. This avoids using stack in the main path that
> potentially calls writepage().
> 

hm, spose so.  I cen't see any trivial way to eliminate the local
pagevec there.

> +	if (pagevec_count(&freed_pvec))
> +		__pagevec_free(&freed_pvec);
> ...
> -	if (pagevec_count(&freed_pvec))
> -		__pagevec_free(&freed_pvec);

That's an open-coded pagevec_free().
