Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0KSOFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:05:48 -0500
Received: from gir.skynet.ie ([193.1.99.77]:51828 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab0KSOFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:05:47 -0500
Date: Fri, 19 Nov 2010 14:05:32 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Use memory compaction instead of lumpy reclaim
	during high-order allocations
Message-ID: <20101119140532.GH28613@csn.ul.ie>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie> <20101117154641.51fd7ce5.akpm@linux-foundation.org> <20101118081254.GB8135@csn.ul.ie> <20101118172627.cf25b83a.kamezawa.hiroyu@jp.fujitsu.com> <20101118083828.GA24635@cmpxchg.org> <20101118092044.GE8135@csn.ul.ie> <20101118114928.ecb2d6b0.akpm@linux-foundation.org> <20101119104856.GB28613@csn.ul.ie> <4B8266CB-F658-4CC8-BCA3-677C22BAFAE0@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B8266CB-F658-4CC8-BCA3-677C22BAFAE0@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 07:43:02AM -0500, Theodore Tso wrote:
> 
> On Nov 19, 2010, at 5:48 AM, Mel Gorman wrote:
> 
> > At least as long as !CONFIG_COMPACTION exists. That will be a while because
> > bear in mind CONFIG_COMPACTION is disabled by default (although I believe
> > some distros are enabling it at least). Maybe we should choose to deprecate
> > it in 2.6.40 and delete it at the infamous time of 2.6.42? That would give
> > ample time to iron out any issues that crop up with reclaim/compaction
> > (what this series has turned into).
> 
> How about making the default before 2.6.40, as an initial step?
> 

It'd be a reasonable way of ensuring it's being tested everywhere
and not by those that are interested or using distro kernel configs.
I guess we'd set to "default y" in the same patch that adds the note to
feature-removal-schedule.txt.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
