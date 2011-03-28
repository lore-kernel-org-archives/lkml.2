Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1C1Kxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:53:50 -0400
Received: from verein.lst.de ([213.95.11.211]:54195 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab1C1Kxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:53:49 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Mar 2011 06:53:49 EDT
Date: Mon, 28 Mar 2011 12:53:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
        Jens Axboe <jaxboe@fusionio.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] linux-next: manual merge of the xfs tree with
	Linus' tree
Message-ID: <20110328105348.GA27458@lst.de>
References: <20110328122148.1b48a742.sfr@canb.auug.org.au> <20110328104753.GA27327@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328104753.GA27327@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 12:47:53PM +0200, Christoph Hellwig wrote:
> What XFS does is to replace blk_run_address_space, which was a wrapper
> around blk_run_backing_dev with a direct call to blk_run_backing_dev,
> as there change means we don't have the address_space around anymore.
> 
> Jens' tree removes both these functions, and introduces blk_flush_plug
> as a sort-of replacement.  Sticking to the variant from Jens' tree / mainline
> with blk_flush_plug is the correct thing here for this case.
> 
> Where there more conflicts than just this?

Actually I think we can remove some calls alltogether:  the on-stack
plugging already flushes the plug queue when context switching,
which we'll always do in xfs_buf_wait_unpin, and if we get the lock
without blocking in xfs_buf_lock we don't need to unplug either.

Anyway, that's something to take care off in the XFS tree once it's
merged after the next pull for Linus, no need to keep a fixup that
complicated in linux-next.
