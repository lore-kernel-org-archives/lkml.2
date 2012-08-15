Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2HOMfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab2HOMfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:35:24 -0400
Date: Wed, 15 Aug 2012 09:34:58 -0300
From: Rafael Aquini <aquini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 2/4] virtio_balloon: introduce migration primitives to
 balloon pages
Message-ID: <20120815123457.GA2175@t510.redhat.com>
References: <cover.1344619987.git.aquini@redhat.com>
 <f19b63dfa026fe2f8f11ec017771161775744781.1344619987.git.aquini@redhat.com>
 <20120813084123.GF14081@redhat.com>
 <87lihis5qi.fsf@rustcorp.com.au>
 <20120814083320.GA3597@redhat.com>
 <20120814184409.GC13338@t510.redhat.com>
 <20120814193109.GA28840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814193109.GA28840@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:31:09PM +0300, Michael S. Tsirkin wrote:
> > > now CPU1 executes the next instruction:
> > > 
> > > }
> > > 
> > > which would normally return to function's caller,
> > > but it has been overwritten by CPU2 so we get corruption.
> > > 
> > > No?
> > 
> > At the point CPU2 is unloading the module, it will be kept looping at the
> > snippet Rusty pointed out because the isolation / migration steps do not mess
> > with 'vb->num_pages'. The driver will only unload after leaking the total amount
> > of balloon's inflated pages, which means (for this hypothetical case) CPU2 will
> > wait until CPU1 finishes the putaback procedure.
> > 
> 
> Yes but only until unlock finishes. The last return from function
> is not guarded and can be overwritten.

CPU1 will be returning to putback_balloon_page() which code is located at core
mm/compaction.c, outside the driver.
