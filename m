Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2HHWZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:25:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51074 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2HHWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:25:21 -0400
Date: Wed, 8 Aug 2012 15:25:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 01/12] block: Generalized bio pool freeing
Message-ID: <20120808222515.GE6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-2-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344290921-25154-2-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:08:30PM -0700, Kent Overstreet wrote:
> @@ -422,7 +409,11 @@ void bio_put(struct bio *bio)
>  	if (atomic_dec_and_test(&bio->bi_cnt)) {
>  		bio_disassociate_task(bio);
>  		bio->bi_next = NULL;
> -		bio->bi_destructor(bio);
> +
> +		if (bio->bi_pool)
> +			bio_free(bio, bio->bi_pool);
> +		else
> +			bio->bi_destructor(bio);

So, this bi_pool overriding caller specified custom bi_destructor is
rather unusual.  I know why it's like that - the patch series is
gradually replacing bi_destructor with bi_pool and removes
bi_destructor eventually, but it would be far better if at least patch
description says why this is unusual like this.

Thanks.

-- 
tejun
