Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0JPJar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 05:30:47 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41368 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174Ab0JPJap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 05:30:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO4NuUx5LcB2/2dsb2JhbAChMXK8WYVJBA
Date: Sat, 16 Oct 2010 20:30:43 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] fs: switch bdev inode bdi's correctly
Message-ID: <20101016093043.GB32197@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287216853-17634-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 07:13:55PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> bdev inodes can remain dirty even after their last close. Hence the
> BDI associated with the bdev->inode gets modified duringthe last
> close to point to the default BDI. However, the bdev inode still
> needs to be moved to the dirty lists of the new BDI, otherwise it
> will corrupt the writeback list is was left on.
> 
> Add a new function bdev_inode_switch_bdi() to move all the bdi state
> from the old bdi to the new one safely. This is only a temporary
> measure until the bdev inode<->bdi lifecycle problems are sorted
> out.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Nice to see you and Christoph eliminated the need for that bdev:inode
hack in my tree. Looks good.
