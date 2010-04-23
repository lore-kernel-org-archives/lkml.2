Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0DWKFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:05:36 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40027 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887Ab0DWKFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:05:35 -0400
Date: Fri, 23 Apr 2010 12:05:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Catch filesystems lacking s_bdi
Message-ID: <20100423100532.GN27497@kernel.dk>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org> <20100422062631.GC27309@logfs.org> <alpine.LFD.2.00.1004220724170.9086@i5.linux-foundation.org> <alpine.LFD.2.00.1004220730280.9086@i5.linux-foundation.org> <20100422162709.GJ27497@kernel.dk> <20100422203358.GB30749@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100422203358.GB30749@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22 2010, Jörn Engel wrote:
> On Thu, 22 April 2010 18:27:10 +0200, Jens Axboe wrote:
> > 
> > > Jens - please help fix this up.
> > 
> > Of course, I already posted a series of patches to fix this up. I want
> > to test them a bit, and I'll send them in tomorrow.
> 
> How about something like this to catch future cases?  It compiles and
> survived a test boot, so it does seem to work for the common cases like
> tmpfs, procfs, etc.
> 
> Jens, you know the bdi code 10x better than me, would this work?

Looks sane, it's a good start. I think we should augment that with a
check to ensure that we don't ever add dirty inodes to this bdi, since
it's not going to be flushed.

Something like a:

        WARN_ON(bdi == &noop_backing_dev_info);

to __mark_inode_dirty(). Looking at the code it should already trigger a
warning, since it'll check for BDI_CAP_NO_WRITEBACK (which isn't set
for noop_backing_dev_info) and the fact that noop-bdi isn't registered
to begin with.

So it's probably safe and good enough as-is, I'll add it. Thanks!

-- 
Jens Axboe

