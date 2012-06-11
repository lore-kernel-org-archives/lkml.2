Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2FKOlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:41:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab2FKOlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:41:45 -0400
Date: Mon, 11 Jun 2012 16:41:32 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: do not use page_count without a page pin
Message-ID: <20120611144132.GT3094@redhat.com>
References: <1339373872-31969-1-git-send-email-minchan@kernel.org>
 <4FD59C31.6000606@jp.fujitsu.com>
 <20120611074440.GI3094@redhat.com>
 <20120611133043.GA2340@barrios>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611133043.GA2340@barrios>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On Mon, Jun 11, 2012 at 10:30:43PM +0900, Minchan Kim wrote:
> AFAIUC, you mean we have to increase reference count of head page?
> If so, it's not in __count_immobile_pages because it is already race-likely function
> so it shouldn't be critical although race happens.

I meant, shouldn't we take into account the full size? If it's in the
lru the whole thing can be moved away.

  if (!PageLRU(page)) {
     nr_pages = hpage_nr_pages(page);
     barrier();
     found += nr_pages;
     iter += nr_pages-1;
  }
