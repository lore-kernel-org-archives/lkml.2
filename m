Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1BUVO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:14:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:51386 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab1BUVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:14:57 -0500
Date: Tue, 22 Feb 2011 08:14:43 +1100
From: NeilBrown <neilb@suse.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix over-zealous flush_disk when changing device size.
Message-ID: <20110222081443.6ec89942@notabene.brown>
In-Reply-To: <x49hbbx18pq.fsf@segfault.boston.devel.redhat.com>
References: <20110217165057.5c50e566@notabene.brown>
	<x49hbbx18pq.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011 14:36:01 -0500 Jeff Moyer <jmoyer@redhat.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > -int __invalidate_device(struct block_device *bdev)
> > +int __invalidate_device2(struct block_device *bdev, bool kill_dirty)
> >  {
> >  	struct super_block *sb = get_super(bdev);
> >  	int res = 0;
> > @@ -1614,7 +1614,7 @@ int __invalidate_device(struct block_device *bdev)
> >  		 * hold).
> >  		 */
> >  		shrink_dcache_sb(sb);
> > -		res = invalidate_inodes(sb);
> > +		res = invalidate_inodes(sb, kill_dirty);
> >  		drop_super(sb);
> >  	}
> >  	invalidate_bdev(bdev);
> 
> Neil, I think you also need to change the EXPORT_SYMBOL from
> __invalidate_device to __invalidate_device2.  The floppy module won't
> build without that change.

Good point, thank.
I've just made this change in mt for-next tree so it should appear in -next
today?

NeilBrown
