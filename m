Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2CWVP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 17:15:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58314 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2CWVP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 17:15:26 -0400
Date: Fri, 23 Mar 2012 14:14:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm for fs: add truncate_pagecache_range
In-Reply-To: <20120323140120.11f95cd5.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1203231406090.2207@eggly.anvils>
References: <alpine.LSU.2.00.1203231343380.1940@eggly.anvils> <20120323140120.11f95cd5.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012, Andrew Morton wrote:
> 
> --- a/mm/truncate.c~mm-for-fs-add-truncate_pagecache_range-fix
> +++ a/mm/truncate.c
> @@ -639,6 +639,9 @@ int vmtruncate_range(struct inode *inode
>   * with on-disk format, and the filesystem would not have to deal with
>   * situations such as writepage being called for a page that has already
>   * had its underlying blocks deallocated.
> + *
> + * Must be called with inode->i_mapping->i_mutex held.

You catch me offguard: I forget whether that's an absolute requirement or
just commonly the case.  What do the other interfaces in truncate.c say ?-)

> + * Takes inode->i_mapping->i_mmap_mutex.

Yes, and inode->i_mapping->tree_lock.

>   */
>  void truncate_pagecache_range(struct inode *inode, loff_t lstart, loff_t lend)
>  {
> 
> yes?

Probably!

Hugh
