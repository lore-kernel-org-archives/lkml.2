Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2IFXpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:45:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39702 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab2IFXpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:45:15 -0400
Date: Thu, 6 Sep 2012 16:45:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v10 7/8] block: Consolidate bio_alloc_bioset(),
 bio_kmalloc()
Message-ID: <20120906234510.GB9426@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-8-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346970902-10931-8-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:35:01PM -0700, Kent Overstreet wrote:
> Previously, bio_kmalloc() and bio_alloc_bioset() behaved slightly
> different because there was some almost-duplicated code - this fixes
> some of that.
> 
> The important change is that previously bio_kmalloc() always set
> bi_io_vec = bi_inline_vecs, even if nr_iovecs == 0 - unlike
> bio_alloc_bioset(). This would cause bio_has_data() to return true; I
> don't know if this resulted in any actual bugs but it was certainly
> wrong.
> 
> bio_kmalloc() and bio_alloc_bioset() also have different arbitrary
> limits on nr_iovecs - 1024 (UIO_MAXIOV) for bio_kmalloc(), 256
> (BIO_MAX_PAGES) for bio_alloc_bioset(). This patch doesn't fix that, but
> at least they're enforced closer together and hopefully they will be
> fixed in a later patch.
> 
> This'll also help with some future cleanups - there are a fair number of
> functions that allocate bios (e.g. bio_clone()), and now they don't have
> to be duplicated for bio_alloc(), bio_alloc_bioset(), and bio_kmalloc().
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> v7: Re-add dropped comments, improv patch description

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
