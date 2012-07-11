Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2GKBCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:02:11 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55573 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2GKBCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:02:09 -0400
Date: Tue, 10 Jul 2012 18:02:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] mm: Warn about costly page allocation
In-Reply-To: <20120710002510.GB5935@bbox>
Message-ID: <alpine.DEB.2.00.1207101756070.684@chino.kir.corp.google.com>
References: <1341878153-10757-1-git-send-email-minchan@kernel.org> <20120709170856.ca67655a.akpm@linux-foundation.org> <20120710002510.GB5935@bbox>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Minchan Kim wrote:

> > So I dunno, this all looks like we have a kernel problem and we're
> > throwing our problem onto hopelessly ill-equipped users of that kernel?
> 
> As you know, this patch isn't for solving regular high-order allocations.
> As I wrote down, The problem is that we removed lumpy reclaim without any
> notification for user who might have used it implicitly.

And so now they're running with CONFIG_DEBUG_VM to try to figure out why 
they have seen a regression, which is required for your patch to have an 
effect?

> If such user disable compaction which is a replacement of lumpy reclaim,
> their system might be broken in real practice while test is passing.
> So, the goal is that let them know it in advance so that I expect they can
> test it stronger than old.
> 

So what are they supposed to do?  Enable CONFIG_COMPACTION as soon as they 
see the warning?  When they have seen the warning a specific number of 
times?  How much is "very few" high-order allocations over what time 
period?  This is what anybody seeing these messages for the first time is 
going to ask.

> Although they see the page allocation failure with compaction, it would
> be very helpful reports. It means we need to make compaction more
> aggressive about reclaiming pages.
> 

If CONFIG_COMPACTION is disabled, then how will making compaction more 
aggressive about reclaiming pages help?

Should we consider enabling CONFIG_COMPACTION in defconfig?  If not, would 
it be possible with a different extfrag_threshold (and more aggressive 
when things like THP are enabled)?
