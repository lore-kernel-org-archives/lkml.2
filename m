Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab2HNKFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:05:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab2HNKFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:05:30 -0400
Date: Tue, 14 Aug 2012 11:05:22 +0100
From: Mel Gorman <mgorman@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Miller <davem@davemloft.net>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        xen-devel@lists.xensource.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, konrad@darnok.org,
        akpm@linux-foundation.org
Subject: Re: [Xen-devel] [PATCH] netvm: check for page == NULL when
 propogating the skb->pfmemalloc flag
Message-ID: <20120814100522.GL4177@suse.de>
References: <20120807085554.GF29814@suse.de>
 <20120808.155046.820543563969484712.davem@davemloft.net>
 <20120813154144.GA24868@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120813154144.GA24868@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 11:41:44AM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Aug 08, 2012 at 03:50:46PM -0700, David Miller wrote:
> > From: Mel Gorman <mgorman@suse.de>
> > Date: Tue, 7 Aug 2012 09:55:55 +0100
> > 
> > > Commit [c48a11c7: netvm: propagate page->pfmemalloc to skb] is responsible
> > > for the following bug triggered by a xen network driver
> >  ...
> > > The problem is that the xenfront driver is passing a NULL page to
> > > __skb_fill_page_desc() which was unexpected. This patch checks that
> > > there is a page before dereferencing.
> > > 
> > > Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > 
> > That call to __skb_fill_page_desc() in xen-netfront.c looks completely bogus.
> > It's the only driver passing NULL here.
> 
> It looks to be passing a valid page pointer (at least by looking
> at the code) so I am not sure how it got turned in a NULL.
> 

Are we looking at different code bases? I see this and I was assuming it
was the source of the bug.

	__skb_fill_page_desc(skb, 0, NULL, 0, 0);

-- 
Mel Gorman
SUSE Labs
