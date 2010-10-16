Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab0JPQbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:31:18 -0400
Received: from canuck.infradead.org ([134.117.69.58]:55165 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0JPQbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:31:17 -0400
Date: Sat, 16 Oct 2010 12:31:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] fs: switch bdev inode bdi's correctly
Message-ID: <20101016163116.GD20086@infradead.org>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287216853-17634-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
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

Ok for now, I really hope my progress on sorting out the bdi mess
will eventually get rid of this.

Reviewed-by: Christoph Hellwig <hch@lst.de>
