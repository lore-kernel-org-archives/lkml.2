Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab1FAAn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:43:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60552
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758521Ab1FAAn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:43:26 -0400
Date: Tue, 31 May 2011 20:43:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/14] drm/i915: adjust to new truncate_range
Message-ID: <20110601004314.GD4433@infradead.org>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
 <alpine.LSU.2.00.1105301743500.5482@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1105301743500.5482@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	/* Our goal here is to return as much of the memory as
>  	 * is possible back to the system as we are called from OOM.
>  	 * To do this we must instruct the shmfs to drop all of its
> -	 * backing pages, *now*. Here we mirror the actions taken
> -	 * when by shmem_delete_inode() to release the backing store.
> +	 * backing pages, *now*.
>  	 */
>  	inode = obj->base.filp->f_path.dentry->d_inode;
> -	truncate_inode_pages(inode->i_mapping, 0);
>  	if (inode->i_op->truncate_range)
>  		inode->i_op->truncate_range(inode, 0, (loff_t)-1);
> +	else
> +		truncate_inode_pages(inode->i_mapping, 0);

Given that it relies on beeing on shmemfs it should just call it
directly.
