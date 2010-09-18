Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0IRNsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 09:48:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54029 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab0IRNsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 09:48:22 -0400
Date: Sat, 18 Sep 2010 07:48:20 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/locks.c: prepare for BKL removal
Message-ID: <20100918134819.GB25139@parisc-linux.org>
References: <1284815371-5843-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284815371-5843-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 03:09:31PM +0200, Arnd Bergmann wrote:
> This prepares the removal of the big kernel lock from the
> file locking code. We still use the BKL as long as fs/lockd
> uses it and ceph might sleep, but we can flip the definition
> to a private spinlock as soon as that's done.
> All users outside of fs/lockd get converted to use
> lock_flocks() instead of lock_kernel() where appropriate.
> 
> Based on an earlier patch to use a spinlock from Matthew
> Wilcox, who has attempted this a few times before. An even
> earlier attempt to use a semaphore instead of the BKL
> apparently was made by Andrew Morton about ten years ago,
> but reverted for performance reasons.

Actually, I attempted the semaphore conversion ten years ago, but Andrew
Morton reverted it due to the performance regression.  I believe it was
Apache, when it was using file locks to synchronise between threads.

Patch looks good; Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
