Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab1BJVBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:01:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756994Ab1BJVBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:01:11 -0500
Date: Thu, 10 Feb 2011 13:00:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: batch-free pcp list if possible
Message-Id: <20110210130037.24dbde41.akpm@linux-foundation.org>
In-Reply-To: <20110210093544.GA17873@csn.ul.ie>
References: <1297257677-12287-1-git-send-email-namhyung@gmail.com>
	<20110209123803.4bb6291c.akpm@linux-foundation.org>
	<20110210093544.GA17873@csn.ul.ie>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011 09:35:44 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> > What's the point in that?  What relationship does the number of
> > contiguous empty lists have with the number of pages to free from one
> > list?
> > 
> 
> The point is to avoid excessive checking of empty lists.

It seems pretty simple to me to skip the testing of empty lists
altogether.  I suggested one way, however I suspect a better approach
might be to maintain a count of the number of pages in each list and
then change free_pcppages_bulk() so that it calculates up-front the
number of pages to free from each list (equal proportion of each) then
sits in a tight loop freeing that number of pages.

It might be that the overhead of maintaining the per-list count makes
that not worthwhile.  It'll be hard to tell because the count
maintenance cost will be smeared all over the place.

I doubt if any of it matters much, compared to the cost of allocating,
populating and freeing a page.  I just want free_pcppages_bulk() to
stop hurting my brain ;)


