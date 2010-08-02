Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab0HBEN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 00:13:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37601 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0HBEN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 00:13:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: synchronous lumpy reclaim don't call congestion_wait()
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Andy Whitcroft <apw@shadowen.org>, Rik van Riel <riel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
In-Reply-To: <20100801134117.GA2034@barrios-desktop>
References: <20100801180751.4B0E.A69D9226@jp.fujitsu.com> <20100801134117.GA2034@barrios-desktop>
Message-Id: <20100802131016.4F7D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  2 Aug 2010 13:13:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi KOSAKI, 
> 
> On Sun, Aug 01, 2010 at 06:12:47PM +0900, KOSAKI Motohiro wrote:
> > rebased onto Wu's patch
> > 
> > ----------------------------------------------
> > From 35772ad03e202c1c9a2252de3a9d3715e30d180f Mon Sep 17 00:00:00 2001
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Date: Sun, 1 Aug 2010 17:23:41 +0900
> > Subject: [PATCH] vmscan: synchronous lumpy reclaim don't call congestion_wait()
> > 
> > congestion_wait() mean "waiting for number of requests in IO queue is
> > under congestion threshold".
> > That said, if the system have plenty dirty pages, flusher thread push
> > new request to IO queue conteniously. So, IO queue are not cleared
> > congestion status for a long time. thus, congestion_wait(HZ/10) is
> > almostly equivalent schedule_timeout(HZ/10).
> Just a nitpick. 
> Why is it a problem?
> HZ/10 is upper bound we intended.  If is is rahter high, we can low it. 
> But totally I agree on this patch. It would be better to remove it 
> than lowing. 

because all of _unnecessary_ sleep is evil. the problem is, congestion_wait()
mean "wait until queue congestion will be cleared, iow, wait all of IO". 
but we want to wait until _my_ IO finished.

So, if flusher thread conteniously push new IO into the queue, that makes
big difference.

Thanks.


