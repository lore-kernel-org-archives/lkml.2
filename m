Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab2HHXaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:30:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2HHXaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:30:12 -0400
Date: Wed, 8 Aug 2012 16:30:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 12/12] block: Only clone bio vecs that are in use
Message-ID: <20120808233007.GM6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-13-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344290921-25154-13-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 06, 2012 at 03:08:41PM -0700, Kent Overstreet wrote:
> @@ -459,10 +460,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
>  	bio->bi_sector = bio_src->bi_sector;
>  	bio->bi_bdev = bio_src->bi_bdev;
>  	bio->bi_flags |= 1 << BIO_CLONED;
> +	bio->bi_flags &= ~(1 << BIO_SEG_VALID);

This isn't obvious at all.  Why no explanation anywhere?  Also it
would be nice to update comments of the updated functions so that it's
clear that only partial cloning happens.

Thanks.

-- 
tejun
