Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0DSKQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:16:15 -0400
Received: from lazybastard.de ([212.112.238.170]:56072 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab0DSKQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:16:13 -0400
Date: Mon, 19 Apr 2010 12:15:59 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100419101559.GA4145@logfs.org>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100419073843.GN27497@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 April 2010 09:38:44 +0200, Jens Axboe wrote:
> On Sat, Apr 17 2010, Jörn Engel wrote:
> > Moin David,
> > 
> > if I read the code correctly, JFFS2 will happily perform a NOP on
> > sys_sync() again.  And this time it appears to be Jens' fault.
> > 
> > JFFS2 does not appear to set s_bdi anywhere.  And as of 32a88aa1,
> > __sync_filesystem() will return 0 if s_bdi is not set.  As a result,
> > sync_fs() is never called for jffs2 and whatever remains in the wbuf
> > will not make it to the device.
> > 
> > The patch also adds a BUG_ON to catch this problem in any remaining or
> > future offenders.  I am not sure about network filesystems, but at
> > least bdev- and mtd-based ones should be caught.
> > 
> > Opinions?
> 
> I think that BUG_ON() would be a lot better as a printk() and fail mount
> instead. There's really little point in killing the kernel for something
> you could easily warn about and recover nicely.

*shrug*
The BUG_ON directly above is not qualitatively different.  In both cases
the only solution is to find and fix the bug in some other file,
recompile and try again.  But ultimately I don't care, as long as we
catch the bug before people lose their data.

Feel free to respin this patch.  You caused the problem in the first
place. ;)

For the record, while I consider the two-liner that causes this mess a
real turd, the rest of your patch was brilliant.  A shame I didn't catch
this earlier.

Jörn

-- 
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace
