Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2HUT3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:29:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab2HUT3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:29:44 -0400
Date: Tue, 21 Aug 2012 22:30:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rafael Aquini <aquini@redhat.com>
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
Message-ID: <20120821193031.GC9027@redhat.com>
References: <cover.1345519422.git.aquini@redhat.com>
 <e24f3073ef539985dea52943dcb84762213a0857.1345519422.git.aquini@redhat.com>
 <1345562411.23018.111.camel@twins>
 <20120821162432.GG2456@linux.vnet.ibm.com>
 <20120821172819.GA12294@t510.redhat.com>
 <20120821191330.GA8324@redhat.com>
 <20120821192357.GD12294@t510.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821192357.GD12294@t510.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 04:23:58PM -0300, Rafael Aquini wrote:
> On Tue, Aug 21, 2012 at 10:13:30PM +0300, Michael S. Tsirkin wrote:
> > > 
> > > I believe rcu_dereference_protected() is what I want/need here, since this code
> > > is always called for pages which we hold locked (PG_locked bit).
> > 
> > It would only help if we locked the page while updating the mapping,
> > as far as I can see we don't.
> >
> 
> But we can do it. In fact, by doing it (locking the page) we can easily avoid
> the nasty race balloon_isolate_page / leak_balloon, in a much simpler way, IMHO.

Absolutely. Further, we should look hard at whether most RCU uses
in this patchset can be replaced with page lock.

-- 
MST
