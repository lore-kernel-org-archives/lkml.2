Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0INV4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 17:56:33 -0400
Received: from mx2.netapp.com ([216.240.18.37]:28887 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab0INV4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 17:56:32 -0400
X-IronPort-AV: E=Sophos;i="4.56,367,1280732400"; 
   d="scan'208";a="450375710"
Subject: Re: [PATCH] Remove BKL from fs/locks.c
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <201009142324.16074.arnd@arndb.de>
References: <201009142206.54130.arnd@arndb.de>
	 <201009142239.02904.arnd@arndb.de>
	 <AANLkTimK5kesHJV3mspRch-YVe8uRT=ypqNMHr2L9wHC@mail.gmail.com>
	 <201009142324.16074.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Tue, 14 Sep 2010 17:55:56 -0400
Message-ID: <1284501356.10782.139.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 14 Sep 2010 21:56:28.0933 (UTC) FILETIME=[AF40AB50:01CB5457]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 23:24 +0200, Arnd Bergmann wrote:
> On Tuesday 14 September 2010 22:53:31 Linus Torvalds wrote:
> > Oh well. I guess there's no incremental way to do things sanely. And
> > nobody has patches to fix those users, I guess.
> 
> The only critical user is fs/lockd, I can easily handle the rest.
> When I talked to Bruce and Trond during LinuxCon, they told me that
> it should be possible to separate the bits of fs/lockd that lock
> against fs/locks.c and convert the former to use lock_flocks().


The NFSv4 client is quite ready to just switch to using lock_flocks()
now. There is nothing that depends on the magical properties of the BKL.
I do also have someone working on BKL removal for the NLM/lockd client
and am hoping that should be ready in a couple of weeks time.

The timeline for the server is up to Bruce, however.

> That would be enough to actually apply this patch without the
> nasty CONFIG_BKL check and with changes to the few other
> consumers of file locks. My original plan was to have my current
> patch in -next until that happens.

Would it be possible to at least merge a patch that defines
lock_flocks() (even if it just is an alias for lock_kernel()), so that
we can convert those bits of the lock recovery code that need to peek
into the inode->i_flock list ASAP?

Cheers
  Trond
