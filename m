Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1HHNq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:46:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1HHNq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:46:58 -0400
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 08 Aug 2011 15:46:33 +0200
In-Reply-To: <20110806094526.733282037@intel.com>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.733282037@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312811193.10488.33.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 16:44 +0800, Wu Fengguang wrote:
> +static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
> +                                       unsigned long thresh,
> +                                       unsigned long dirty,
> +                                       unsigned long bdi_thresh,
> +                                       unsigned long bdi_dirty)
> +{
> +       unsigned long limit = hard_dirty_limit(thresh);
> +       unsigned long origin;
> +       unsigned long goal;
> +       unsigned long long span;
> +       unsigned long long pos_ratio;   /* for scaling up/down the rate limit */
> +
> +       if (unlikely(dirty >= limit))
> +               return 0;
> +
> +       /*
> +        * global setpoint
> +        */
> +       goal = thresh - thresh / DIRTY_SCOPE;
> +       origin = 4 * thresh;
> +
> +       if (unlikely(origin < limit && dirty > (goal + origin) / 2)) {
> +               origin = limit;                 /* auxiliary control line */
> +               goal = (goal + origin) / 2;
> +               pos_ratio >>= 1; 

use before init?
