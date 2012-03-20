Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab2CTC2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 22:28:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:34613 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2CTC2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 22:28:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="122729297"
Date: Mon, 19 Mar 2012 19:28:12 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        xfs-masters@oss.sgi.com
Subject: Re: [PATCH 05/11] XFS: Fix lock ASSERT on UP
Message-ID: <20120320022812.GA30406@tassilo.jf.intel.com>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
 <1331924464-18023-6-git-send-email-andi@firstfloor.org>
 <20120319224753.GC3592@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319224753.GC3592@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So this means we only ever check that the spinlock is held when
> lockdep is turned on instead of whenever CONFIG_XFS_DEBUG is set?

You should regularly test with lockdep anyways. If you don't you clearly
have a testing gap. lockdep is likely to find many more locking bugs
than any of your very sparse manual annotations.

> That means it will rarely get checked during development instead of
> all the time. That's not an improvement IMO....

It's an improvement that an !CONFIG_SMP && CONFIG_XFS_DEBUG kernel
will not blow up anymore.

-Andi
