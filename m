Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0INUy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:54:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab0INUy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <201009142239.02904.arnd@arndb.de>
References: <201009142206.54130.arnd@arndb.de> <AANLkTimzFDdWbr2gtfmJmfGJVnyURcpvwnGf334ZHVYc@mail.gmail.com>
 <201009142239.02904.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Sep 2010 13:53:31 -0700
Message-ID: <AANLkTimK5kesHJV3mspRch-YVe8uRT=ypqNMHr2L9wHC@mail.gmail.com>
Subject: Re: [PATCH] Remove BKL from fs/locks.c
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 1:39 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Hmm, maybe I'm misunderstanding part of that plan, but I think it
> won't work because the BKL in there seems to protect all struct file_lock
> instances and they are passed around to other code, most importantly
> lockd. The file_locks themselves can be accessed both using sys_flock()
> etc locally and using afs/nfs/coda/... exported file systems from other
> systems.

Ahh, so lockd actually walks those things itself too, not just using
the fs/locks.c interfaces. Ok, scratch that then.

Oh well. I guess there's no incremental way to do things sanely. And
nobody has patches to fix those users, I guess.

                                Linus
