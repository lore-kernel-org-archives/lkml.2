Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1BUTl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:41:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab1BUTl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:41:57 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Patterson <andrew.patterson@hp.com>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing device size.
References: <20110217165057.5c50e566@notabene.brown>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 21 Feb 2011 14:36:01 -0500
In-Reply-To: <20110217165057.5c50e566@notabene.brown> (NeilBrown's message of
	"Thu, 17 Feb 2011 16:50:57 +1100")
Message-ID: <x49hbbx18pq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> -int __invalidate_device(struct block_device *bdev)
> +int __invalidate_device2(struct block_device *bdev, bool kill_dirty)
>  {
>  	struct super_block *sb = get_super(bdev);
>  	int res = 0;
> @@ -1614,7 +1614,7 @@ int __invalidate_device(struct block_device *bdev)
>  		 * hold).
>  		 */
>  		shrink_dcache_sb(sb);
> -		res = invalidate_inodes(sb);
> +		res = invalidate_inodes(sb, kill_dirty);
>  		drop_super(sb);
>  	}
>  	invalidate_bdev(bdev);

Neil, I think you also need to change the EXPORT_SYMBOL from
__invalidate_device to __invalidate_device2.  The floppy module won't
build without that change.

Cheers,
Jeff
