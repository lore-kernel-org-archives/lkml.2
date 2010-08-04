Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab0HDLKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:10:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56926 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201Ab0HDLKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:10:22 -0400
Date: Wed, 4 Aug 2010 12:10:06 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Why PAGEOUT_IO_SYNC stalls for a long time
Message-ID: <20100804111005.GA17745@csn.ul.ie>
References: <20100730115222.4AD8.A69D9226@jp.fujitsu.com> <20100730103018.GE3571@csn.ul.ie> <20100801174229.4B08.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100801174229.4B08.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 05:47:08PM +0900, KOSAKI Motohiro wrote:
> > > side note: page lock contention is very common case.
> > > 
> > > For case (8), I don't think sleeping is right way. get_page() is used in really various place of
> > > our kernel. so we can't assume it's only temporary reference count increasing.
> > 
> > In what case is a munlocked pages reference count permanently increased and
> > why is this not a memory leak?
> 
> V4L, audio, GEM and/or other multimedia driver?
> 

Ok, that is quite likely. Have you made a start on a series related to
lumpy reclaim? I was holding off making a start on such a thing while I
reviewed the other writeback issues and travelling to MM Summit is going
to delay things for me. If you haven't started when I get back, I'll
make some sort of stab at it.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
