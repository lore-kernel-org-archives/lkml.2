Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2KTX3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:29:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2KTX3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:29:47 -0500
Date: Tue, 20 Nov 2012 15:29:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v11 7/7] mm: add vm event counters for balloon pages
 compaction
Message-Id: <20121120152946.823cd2d9.akpm@linux-foundation.org>
In-Reply-To: <20121109145829.GC4308@optiplex.redhat.com>
References: <cover.1352256081.git.aquini@redhat.com>
	<8dde7996f3e36a5efbe569afe1aadfc84355e79e.1352256088.git.aquini@redhat.com>
	<20121109122033.GR3886@csn.ul.ie>
	<20121109145829.GC4308@optiplex.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012 12:58:29 -0200
Rafael Aquini <aquini@redhat.com> wrote:

> On Fri, Nov 09, 2012 at 12:20:33PM +0000, Mel Gorman wrote:
> > On Wed, Nov 07, 2012 at 01:05:54AM -0200, Rafael Aquini wrote:
> > > This patch introduces a new set of vm event counters to keep track of
> > > ballooned pages compaction activity.
> > > 
> > > Signed-off-by: Rafael Aquini <aquini@redhat.com>
> > 
> > Other than confirming the thing actually works can any meaningful
> > conclusions be drawn from this counters?
> > 
> > I know I have been inconsistent on this myself in the past but recently
> > I've been taking the attitude that the counters can be used to fit into
> > some other metric. I'm looking to change the compaction counters to be
> > able to build a basic cost model for example. The same idea could be
> > used for balloons of course but it's a less critical path than
> > compaction for THP for example.
> > 
> > Assuming it builds and all the defines are correct when the feature is
> > not configured (I didn't check) then there is nothing wrong with the
> > patch. However, if it was dropped would it make life very hard or would
> > you notice?
> > 
> 
> Originally, I proposed this patch as droppable (and it's still droppable)
> because its major purpose was solely to show the thing working consistently
> 
> OTOH, it might make the life easier to spot breakages if it remains with the
> merged bits, and per a reviewer request I removed its 'DROP BEFORE MERGE'
> disclaimer.
> 
>    https://lkml.org/lkml/2012/8/8/616

There's a lot to be said for not merging things.

I think I'll maintain this as a mm-only patch.  That way it's
available in linux-next and we can merge it later if a need arises.
