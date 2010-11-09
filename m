Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0KIRP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:15:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0KIRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:15:27 -0500
Date: Tue, 9 Nov 2010 12:15:22 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101109171522.GA4522@infradead.org>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:08:17AM -0800, Linus Torvalds wrote:
> Again, this is only an issue for non-dentry lookup. For the dentry
> case, we know that if the dentry still exists, then the inode still
> exists. So we don't need to check a stable inode pointer if we just
> verify the stability of the dentry - and we'll have to do that anyway
> obviously.

If the dentry still exists we have a reference on the inode and never
call into the inode hash.

> In other words: let's bite off the complexity in small chunks. Let's
> keep the inode lock approach for now for the actual inode lists and
> hash lookups. I think they are almost entirely independent issues from
> the dentry path.

I'm defintively in favour of splitting things into small chunks.  I
don't particularly care how we do it.  inode_lock scaling seems the
most simple bit to me, and even that turned out to be a massive
amount of work to do properly.

Doing the dentry_lock splitup last starts to look more and more
interesting given how messy inode_lock is, though.
