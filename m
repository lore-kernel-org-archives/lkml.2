Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2IUArR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:47:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58329 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab2IUArP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:47:15 -0400
Date: Thu, 20 Sep 2012 17:47:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 22/26] block: Add bio_alloc_pages()
Message-ID: <20120921004711.GZ7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-23-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-23-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:22:33PM -0700, Kent Overstreet wrote:
> +	bio_for_each_segment_all(bv, bio, i) {
> +		bv->bv_page = alloc_page(gfp_mask);
> +		if (!bv->bv_page) {
> +			while (bv-- != bio->bi_io_vec)
> +				__free_page(bv->bv_page);

I don't know.  I feel stupid.  I think it's because the loop variable
changes between loop condition test and actual body of loop.  How
about the following?  It is pointing to the member of the same array
so I think it's not even violating pointer comparison rules.

	while (--bv >= bio->bi_io_vec)
		__free_page(bv->bv_page);

-- 
tejun
