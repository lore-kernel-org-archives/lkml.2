Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab1FAAm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:42:29 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60478
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758469Ab1FAAm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:42:28 -0400
Date: Tue, 31 May 2011 20:42:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 4/14] tmpfs: add shmem_read_mapping_page_gfp
Message-ID: <20110601004225.GC4433@infradead.org>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
 <alpine.LSU.2.00.1105301739080.5482@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1105301739080.5482@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (shmem_read_mapping_page_gfp or shmem_read_cache_page_gfp?  Generally
> the read_mapping_page functions use the mapping's ->readpage, and the
> read_cache_page functions use the supplied filler, so I think
> read_cache_page_gfp was slightly misnamed.)

What about just shmem_read_page?  It's not using the pagecache, so
no need for the mapping or cache, and the _gfp really is just a hack
because the old pagecache APIs didn't allow to pass the gfp flags.
For a new API there's no need for that.

> +static inline struct page *shmem_read_mapping_page(
> +				struct address_space *mapping, pgoff_t index)
> +{
> +	return shmem_read_mapping_page_gfp(mapping, index,
> +				mapping_gfp_mask(mapping));
> +}

This really shouldn't be in pagemap.h.  For now probably in shmem_fs.h

