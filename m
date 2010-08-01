Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab0HANlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 09:41:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40343 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0HANla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 09:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=szG9YTrJSim0znZ634a7hjofBH7ruHzWSoaPVctQX0Mbw7DwJiC0sb7kEHO5NR/TiV
         kRPLvVaN8adI6+ri/pAt5aehtlqBqRE9xlRtFLI1ujjAVoFOoMQaGVyKT9qywvJ7U4sC
         WySGYoqwSq/wvVMj4+Xj2NB7B4FTWc9emp6ys=
Date: Sun, 1 Aug 2010 22:41:17 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
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
Subject: Re: [PATCH] vmscan: synchronous lumpy reclaim don't call
 congestion_wait()
Message-ID: <20100801134117.GA2034@barrios-desktop>
References: <20100801085134.GA15577@localhost>
 <20100801180751.4B0E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801180751.4B0E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI, 

On Sun, Aug 01, 2010 at 06:12:47PM +0900, KOSAKI Motohiro wrote:
> rebased onto Wu's patch
> 
> ----------------------------------------------
> From 35772ad03e202c1c9a2252de3a9d3715e30d180f Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Sun, 1 Aug 2010 17:23:41 +0900
> Subject: [PATCH] vmscan: synchronous lumpy reclaim don't call congestion_wait()
> 
> congestion_wait() mean "waiting for number of requests in IO queue is
> under congestion threshold".
> That said, if the system have plenty dirty pages, flusher thread push
> new request to IO queue conteniously. So, IO queue are not cleared
> congestion status for a long time. thus, congestion_wait(HZ/10) is
> almostly equivalent schedule_timeout(HZ/10).
Just a nitpick. 
Why is it a problem?
HZ/10 is upper bound we intended.  If is is rahter high, we can low it. 
But totally I agree on this patch. It would be better to remove it 
than lowing. 

> 
> If the system 512MB memory, DEF_PRIORITY mean 128kB scan and It takes 4096
> shrink_page_list() calls to scan 128kB (i.e. 128kB/32=4096) memory.
> 4096 times 0.1sec stall makes crazy insane long stall. That shouldn't.

128K / (4K * SWAP_CLUSTER_MAX) = 1

> 
> In the other hand, this synchronous lumpy reclaim donesn't need this
> congestion_wait() at all. shrink_page_list(PAGEOUT_IO_SYNC) cause to
> call wait_on_page_writeback() and it provide sufficient waiting.

Absolutely I agree on you. 

> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
