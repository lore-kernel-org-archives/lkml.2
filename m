Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1HHWrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:47:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:49453 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1HHWrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:47:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,339,1309762800"; 
   d="scan'208";a="36433445"
Date: Tue, 9 Aug 2011 06:47:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110808224742.GB7176@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.733282037@intel.com>
 <1312811193.10488.33.camel@twins>
 <20110808141128.GA22080@localhost>
 <1312813909.10488.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312813909.10488.38.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 10:31:49PM +0800, Peter Zijlstra wrote:
> On Mon, 2011-08-08 at 22:11 +0800, Wu Fengguang wrote:
> > It's actually dead code because (origin < limit) should never happen.
> > I feel so good being able to drop 5 more lines of code :) 
> 
> OK, but that leaves me trying to figure out what origin is, and why its
> 4 * thresh.

origin is where the control line crosses the X axis (in both the
global/bdi setpoint cases).

"4 * thresh" is merely something larger than max(dirty, thresh)
that yields reasonably gentle slope. The more slope, the larger
"gravity" to bring the dirty pages back to the setpoint.

> I'm having a horrible time understanding this stuff.

Sorry for that. Do you have more questions?

Thanks,
Fengguang
