Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0GGBwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:52:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0GGBwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:52:33 -0400
Date: Tue, 6 Jul 2010 21:52:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/6] block: remove BKL from BLKROSET and BLKFLSBUF
Message-ID: <20100707015232.GF2950@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
 <1278193640-24223-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278193640-24223-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 11:47:18PM +0200, Arnd Bergmann wrote:
> We only call the functions set_device_ro(),
> invalidate_bdev(), sync_filesystem() and sync_blockdev()
> while holding the BKL in these commands. All
> of these are also done in other code paths without
> the BKL, which leads me to the conclusion that
> the BKL is not needed here either.
> 
> The reason we hold it here is that it was originally
> pushed down into the ioctl function from vfs_ioctl.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

