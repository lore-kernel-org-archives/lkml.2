Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0LAK2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:28:42 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35336 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0LAK2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:28:40 -0500
Date: Wed, 1 Dec 2010 11:28:28 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] mm: migration: Allow migration to operate
 asynchronously and avoid synchronous compaction in the faster path
Message-ID: <20101201102828.GM15564@cmpxchg.org>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
 <1290440635-30071-5-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290440635-30071-5-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 03:43:52PM +0000, Mel Gorman wrote:
> Migration synchronously waits for writeback if the initial passes fails.
> Callers of memory compaction do not necessarily want this behaviour if the
> caller is latency sensitive or expects that synchronous migration is not
> going to have a significantly better success rate.
> 
> This patch adds a sync parameter to migrate_pages() allowing the caller to
> indicate if wait_on_page_writeback() is allowed within migration or not. For
> reclaim/compaction, try_to_compact_pages() is first called asynchronously,
> direct reclaim runs and then try_to_compact_pages() is called synchronously
> as there is a greater expectation that it'll succeed.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
