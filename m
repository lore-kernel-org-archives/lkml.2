Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab1GWIHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 04:07:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:33872 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1GWIHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 04:07:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,252,1309762800"; 
   d="scan'208";a="30600769"
Date: Sat, 23 Jul 2011 16:07:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] writeback: bdi write bandwidth estimation
Message-ID: <20110723080721.GC31975@localhost>
References: <20110629145245.835998321@intel.com>
 <20110629145553.906668553@intel.com>
 <20110701192915.GE28563@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701192915.GE28563@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 02, 2011 at 03:29:15AM +0800, Vivek Goyal wrote:
> On Wed, Jun 29, 2011 at 10:52:48PM +0800, Wu Fengguang wrote:
> > The estimation value will start from 100MB/s and adapt to the real
> > bandwidth in seconds.
> > 
> > It tries to update the bandwidth only when disk is fully utilized.
> > Any inactive period of more than one second will be skipped.
> 
> Is this piece of code being tested in your graphs? Are there any
> inactive periods which get filtered out in your workload? I am 
> assuming in a continuous dd, we will not have periods of inactivity
> 1 second long.

There are no inactive periods in the dd tests. However I did try
"watch cat /debug/bdi/8:0/stats" while starting some write workloads
in background. When the write stops, the bandwidth does stop updating.

Thanks,
Fengguang
