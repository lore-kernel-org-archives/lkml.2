Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab0J0PbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:31:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab0J0PbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:31:18 -0400
Date: Wed, 27 Oct 2010 11:31:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bryan Schumaker <bjschuma@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: nfsd changes for 2.6.37
Message-ID: <20101027153114.GA23126@infradead.org>
References: <20101026164549.GD19445@fieldses.org>
 <20101027145538.GC6328@fieldses.org>
 <20101027145929.GA5788@infradead.org>
 <201010271723.59734.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010271723.59734.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:23:59PM +0200, Arnd Bergmann wrote:
> It comes back to the original problem with Bruce's patch though:
> fcntl_setlease wants to atomically add a lease or fail. If
> fasync_helper fails, we want to remove the lease that was
> just added before anyone can see it. At the very least we need
> to keep the flock from getting freed in another thread while
> we call fasync_helper without the lock.

a variant of fasync_add_entry that takes a preallocated
fasync_struct would indeed take care of that.

> locks_delete_lock is also called with lock_flocks held and calls
> fasync_helper...

but with on = 0, which calls into fasync_remove_entry, which doesn't
sleep.

