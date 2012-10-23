Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2JWNEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:04:54 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49481
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756796Ab2JWNEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:04:53 -0400
Date: Tue, 23 Oct 2012 09:04:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v3 00/22] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20121023130451.GB21594@infradead.org>
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:15:00AM -0500, Dave Kleikamp wrote:
> This is the current version of the patchset I presented at the LSF-MM
> Summit in San Francisco in April. I apologize for letting it go so
> long before re-submitting.
> 
> This patchset was begun by Zach Brown and was originally submitted for
> review in October, 2009. Feedback was positive, and I have picked up
> where he left off, porting his patches to the latest mainline kernel
> and adding support more file systems.
> 
> This patch series adds a kernel interface to fs/aio.c so that kernel code can
> issue concurrent asynchronous IO to file systems.  It adds an aio command and
> file system methods which specify io memory with pages instead of userspace
> addresses.
> 
> This series was written to reduce the current overhead loop imposes by
> performing synchronus buffered file system IO from a kernel thread.  These
> patches turn loop into a light weight layer that translates bios into iocbs.
> 
> The downside of this is that in its current implementation, performance takes
> a big hit for non-synchonous I/O, since the underlying page cache is bypassed.
> The tradeoff is that all writes to the loop device make it to the underlying
> media, making loop-mounted file systems recoverable.

It also seems to still not fully kill thr old aio_read/write codepath.
At least XFS isn't touched yet.  It also doesn't seem to kill the nasty
hack for in-kernel direct I/O introduced with the swap over nfs code
(grep for REQ_KERNEL / KERNEL_READ / KERNEL_WRITE)

