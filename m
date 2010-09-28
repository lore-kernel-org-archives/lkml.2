Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0I1Vlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:41:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54751 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0I1Vlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:41:45 -0400
Date: Tue, 28 Sep 2010 22:41:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: cleanup gfp_zone()
Message-ID: <20100928214141.GG19804@ZenIV.linux.org.uk>
References: <1285676624-1300-1-git-send-email-namhyung@gmail.com>
 <20100928143239.5fe34e1e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928143239.5fe34e1e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 02:32:39PM -0700, Andrew Morton wrote:
> > +#define ZT_SHIFT(gfp) ((__force int) (gfp) * ZONES_SHIFT)
> >  #define GFP_ZONE_TABLE ( \
> > -	(ZONE_NORMAL << 0 * ZONES_SHIFT)				\
> > -	| (OPT_ZONE_DMA << __GFP_DMA * ZONES_SHIFT)			\
> > -	| (OPT_ZONE_HIGHMEM << __GFP_HIGHMEM * ZONES_SHIFT)		\
> > -	| (OPT_ZONE_DMA32 << __GFP_DMA32 * ZONES_SHIFT)			\
> > -	| (ZONE_NORMAL << __GFP_MOVABLE * ZONES_SHIFT)			\
> > -	| (OPT_ZONE_DMA << (__GFP_MOVABLE | __GFP_DMA) * ZONES_SHIFT)	\
> > -	| (ZONE_MOVABLE << (__GFP_MOVABLE | __GFP_HIGHMEM) * ZONES_SHIFT)\
> > -	| (OPT_ZONE_DMA32 << (__GFP_MOVABLE | __GFP_DMA32) * ZONES_SHIFT)\
> > +	(ZONE_NORMAL        << ZT_SHIFT(0))				\
> > +	| (OPT_ZONE_DMA     << ZT_SHIFT(__GFP_DMA))			\
> > +	| (OPT_ZONE_HIGHMEM << ZT_SHIFT(__GFP_HIGHMEM))			\
> > +	| (OPT_ZONE_DMA32   << ZT_SHIFT(__GFP_DMA32))			\
> > +	| (ZONE_NORMAL      << ZT_SHIFT(__GFP_MOVABLE))			\
> > +	| (OPT_ZONE_DMA     << ZT_SHIFT(__GFP_MOVABLE | __GFP_DMA))	\
> > +	| (ZONE_MOVABLE     << ZT_SHIFT(__GFP_MOVABLE | __GFP_HIGHMEM)) \
> > +	| (OPT_ZONE_DMA32   << ZT_SHIFT(__GFP_MOVABLE | __GFP_DMA32))	\
> >  )
> 
> hm.  I hope these sparse warnings are sufficiently useful to justify
> all the gunk we're adding to support them.
> 
> Is it actually finding any bugs?

FWIW, bitwise or done in the right-hand argumet of shift looks ugly as hell;
what the hell is that code _doing_?
