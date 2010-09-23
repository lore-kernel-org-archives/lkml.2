Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0IWDk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:40:59 -0400
Received: from cobra.newdream.net ([66.33.216.30]:57402 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0IWDk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:40:58 -0400
Date: Wed, 22 Sep 2010 20:42:49 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Arnd Bergmann <arnd@arndb.de>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        linux-fsdevel@vger.kernel.org, gregf@hq.newdream.net
Subject: Re: [PATCH] fs/locks.c: prepare for BKL removal
In-Reply-To: <201009212209.51956.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1009222037500.14029@cobra.newdream.net>
References: <1284815371-5843-1-git-send-email-arnd@arndb.de>
 <20100920160729.96872d12.sfr@canb.auug.org.au> <Pine.LNX.4.64.1009210910410.13310@cobra.newdream.net>
 <201009212209.51956.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Arnd Bergmann wrote:

> On Tuesday 21 September 2010 18:12:07 Sage Weil wrote:
> > On Mon, 20 Sep 2010, Stephen Rothwell wrote:
> > 
> > > On Sun, 19 Sep 2010 20:59:01 -0700 (PDT) Sage Weil <sage@newdream.net> wrote:
> > > >
> > > > I suspect the easiest thing is to leave Ceph out of this stage of your 
> > > > series, I'll switch lock_kernel() to lock_flocks() once that exists 
> > > > upstream.  Unless there is a better way? 
> > > 
> > > Maybe someone could write a trivial implementation of lock_flocks() (i.e.
> > > one that does not make any changes to behaviour) and ask Linus to take it
> > > now in preparation for the next merge window (he has done that before).
> > > That way, more of this could be put into individual other trees and avoid
> > > more conflicts ...
> > 
> > This sounds like the easiest solution to me.  Something as simple as
> > 
> > #define lock_flocks lock_kernel
> > #define unlock_flocks unlock_kernel
> > 
> > in fs.h?
> 
> Sounds fine to me. I don't think it's necessary but if you prefer to do
> it, you can have my Ack.

Okay, the lock/unlock_flocks() stubs on in Linus' tree now, and the Ceph 
for-next branch is rebased and updated to fix the memory allocations and 
switch to the new interface.

Unfortunately you still need to #include smp_lock.h for now since the 
stubs are just #defines, so we'll need to remember to clean that up later.

sage
