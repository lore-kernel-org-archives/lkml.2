Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab0HEGUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:20:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51539 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab0HEGUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:20:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: Why PAGEOUT_IO_SYNC stalls for a long time
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
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
In-Reply-To: <20100804111005.GA17745@csn.ul.ie>
References: <20100801174229.4B08.A69D9226@jp.fujitsu.com> <20100804111005.GA17745@csn.ul.ie>
Message-Id: <20100805151630.31CF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Aug 2010 15:20:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Aug 01, 2010 at 05:47:08PM +0900, KOSAKI Motohiro wrote:
> > > > side note: page lock contention is very common case.
> > > > 
> > > > For case (8), I don't think sleeping is right way. get_page() is used in really various place of
> > > > our kernel. so we can't assume it's only temporary reference count increasing.
> > > 
> > > In what case is a munlocked pages reference count permanently increased and
> > > why is this not a memory leak?
> > 
> > V4L, audio, GEM and/or other multimedia driver?
> > 
> 
> Ok, that is quite likely. Have you made a start on a series related to
> lumpy reclaim? I was holding off making a start on such a thing while I
> reviewed the other writeback issues and travelling to MM Summit is going
> to delay things for me. If you haven't started when I get back, I'll
> make some sort of stab at it.

Yup, I posted them today. While my lite testing, they works intentionally. it mean
 - reduce low order reclaim latency
 - keep high successfull rate order-9 reclaim under heavy io workload

However, they obviously need more test. comment are welcome :)




