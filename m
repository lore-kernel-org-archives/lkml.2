Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1HWJXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:23:36 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46892 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685Ab1HWJXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:23:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkDANhwU055LIxDgWdsb2JhbABBqCEVAQEWJiWBQAEBBScTHCMQCAMOCi4UJQMhE788DoY6BKQl
Date: Tue, 23 Aug 2011 19:23:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, khlebnikov@openvz.org
Subject: Re: [PATCH 04/13] mm: new shrinker API
Message-ID: <20110823092330.GY3162@dastard>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
 <1314089786-20535-5-git-send-email-david@fromorbit.com>
 <20110823091529.GC21492@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823091529.GC21492@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 05:15:29AM -0400, Christoph Hellwig wrote:
> >  /*
> >   * A callback you can register to apply pressure to ageable caches.
> 
> It's much more than just a single callback these days.
> 
> > + * @scan_objects will be made from the current reclaim context.
> >   */
> >  struct shrinker {
> >  	int (*shrink)(struct shrinker *, struct shrink_control *sc);
> > +	long (*count_objects)(struct shrinker *, struct shrink_control *sc);
> > +	long (*scan_objects)(struct shrinker *, struct shrink_control *sc);
> 
> Is shrink_object really such a good name for this method?

Apart from the fact it is called "scan_objects", I'm open to more
appropriate names. I called is "scan_objects" because of the fact we
are asking to scan (rather than free) a specific number objects on
the LRU, and it matches with the "sc->nr_to_scan" control field.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
