Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0HBJFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:05:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46813 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0HBJFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:05:46 -0400
Date: Mon, 2 Aug 2010 05:05:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
Message-ID: <20100802090542.GA32322@infradead.org>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802023322.GA19164@dastard>
 <AANLkTint_s6h_EC7mDiPsyxr=C0GSrnrgJYkCCU7JEtN@mail.gmail.com>
 <20100802055834.GB19164@dastard>
 <20100802075537.GC7841@amd>
 <20100802082428.GA23135@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802082428.GA23135@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 04:24:28AM -0400, Christoph Hellwig wrote:
> .36.  I'd much rather see the inode_lock scaling or the lockless path
> walk going in before, but I haven't checked how complicated the
> reordering would be.  The lockless path walk also is only rather
> theoretically useful until we do ACL checks lockless as we're having
> ACLs enabled pretty much everywhere at least in the distros.

>From a quick look it seems like the inode_lock splitup can easily
be moved forward, and it would help us with doing some work on the
writeback side.  The problem is that it would need rebasing ontop
of both the vfs and writeback (aka block) trees.

