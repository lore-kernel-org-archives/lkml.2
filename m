Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1HJOPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:15:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:8149 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1HJOPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,350,1309762800"; 
   d="scan'208";a="37069769"
Date: Wed, 10 Aug 2011 22:15:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: dirty rate control
Message-ID: <20110810141535.GD29724@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.878435971@intel.com>
 <1312909322.1083.52.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312909322.1083.52.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 01:02:02AM +0800, Peter Zijlstra wrote:
> On Sat, 2011-08-06 at 16:44 +0800, Wu Fengguang wrote:
> 
> > +       pos_bw = bw * pos_ratio >> BANDWIDTH_CALC_SHIFT;
> > +       pos_bw++;  /* this avoids bdi->dirty_ratelimit get stuck in 0 */
> > +
> 
> > +       pos_ratio *= bdi->avg_write_bandwidth;
> > +       do_div(pos_ratio, dirty_bw | 1);
> > +       ref_bw = bw * pos_ratio >> BANDWIDTH_CALC_SHIFT; 
> 
> when written out that results in:
> 
>            bw * pos_ratio * bdi->avg_write_bandwidth
>   ref_bw = -----------------------------------------
>                          dirty_bw
> 
> which would suggest you write it like:
> 
>   ref_bw = div_u64((u64)pos_bw * bdi->avg_write_bandwidth, dirty_bw | 1);
> 
> since pos_bw is already bw * pos_ratio per the above.

Good point. Oopse I even wrote a comment for the over complex calculation:

         * balanced_rate = pos_rate * write_bw / dirty_rate

Thanks,
Fengguang
