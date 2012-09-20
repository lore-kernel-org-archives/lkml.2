Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2ITXcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:32:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50879 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab2ITXca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:32:30 -0400
Date: Thu, 20 Sep 2012 16:32:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 05/26] block: Add bio_end()
Message-ID: <20120920233225.GK7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-6-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-6-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:22:16PM -0700, Kent Overstreet wrote:
> Just a little convenience macro - main reason to add it now is preparing
> for immutable bio vecs, it'll reduce the size of the patch that puts
> bi_sector/bi_size/bi_idx into a struct bvec_iter.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 6763cdf..92bff0e 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -67,6 +67,7 @@
>  #define bio_offset(bio)		bio_iovec((bio))->bv_offset
>  #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
>  #define bio_sectors(bio)	((bio)->bi_size >> 9)
> +#define bio_end(bio)		((bio)->bi_sector + bio_sectors(bio))

Maybe bio_end_sector() is a better name?  bio_end() looks a bit too
close to bio_endio().

Thanks.

-- 
tejun
