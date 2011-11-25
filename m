Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab1KYBBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 20:01:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39562 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1KYBBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 20:01:37 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 25 Nov 2011 10:00:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Shaohua Li <shaohua.li@intel.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/5] mm: try to distribute dirty pages fairly across
 zones
Message-Id: <20111125100009.a87094fa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111124131155.GB1225@cmpxchg.org>
References: <1322055258-3254-1-git-send-email-hannes@cmpxchg.org>
	<1322055258-3254-4-git-send-email-hannes@cmpxchg.org>
	<20111124100755.d8b783a8.kamezawa.hiroyu@jp.fujitsu.com>
	<20111124131155.GB1225@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011 14:11:55 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Thu, Nov 24, 2011 at 10:07:55AM +0900, KAMEZAWA Hiroyuki wrote:
			goto this_zone_full;
> > >  
> > >  		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
> > >  		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
> > 
> > This wil call 
> > 
> >                 if (NUMA_BUILD)
> >                         zlc_mark_zone_full(zonelist, z);
> > 
> > And this zone will be marked as full. 
> > 
> > IIUC, zlc_clear_zones_full() is called only when direct reclaim ends.
> > So, if no one calls direct-reclaim, 'full' mark may never be cleared
> > even when number of dirty pages goes down to safe level ?
> > I'm sorry if this is alread discussed.
> 
> It does not remember which zones are marked full for longer than a
> second - see zlc_setup() - and also ignores this information when an
> iteration over the zonelist with the cache enabled came up
> empty-handed.
> 
Ah, thank you for clarification.
I understand how zlc_active/did_zlc_setup/zlc_setup()...complicated ;)

Thanks,
-Kame

