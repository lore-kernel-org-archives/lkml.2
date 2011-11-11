Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1KKKOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:14:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab1KKKOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:14:18 -0500
Date: Fri, 11 Nov 2011 10:14:14 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111111101414.GJ3083@suse.de>
References: <20111110100616.GD3083@suse.de>
 <20111110142202.GE3083@suse.de>
 <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
 <20111110161331.GG3083@suse.de>
 <20111110151211.523fa185.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1111101536330.2194@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111101536330.2194@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 03:37:32PM -0800, David Rientjes wrote:
> On Thu, 10 Nov 2011, Andrew Morton wrote:
> 
> > > This patch once again prevents sync migration for transparent
> > > hugepage allocations as it is preferable to fail a THP allocation
> > > than stall.
> > 
> > Who said?  ;) Presumably some people would prefer to get lots of
> > huge pages for their 1000-hour compute job, and waiting a bit to get
> > those pages is acceptable.
> > 
> 
> Indeed.  It seems like the behavior would better be controlled with 
> /sys/kernel/mm/transparent_hugepage/defrag which is set aside specifically 
> to control defragmentation for transparent hugepages and for that 
> synchronous compaction should certainly apply.

With khugepaged in place, it's adding a tunable that is unnecessary and
will not be used. Even if such a tuneable was created, the default
behaviour should be "do not stall".

-- 
Mel Gorman
SUSE Labs
