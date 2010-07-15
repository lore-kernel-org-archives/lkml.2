Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab0GOA2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:28:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756845Ab0GOA2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:28:04 -0400
Date: Wed, 14 Jul 2010 17:27:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>
Subject: Re: linux-next: Tree for July 7
Message-Id: <20100714172741.f520b7a3.akpm@linux-foundation.org>
In-Reply-To: <20100715094513.8941fa25.sfr@canb.auug.org.au>
References: <20100707165539.957e7d1c.sfr@canb.auug.org.au>
	<20100707172136.3658fb17.akpm@linux-foundation.org>
	<20100714152042.5b83f03b.akpm@linux-foundation.org>
	<20100715094513.8941fa25.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 09:45:13 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew, Al,
> 
> On Wed, 14 Jul 2010 15:20:42 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Bug is still there.  Reverting ""Make ->drop_inode() just return
> > whether inode needs to be dropped" makes it go away.
> > 
> > Al, please don't just dump crap in linux-next and then ignore bug reports. 
> > People are trying to get work done here.
> 
> I will revert that commit in linux-next today if it is still there (and
> not fixed).

Reverting the patch didn't help - the patch moved the BUG_ON() from
generic_delete_inode() into __iput_final().  With the patch reverted
the kernel still goes BUG over the same test in generic_delete_inode().

It could be that the bug was caused by fs-writeback.c changes.  David,
do you have time to take a look at this?
