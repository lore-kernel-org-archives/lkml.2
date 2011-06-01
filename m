Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab1FARCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:02:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1FARCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=nUH5fUH2zUGwGZURDwJuptDN3ZuY0AMizh2ZW9CyX4r30rHyamdUwHI6nPpKMgtP+P
         d7Qhcw0PC23sNfmVlllw==
Date: Wed, 1 Jun 2011 10:02:32 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 4/14] tmpfs: add shmem_read_mapping_page_gfp
In-Reply-To: <20110601004225.GC4433@infradead.org>
Message-ID: <alpine.LSU.2.00.1106010958390.23468@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils> <alpine.LSU.2.00.1105301739080.5482@sister.anvils> <20110601004225.GC4433@infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Christoph Hellwig wrote:
> > (shmem_read_mapping_page_gfp or shmem_read_cache_page_gfp?  Generally
> > the read_mapping_page functions use the mapping's ->readpage, and the
> > read_cache_page functions use the supplied filler, so I think
> > read_cache_page_gfp was slightly misnamed.)
> 
> What about just shmem_read_page?  It's not using the pagecache, so
> no need for the mapping or cache, and the _gfp really is just a hack
> because the old pagecache APIs didn't allow to pass the gfp flags.
> For a new API there's no need for that.

I am trying to mirror what's already there, and it's conceivable that
we'll find others who want converting from read_mapping_page() to
shmem_read_mapping_page(), so I'd rather keep the similar naming.

The _gfp() thing I'm not very keen on, but can't avoid it for i915.
If anyone else needs something here, it's likely to be without _gfp().

> 
> > +static inline struct page *shmem_read_mapping_page(
> > +				struct address_space *mapping, pgoff_t index)
> > +{
> > +	return shmem_read_mapping_page_gfp(mapping, index,
> > +				mapping_gfp_mask(mapping));
> > +}
> 
> This really shouldn't be in pagemap.h.  For now probably in shmem_fs.h

Okay, I can move it there, if I do the same for those shmem_...()
interfaces currently in linux/mm.h too.

Hugh
