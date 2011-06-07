Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1FGQ07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:26:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab1FGQ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:26:58 -0400
Date: Tue, 7 Jun 2011 17:26:54 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Sattler <tsattler@gmx.de>, Ury Stankevich <urykhy@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: compaction: Abort compaction if too many pages
 are isolated and caller is asynchronous
Message-ID: <20110607162654.GN5247@suse.de>
References: <1307459225-4481-1-git-send-email-mgorman@suse.de>
 <1307459225-4481-5-git-send-email-mgorman@suse.de>
 <20110607155029.GL1686@barrios-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110607155029.GL1686@barrios-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 12:50:29AM +0900, Minchan Kim wrote:
> > <SNIP>
> > @@ -533,8 +544,14 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
> >  		unsigned long nr_migrate, nr_remaining;
> >  		int err;
> >  
> > -		if (!isolate_migratepages(zone, cc))
> > +		switch (isolate_migratepages(zone, cc)) {
> > +		case ISOLATE_ABORT:
> 
> In this case, you change old behavior slightly.
> In old case, we return COMPACT_PARTIAL to cancel migration.
> But this patch makes to return COMPACT_SUCCESS.
> At present, return value of compact_zone is only used by __alloc_pages_direct_compact
> and it only consider COMPACT_SKIPPED so it would be not a problem.
> But I think it would be better to return COMPACT_PARTIAL instead of COMPACT_CONTINUE
> for consistency with compact_finished and right semantic for the future user of compact_zone.
> 

Agreed. Thanks.

-- 
Mel Gorman
SUSE Labs
