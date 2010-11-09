Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0KIQVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:21:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56428 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0KIQVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:21:36 -0500
Date: Tue, 9 Nov 2010 11:21:31 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101109162131.GA3781@infradead.org>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 08:02:38AM -0800, Linus Torvalds wrote:
> Remind me why it wasn't sufficient to just use SLAB_DESTROY_BY_RCU?

Dave sent a patch for it, which looks much better to me.  Nick thinks
it doesn't work for his store free path walk, but I haven't seen an
explanation why exactly.

> The only thing we care about is the pathname walk - there are no other
> inode operations that are common enough to worry about. And the only
> thing _that_ needs is the ability to look at the inode under RCU, and
> SLAB_DESTROY_BY_RCU should be entirely sufficient for that.

It might be worth it for inode lookup.  While it's shadowed by the
dcache hash we still hit it a lot, especially for NFS serving.  
