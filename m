Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab1HPHW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:22:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:31412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1HPHWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:22:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,379,1309762800"; 
   d="scan'208";a="41842123"
Date: Tue, 16 Aug 2011 15:22:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrea Righi <andrea@betterlinux.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] writeback: per task dirty rate limit
Message-ID: <20110816072251.GA12264@localhost>
References: <20110816022006.348714319@intel.com>
 <20110816022329.063575688@intel.com>
 <20110816071709.GA1302@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816071709.GA1302@thinkpad>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (!bdi->dirty_exceeded)
> > +		ratelimit = current->nr_dirtied_pause;
> > +	else
> > +		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
> 
> Usage of ratelimit before init?
> 
> Maybe:
> 
> 	ratelimit = current->nr_dirtied_pause;
> 	if (bdi->dirty_exceeded)
> 		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));

Good catch, thanks! That's indeed the original form. I changed it to
make the code more aligned...

Thanks,
Fengguang
