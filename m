Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030655Ab2HWR3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:29:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030624Ab2HWR3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:29:18 -0400
Date: Thu, 23 Aug 2012 14:28:45 -0300
From: Rafael Aquini <aquini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v8 1/5] mm: introduce a common interface for balloon
 pages mobility
Message-ID: <20120823172844.GC10777@t510.redhat.com>
References: <20120822000741.GI9027@redhat.com>
 <20120822011930.GA23753@t510.redhat.com>
 <20120822093317.GC10680@redhat.com>
 <20120823021903.GA23660@x61.redhat.com>
 <20120823100107.GA17409@redhat.com>
 <20120823121338.GA3062@t510.redhat.com>
 <20120823123432.GA25659@redhat.com>
 <20120823130606.GB3746@t510.redhat.com>
 <20120823135328.GB25709@redhat.com>
 <20120823162504.GA1522@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823162504.GA1522@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 07:25:05PM +0300, Michael S. Tsirkin wrote:
> On Thu, Aug 23, 2012 at 04:53:28PM +0300, Michael S. Tsirkin wrote:
> > Basically it was very simple: we assumed page->lru was never
> > touched for an allocated page, so it's safe to use it for
> > internal book-keeping by the driver.
> > 
> > Now, this is not the case anymore, you add some logic in mm/ that might
> > or might not touch page->lru depending on things like reference count.
> 
> Another thought: would the issue go away if balloon used
> page->private to link pages instead of LRU?
> mm core could keep a reference on page to avoid it
> being used while mm handles it (maybe it does already?).
>
I don't think so. That would be a lot more trikier and complex, IMHO.
 
> If we do this, will not the only change to balloon be to tell mm that it
> can use compaction for these pages when it allocates the page: using
> some GPF flag or a new API?
> 

What about keep a conter at virtio_balloon structure on how much pages are
isolated from balloon's list and check it at leak time?
if the counter gets > 0 than we can safely put leak_balloon() to wait until
balloon page list gets completely refilled. I guess that is simple to get
accomplished and potentially addresses all your concerns on this issue.

Cheers!

