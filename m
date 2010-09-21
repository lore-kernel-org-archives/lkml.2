Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab0IUQKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:10:22 -0400
Received: from cobra.newdream.net ([66.33.216.30]:38771 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0IUQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:10:20 -0400
Date: Tue, 21 Sep 2010 09:12:07 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        linux-fsdevel@vger.kernel.org, gregf@hq.newdream.net
Subject: Re: [PATCH] fs/locks.c: prepare for BKL removal
In-Reply-To: <20100920160729.96872d12.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1009210910410.13310@cobra.newdream.net>
References: <1284815371-5843-1-git-send-email-arnd@arndb.de>
 <Pine.LNX.4.64.1009192009260.9243@cobra.newdream.net>
 <20100920160729.96872d12.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Stephen Rothwell wrote:

> On Sun, 19 Sep 2010 20:59:01 -0700 (PDT) Sage Weil <sage@newdream.net> wrote:
> >
> > I suspect the easiest thing is to leave Ceph out of this stage of your 
> > series, I'll switch lock_kernel() to lock_flocks() once that exists 
> > upstream.  Unless there is a better way? 
> 
> Maybe someone could write a trivial implementation of lock_flocks() (i.e.
> one that does not make any changes to behaviour) and ask Linus to take it
> now in preparation for the next merge window (he has done that before).
> That way, more of this could be put into individual other trees and avoid
> more conflicts ...

This sounds like the easiest solution to me.  Something as simple as

#define lock_flocks lock_kernel
#define unlock_flocks unlock_kernel

in fs.h?
sage
