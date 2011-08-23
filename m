Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1HWDxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 23:53:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:10607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1HWDxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 23:53:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,266,1312182000"; 
   d="scan'208";a="41331375"
Date: Tue, 23 Aug 2011 11:53:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] writeback: IO-less balance_dirty_pages()
Message-ID: <20110823035335.GA26739@localhost>
References: <20110816022006.348714319@intel.com>
 <20110816022329.190706384@intel.com>
 <20110819020637.GA13597@redhat.com>
 <20110819025406.GA13365@localhost>
 <20110819190037.GJ18656@redhat.com>
 <20110821034657.GA30747@localhost>
 <20110822172230.GB17833@redhat.com>
 <20110823010721.GB7332@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823010721.GB7332@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   Because task_ratelimit_0 is initial value to begin with and we will
> >   keep on coming with new value every 200ms, we should be able to write
> >   above as follows.
> > 
> > 						      write_bw
> >   bdi->dirty_ratelimit_n = bdi->dirty_ratelimit_n-1 * --------  (8)
> > 						      dirty_bw
> > 
> >   Effectively we start with an initial value of task_ratelimit_0 and
> >   then keep on updating it based on rate change feedback every 200ms.

Ah sorry, based on the reply to Peter, there is no inherent dependency
between balanced_rate_n and balanced_rate_(n-1). bdi->dirty_ratelimit does
track balanced_rate in small steps, and hence will have some relationship
with its previous value other than equation (8).

So, although you may conduct equation (8) for balanced_rate, we'd
better not understand things in that way. Keep this fundamental
formula in mind and don't try to complicate it:

        balanced_rate = task_ratelimit_200ms * write_bw / dirty_rate

Thanks,
Fengguang
