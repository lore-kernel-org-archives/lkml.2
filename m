Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab1FWJCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:02:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab1FWJCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:02:09 -0400
Date: Thu, 23 Jun 2011 11:02:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Lutz Vieweg <lvml@5t9.de>
Subject: Re: [PATCH] memcg: unlock page before charging it. (WasRe: [PATCH
 V2] mm: Do not keep page locked during page fault while charging it for
 memcg
Message-ID: <20110623090204.GE31593@tiehlicka.suse.cz>
References: <20110622120635.GB14343@tiehlicka.suse.cz>
 <20110622121516.GA28359@infradead.org>
 <20110622123204.GC14343@tiehlicka.suse.cz>
 <20110623150842.d13492cd.kamezawa.hiroyu@jp.fujitsu.com>
 <20110623074133.GA31593@tiehlicka.suse.cz>
 <20110623170811.16f4435f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623170811.16f4435f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-06-11 17:08:11, KAMEZAWA Hiroyuki wrote:
> On Thu, 23 Jun 2011 09:41:33 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
[...]
> > Other than that:
> > Reviewed-by: Michal Hocko <mhocko@suse.cz>
> > 
> 
> I found the page is added to LRU before charging. (In this case,
> memcg's LRU is ignored.) I'll post a new version with a fix.

Yes, you are right. I have missed that.
This means that we might race with reclaim which could evict the COWed
page wich in turn would uncharge that page even though we haven't
charged it yet.

Can we postpone page_add_new_anon_rmap to the charging path or it would
just race somewhere else?

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
