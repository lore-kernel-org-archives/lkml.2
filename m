Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1C1Krz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:47:55 -0400
Received: from verein.lst.de ([213.95.11.211]:45739 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab1C1Kry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:47:54 -0400
Date: Mon, 28 Mar 2011 12:47:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
        Jens Axboe <jaxboe@fusionio.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] linux-next: manual merge of the xfs tree with
	Linus' tree
Message-ID: <20110328104753.GA27327@lst.de>
References: <20110328122148.1b48a742.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328122148.1b48a742.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 12:21:48PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xfs tree got a conflict in
> fs/xfs/linux-2.6/xfs_buf.c between commit 7eaceaccab5f ("block: remove
> per-queue plugging") from Linus' tree and commit 0e6e847ffe37 ("xfs: stop
> using the page cache to back the buffer cache") from the xfs tree.
> 
> I assume that these changes (on both sides) were discussed somewhere, but
> maybe not clearly enough?
> 
> I have no idea how to fix this, so I tried to just use the xfs tree
> version for today.  That failed like this:
> 
> fs/xfs/linux-2.6/xfs_buf.c: In function 'xfs_buf_lock':
> fs/xfs/linux-2.6/xfs_buf.c:923: error: implicit declaration of function 'blk_run_backing_dev'
> 
> So I used the xfs tree from next-20110325 for today.

What XFS does is to replace blk_run_address_space, which was a wrapper
around blk_run_backing_dev with a direct call to blk_run_backing_dev,
as there change means we don't have the address_space around anymore.

Jens' tree removes both these functions, and introduces blk_flush_plug
as a sort-of replacement.  Sticking to the variant from Jens' tree / mainline
with blk_flush_plug is the correct thing here for this case.

Where there more conflicts than just this?
