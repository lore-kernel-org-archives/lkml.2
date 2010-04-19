Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0DSHiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 03:38:46 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56996 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab0DSHip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 03:38:45 -0400
Date: Mon, 19 Apr 2010 09:38:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100419073843.GN27497@kernel.dk>
References: <20100417184016.GA17345@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100417184016.GA17345@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17 2010, Jörn Engel wrote:
> Moin David,
> 
> if I read the code correctly, JFFS2 will happily perform a NOP on
> sys_sync() again.  And this time it appears to be Jens' fault.
> 
> JFFS2 does not appear to set s_bdi anywhere.  And as of 32a88aa1,
> __sync_filesystem() will return 0 if s_bdi is not set.  As a result,
> sync_fs() is never called for jffs2 and whatever remains in the wbuf
> will not make it to the device.
> 
> The patch also adds a BUG_ON to catch this problem in any remaining or
> future offenders.  I am not sure about network filesystems, but at
> least bdev- and mtd-based ones should be caught.
> 
> Opinions?

I think that BUG_ON() would be a lot better as a printk() and fail mount
instead. There's really little point in killing the kernel for something
you could easily warn about and recover nicely.

-- 
Jens Axboe

