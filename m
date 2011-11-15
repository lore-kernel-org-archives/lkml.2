Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1KOXsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:48:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103Ab1KOXsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:48:52 -0500
Date: Tue, 15 Nov 2011 23:48:45 +0000
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
Message-ID: <20111115234845.GK27150@suse.de>
References: <20111110100616.GD3083@suse.de>
 <20111110142202.GE3083@suse.de>
 <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
 <20111110161331.GG3083@suse.de>
 <20111110151211.523fa185.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1111101536330.2194@chino.kir.corp.google.com>
 <20111111101414.GJ3083@suse.de>
 <20111114154408.10de1bc7.akpm@linux-foundation.org>
 <20111115132513.GF27150@suse.de>
 <alpine.DEB.2.00.1111151303230.23579@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111151303230.23579@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:07:51PM -0800, David Rientjes wrote:
> On Tue, 15 Nov 2011, Mel Gorman wrote:
> 
> > Fine control is limited. If it is really needed, I would not oppose
> > a patch that allows the use of sync compaction via a new setting in
> > /sys/kernel/mm/transparent_hugepage/defrag. However, I think it is
> > a slippery slope to expose implementation details like this and I'm
> > not currently planning to implement such a patch.
> > 
> 
> This doesn't expose any implementation detail, the "defrag" tunable is 
> supposed to limit defragmentation efforts in the VM if the hugepages 
> aren't immediately available and simply fallback to using small pages.  

The current settings are "always", "madvise" and "never" which matches
the settings for /sys/kernel/mm/transparent_hugepage/enabled and are
fairly straight forward.

Adding sync here could obviously be implemented although it may
require both always-sync and madvise-sync. Alternatively, something
like an options file could be created to create a bitmap similar to
what ftrace does. Whatever the mechanism, it exposes the fact that
"sync compaction" is used. If that turns out to be not enough, then
you may want to add other steps like aggressively reclaiming memory
which also potentially may need to be controlled via the sysfs file
and this is the slippery slope.

> Given that definition, it would make sense to allow for synchronous 
> defragmentation (i.e. sync_compaction) on the second iteration of the page 
> allocator slowpath if set.  So where's the disconnect between this 
> proposed behavior and the definition of the tunable in 
> Documentation/vm/transhuge.txt?

The transhuge.txt file does not describe how defrag works or whether it
uses sync compaction internally.

-- 
Mel Gorman
SUSE Labs
