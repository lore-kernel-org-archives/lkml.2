Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1ILKUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 06:20:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41642 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1ILKUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:20:19 -0400
Subject: Re: [PATCH 10/18] writeback: dirty position control - bdi reserve
 area
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 12 Sep 2011 12:19:38 +0200
In-Reply-To: <20110907123108.GB6862@localhost>
References: <20110904015305.367445271@intel.com>
	 <20110904020915.942753370@intel.com> <1315318179.14232.3.camel@twins>
	 <20110907123108.GB6862@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315822779.26517.23.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 20:31 +0800, Wu Fengguang wrote:
> > > +   x_intercept = min(write_bw, freerun);
> > > +   if (bdi_dirty < x_intercept) {
> > 
> > So the point of the freerun point is that we never throttle before it,
> > so basically all the below shouldn't be needed at all, right? 
> 
> Yes!
> 
> > > +           if (bdi_dirty > x_intercept / 8) {
> > > +                   pos_ratio *= x_intercept;
> > > +                   do_div(pos_ratio, bdi_dirty);
> > > +           } else
> > > +                   pos_ratio *= 8;
> > > +   }
> > > +
> > >     return pos_ratio;
> > >  }

Does that mean we can remove this whole block?

> > 
> > So why not add:
> > 
> >       if (likely(dirty < freerun))
> >               return 2;
> > 
> > at the start of this function and leave it at that?
> 
> Because we already has
> 
>         if (nr_dirty < freerun)
>                 break;
> 
> in the main balance_dirty_pages() loop ;)

Bah! I keep missing that ;-)
