Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1EaNj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:39:56 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:37833 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab1EaNjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:39:55 -0400
Date: Tue, 31 May 2011 15:39:50 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 04/10] Add additional isolation mode
Message-ID: <20110531133950.GA4594@cmpxchg.org>
References: <cover.1306689214.git.minchan.kim@gmail.com>
 <5b0f0be7ee441ea27ffcad81d2637ac09407acf3.1306689214.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b0f0be7ee441ea27ffcad81d2637ac09407acf3.1306689214.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 03:13:43AM +0900, Minchan Kim wrote:
> There are some places to isolate lru page and I believe
> users of isolate_lru_page will be growing.
> The purpose of them is each different so part of isolated pages
> should put back to LRU, again.
> 
> The problem is when we put back the page into LRU,
> we lose LRU ordering and the page is inserted at head of LRU list.
> It makes unnecessary LRU churning so that vm can evict working set pages
> rather than idle pages.
> 
> This patch adds new modes when we isolate page in LRU so we don't isolate pages
> if we can't handle it. It could reduce LRU churning.
> 
> This patch doesn't change old behavior. It's just used by next patches.
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
