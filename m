Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937Ab1LPAcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:32:03 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:17480 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756413Ab1LPAcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:32:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAB6O6k55LOCn/2dsb2JhbABDq0CBBoFyAQEFOhwPFBAIAxguFCUDIRPBBBOLDmMElHWSQA
Date: Fri, 16 Dec 2011 11:31:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS/btrfs performance after IO-less dirty throttling
Message-ID: <20111216003157.GA23662@dastard>
References: <20111214143156.GA22511@localhost>
 <20111215133137.GA14562@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215133137.GA14562@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 09:31:37PM +0800, Wu Fengguang wrote:
> > The other big regressions happen in the XFS UKEY-thresh=100M cases.
> 
> >                   3.1.0+                 3.2.0-rc3
> > ------------------------  ------------------------
> >                     4.17       -37.8%         2.59  fat/UKEY-thresh=100M/xfs-100dd-1-3.1.0+
> >                     4.14       -53.3%         1.94  fat/UKEY-thresh=100M/xfs-10dd-1-3.1.0+
> >                     6.30        +0.4%         6.33  fat/UKEY-thresh=100M/xfs-1dd-1-3.1.0+
> 
> Here are more details for the 10dd case. The attached
> balance_dirty_pages-pause.png shows small pause time (mostly in range
> 10-50ms) and nr_dirtied_pause (mostly < 5), which may be the root cause.
> 
> The iostat graphs show very unstable throughput and IO size often
> drops low.

And it's doing shitloads more allocation work. IOWs, the delayed
allocation algorithms are being strangled by writeback, causing
fragmentation and hence not allowing enough data per thread to be
written at a time to maximise throughput.

However, I'd argue that the performance of 10 concurrent writers to
a slow USB key formatted with XFS is so *completely irrelevant* that
I'd ignore it. Spend your time optimising writeback on XFS for high
throughputs (e.g > 500MB/s), not for shitty $5 USB keys that are 2-3
orders of magnitude slower than the target market for XFS...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
