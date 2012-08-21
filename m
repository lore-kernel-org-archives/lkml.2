Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2HUPen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:34:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:47334 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2HUPel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:34:41 -0400
Message-ID: <1345563260.26596.0.camel@twins>
Subject: Re: [PATCH v8 3/5] virtio_balloon: introduce migration primitives
 to balloon pages
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Date: Tue, 21 Aug 2012 17:34:20 +0200
In-Reply-To: <20120821144013.GA7784@redhat.com>
References: <cover.1345519422.git.aquini@redhat.com>
	 <c5f02c618c99b0da11240c1b504672de6f70a074.1345519422.git.aquini@redhat.com>
	 <20120821144013.GA7784@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 17:40 +0300, Michael S. Tsirkin wrote:
> > +     vb->balloon_status = BALLOON_REMOVAL;
> 
> This needs some kind of barrier.
> 
> >       kthread_stop(vb->thread); 

kthread_stop() implies an smp_wmb() [ because it needs to do a wakeup ].
