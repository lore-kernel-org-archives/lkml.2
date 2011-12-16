Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab1LPFQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 00:16:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:50919 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1LPFQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 00:16:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="87166957"
Date: Fri, 16 Dec 2011 13:16:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS/btrfs performance after IO-less dirty throttling
Message-ID: <20111216051609.GA4502@localhost>
References: <20111214143156.GA22511@localhost>
 <20111215133137.GA14562@localhost>
 <20111216003157.GA23662@dastard>
 <20111216015311.GA15996@localhost>
 <20111216042508.GE23662@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216042508.GE23662@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 12:25:08PM +0800, Dave Chinner wrote:
> On Fri, Dec 16, 2011 at 09:53:11AM +0800, Wu Fengguang wrote:
> > I'm indeed happy that you don't care that much on that regression
> > introduced by me ;-)
> 
> Heh.
> 
> BTW, do these tests run to ENOSPC?

Nope. Shall ENOSPC (performance) be tested?

> >                 10829.00        +4.3%     11296.00  TOTAL xfs:xfs_delalloc_enospc
> 
> This implies that it does.

Not really. The USB key partition size is 7.1GB.
Even in the fastest 1dd case, only 4GB data is written:

wfg@bee /export/writeback% cat fat/UKEY-thresh=100M/xfs-1dd-1-3.2.0-rc3/ls-files 
131 -rw-rw-r-- 1 root root 4060078080 Dec  8 15:57 /fs/sdb3/zero-1

That's about 6.7MB/s write bandwidth running for 600 seconds.

Thanks,
Fengguang
