Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab1LPEZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:25:13 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:49745 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826Ab1LPEZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:25:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGHG6k55LOCn/2dsb2JhbABEq02BBoFyAQEEATocIwULCAMYLhQlAyETh3q5EhOLDmMElHWSQA
Date: Fri, 16 Dec 2011 15:25:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS/btrfs performance after IO-less dirty throttling
Message-ID: <20111216042508.GE23662@dastard>
References: <20111214143156.GA22511@localhost>
 <20111215133137.GA14562@localhost>
 <20111216003157.GA23662@dastard>
 <20111216015311.GA15996@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216015311.GA15996@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 09:53:11AM +0800, Wu Fengguang wrote:
> I'm indeed happy that you don't care that much on that regression
> introduced by me ;-)

Heh.

BTW, do these tests run to ENOSPC?

>                 10829.00        +4.3%     11296.00  TOTAL xfs:xfs_delalloc_enospc

This implies that it does.

If so, I'm not sure how much we can really trust these overall
results because allocation and writeback speeds at ENOSPC is
anything but deterministic. It will certainly have an effect
(detrimental) on throughput as the filesystem gets close to full....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
