Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1HLNI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:08:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54383 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1HLNI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:08:56 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Aug 2011 15:08:24 +0200
In-Reply-To: <20110812125952.GA16675@localhost>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.733282037@intel.com> <1312811193.10488.33.camel@twins>
	 <20110808141128.GA22080@localhost> <1312814501.10488.41.camel@twins>
	 <20110808230535.GC7176@localhost> <1313153657.6576.40.camel@twins>
	 <20110812125952.GA16675@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313154504.6576.44.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 20:59 +0800, Wu Fengguang wrote:
> On Fri, Aug 12, 2011 at 08:54:17PM +0800, Peter Zijlstra wrote:
> > On Fri, 2011-08-12 at 00:56 +0200, Peter Zijlstra wrote:
> > > 
> > >                s - x 3
> > >  f(x) :=  1 + (-----)
> > >                  d
> > > 
> > btw, if you want steeper slopes for rampup and brake you can add another
> > factor like:
> > 
> >                  s - x 3
> >   f(x) :=  1 + a(-----)
> >                    d
> >  
> > And solve the whole f(l)=0 thing again to determine d in l and a.
> > 
> > For 0 < a < 1 the slopes increase.
> 
> Yes, we can leave it as a future tuning option. For now I'm pretty
> satisfied with the current function's shape :)

Oh for sure, it just occurred to me when looking at your plots and
thought I'd at least mention it.. You know something to poke at on a
rainy afternoon ;-)
