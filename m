Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2HOIw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:52:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60110 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab2HOIwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:52:25 -0400
Date: Wed, 15 Aug 2012 09:52:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rafael Aquini <aquini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120815085218.GG4052@csn.ul.ie>
References: <cover.1344619987.git.aquini@redhat.com>
 <292b1b52e863a05b299f94bda69a61371011ac19.1344619987.git.aquini@redhat.com>
 <20120813082619.GE14081@redhat.com>
 <20120814174404.GA13338@t510.redhat.com>
 <20120814193525.GB28840@redhat.com>
 <20120814200043.GB22133@t510.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120814200043.GB22133@t510.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 05:00:49PM -0300, Rafael Aquini wrote:
> On Tue, Aug 14, 2012 at 10:35:25PM +0300, Michael S. Tsirkin wrote:
> > > > > +/* __isolate_lru_page() counterpart for a ballooned page */
> > > > > +bool isolate_balloon_page(struct page *page)
> > > > > +{
> > > > > +	if (WARN_ON(!movable_balloon_page(page)))
> > > > 
> > > > Looks like this actually can happen if the page is leaked
> > > > between previous movable_balloon_page and here.
> > > > 
> > > > > +		return false;
> > > 
> > > Yes, it surely can happen, and it does not harm to catch it here, print a warn and
> > > return.
> > 
> > If it is legal, why warn? For that matter why test here at all?
> >
> 
> As this is a public symbol, and despite the usage we introduce is sane, the warn
> was placed as an insurance policy to let us know about any insane attempt to use
> the procedure in the future. That was due to a nice review nitpick, actually.
> 
> Even though the code already had a test to properly avoid this race you
> mention, I thought that sustaining the warn was a good thing. As I told you,
> despite real, I've never got (un)lucky enough to stumble across that race window
> while testing the patch.
> 
> If your concern is about being too much verbose on logging, under certain
> conditions, perhaps we can change that test to a WARN_ON_ONCE() ?
> 
> Mel, what are your thoughts here?
>  

I viewed it as being defensive programming. VM_BUG_ON would be less
useful as it can be compiled out. If the race can be routinely hit then
multiple warnings is instructive in itself. I have no strong feelings
about this though. I see little harm in making the check but in light of
this conversation add a short comment explaining that the check should
be redundant.

-- 
Mel Gorman
SUSE Labs
