Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1HXGRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:17:45 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34707
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab1HXGRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:17:44 -0400
Date: Wed, 24 Aug 2011 02:17:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        khlebnikov@openvz.org
Subject: Re: [PATCH 04/13] mm: new shrinker API
Message-ID: <20110824061743.GC24077@infradead.org>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
 <1314089786-20535-5-git-send-email-david@fromorbit.com>
 <20110823091529.GC21492@infradead.org>
 <20110823092330.GY3162@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823092330.GY3162@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 07:23:30PM +1000, Dave Chinner wrote:
> > It's much more than just a single callback these days.
> > 
> > > + * @scan_objects will be made from the current reclaim context.
> > >   */
> > >  struct shrinker {
> > >  	int (*shrink)(struct shrinker *, struct shrink_control *sc);
> > > +	long (*count_objects)(struct shrinker *, struct shrink_control *sc);
> > > +	long (*scan_objects)(struct shrinker *, struct shrink_control *sc);
> > 
> > Is shrink_object really such a good name for this method?
> 
> Apart from the fact it is called "scan_objects", I'm open to more
> appropriate names. I called is "scan_objects" because of the fact we
> are asking to scan (rather than free) a specific number objects on
> the LRU, and it matches with the "sc->nr_to_scan" control field.

Shrink_objects actually was my suggestion - while we are asked to scan
the objects the scan really isn't the main purpose of it.  

