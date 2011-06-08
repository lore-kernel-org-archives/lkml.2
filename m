Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1FHKLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:11:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab1FHKLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:11:07 -0400
Date: Wed, 8 Jun 2011 12:11:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Thomas Sattler <tsattler@gmx.de>,
        Ury Stankevich <urykhy@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] mm: memory-failure: Fix isolated page count during
 memory failure
Message-ID: <20110608101105.GA9936@tiehlicka.suse.cz>
References: <1307459225-4481-1-git-send-email-mgorman@suse.de>
 <1307459225-4481-4-git-send-email-mgorman@suse.de>
 <20110608100720.GF6742@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608100720.GF6742@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-06-11 12:07:20, Michal Hocko wrote:
> On Tue 07-06-11 16:07:04, Mel Gorman wrote:
> > From: Minchan Kim <minchan.kim@gmail.com>
> > 
> > From: Minchan Kim <minchan.kim@gmail.com>
> > 
> > Pages isolated for migration are accounted with the vmstat counters
> > NR_ISOLATE_[ANON|FILE]. Callers of migrate_pages() are expected to
> > increment these counters when pages are isolated from the LRU. Once
> > the pages have been migrated, they are put back on the LRU or freed
> > and the isolated count is decremented.
> 
> Aren't we missing this in compact_zone as well? AFAICS there is no
> accounting done after we isolate pages from LRU? Or am I missing
> something?

Scratch that. It was hidden in acct_isolated which is called from
isolate_migratepages.
It would be really strange if this was broken ;)

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
