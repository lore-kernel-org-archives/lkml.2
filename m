Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0HWOuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:50:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab0HWOub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:50:31 -0400
Date: Mon, 23 Aug 2010 10:50:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: aio: bump i_count instead of using igrab
Message-ID: <20100823145031.GA1279@infradead.org>
References: <20100823144755.GP21975@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100823144755.GP21975@think>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 10:47:55AM -0400, Chris Mason wrote:
> The aio batching code is using igrab to get an extra reference on the
> inode so it can safely batch.  igrab will go ahead and take the global
> inode spinlock, which can be a bottleneck on large machines doing lots
> of AIO.
> 
> In this case, igrab isn't required because we already have a reference
> on the file handle.  It is safe to just bump the i_count directly
> on the inode.
> 
> Benchmarking shows this patch brings IOP/s on tons of flash up by about
> 2.5X.

There's some places in XFS where we do the same, and it showed up as a
bottle neck before.  Instead of open coding the increment we have
a wrapper that includes and assert that the numbers is always positive.

I think we really want a proper helper for general use instead of
completly opencoding it.

