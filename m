Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2IUAii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:38:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62628 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2IUAig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:38:36 -0400
Date: Thu, 20 Sep 2012 17:38:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 21/26] block: Convert some code to
 bio_for_each_segment_all()
Message-ID: <20120921003832.GY7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-22-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-22-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:22:32PM -0700, Kent Overstreet wrote:
> A few places in the code were either open coding or using the wrong
> version - fix.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: NeilBrown <neilb@suse.de>
> ---
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -921,7 +921,7 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
>  	if (unlikely(!bvecs))
>  		return;
>  
> -	bio_for_each_segment(bvec, bio, i) {
> +	bio_for_each_segment_all(bvec, bio, i) {

I don't get this conversion.  Why is this necessary?

-- 
tejun
