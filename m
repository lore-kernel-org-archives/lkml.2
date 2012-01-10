Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2AJJkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:40:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab2AJJkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:40:31 -0500
Date: Tue, 10 Jan 2012 09:40:27 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: no change of reclaim mode if unevictable
 page encountered
Message-ID: <20120110094026.GB4118@suse.de>
References: <CAJd=RBDAoNt=TZWhNeLs0MaCJ_ormEp=ya55-PA+B0BAxfGbbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBDAoNt=TZWhNeLs0MaCJ_ormEp=ya55-PA+B0BAxfGbbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 11:46:17AM +0800, Hillf Danton wrote:
> Since unevictable page is not isolated from lru list for shrink_page_list(),
> it is accident if encountered in shrinking, and no need to change reclaim mode.
> 

This changelog does does not explain the problem, does not explain
what is fixed or what the impact is.

It also does not make sense. It says "unevictable page is not isolated
from LRU list" but this is shrink_page_list() and the page has already
been isolated (probably by lumpy reclaim). It will be put back on
the LRU_UNEVICTABLE list.

It might be the case that resetting the reclaim mode after encountering
mlocked pages is overkill but that would need more justification than
what this changelog offers. Resetting the mode impacts THP rates but
this is erring on the side of caution by doing less work in reclaim
as the savings from THP may not offset the cost of reclaim.

-- 
Mel Gorman
SUSE Labs
