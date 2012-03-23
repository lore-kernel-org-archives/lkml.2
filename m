Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2CWW7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 18:59:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2CWW7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:59:52 -0400
Date: Fri, 23 Mar 2012 15:59:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm for fs: add truncate_pagecache_range
Message-Id: <20120323155950.f9bfb097.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1203231406090.2207@eggly.anvils>
References: <alpine.LSU.2.00.1203231343380.1940@eggly.anvils>
	<20120323140120.11f95cd5.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1203231406090.2207@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012 14:14:54 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> On Fri, 23 Mar 2012, Andrew Morton wrote:
> > 
> > --- a/mm/truncate.c~mm-for-fs-add-truncate_pagecache_range-fix
> > +++ a/mm/truncate.c
> > @@ -639,6 +639,9 @@ int vmtruncate_range(struct inode *inode
> >   * with on-disk format, and the filesystem would not have to deal with
> >   * situations such as writepage being called for a page that has already
> >   * had its underlying blocks deallocated.
> > + *
> > + * Must be called with inode->i_mapping->i_mutex held.
> 
> You catch me offguard: I forget whether that's an absolute requirement or
> just commonly the case.  What do the other interfaces in truncate.c say ?-)

i_mutex is generally required, to stabilise i_size.

> > + * Takes inode->i_mapping->i_mmap_mutex.
> 
> Yes, and inode->i_mapping->tree_lock.

I don't think it's necessary to get into the spinning locks for a
high-level function which clearly does sleeping things.


