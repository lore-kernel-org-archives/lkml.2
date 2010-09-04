Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0IDIPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 04:15:23 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:53516 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753682Ab0IDIPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 04:15:20 -0400
Date: Sat, 4 Sep 2010 18:14:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after
 direct reclaim allocation fails
Message-ID: <20100904081414.GF705@dastard>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie>
 <1283504926-2120-4-git-send-email-mel@csn.ul.ie>
 <20100903160026.564fdcc9.akpm@linux-foundation.org>
 <20100904022545.GD705@dastard>
 <20100903202101.f937b0bb.akpm@linux-foundation.org>
 <20100904075840.GE705@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100904075840.GE705@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 05:58:40PM +1000, Dave Chinner wrote:
> On Fri, Sep 03, 2010 at 08:21:01PM -0700, Andrew Morton wrote:
> > On Sat, 4 Sep 2010 12:25:45 +1000 Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > Still, given the improvements in performance from this patchset,
> > > I'd say inclusion is a no-braniner....
> > 
> > OK, thanks.
> > 
> > It'd be interesting to check the IPI frequency with and without -
> > /proc/interrupts "CAL" field.  Presumably it went down a lot.
> 
> Maybe I suspected you would ask for this. I happened to dump
> /proc/interrupts after the livelock run finished, so you're in
> luck :)
....
> 
> livelock:  59458 58367 58559 59493 59614 57970 59060 58207
> 
> So the livelock case tends to indicate roughly 40,000 more IPI
> interrupts per CPU occurred.  The livelock occurred for close to 5
> minutes, so that's roughly 130 IPIs per second per CPU....

And just to confuse the issue further, I just had a livelock on a
vanilla kernel that did *not* cause the CAL counts to increase.
Hence it appears that the IPI storms are not the cause of the
livelocks І'm triggering....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
