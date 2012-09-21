Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2IUA0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:26:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51349 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2IUA0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:26:00 -0400
Date: Thu, 20 Sep 2012 17:25:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 19/26] bounce: Refactor __blk_queue_bounce to not
 use bi_io_vec
Message-ID: <20120921002555.GV7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-20-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-20-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Mon, Sep 10, 2012 at 05:22:30PM -0700, Kent Overstreet wrote:
> A bunch of what __blk_queue_bounce() was doing was problematic for the
> immutable bvec work; this cleans that up and the code is quite a bit
> smaller, too.
> 
> The __bio_for_each_segment() in copy_to_high_bio_irq() was changed
> because that one's looping over the original bio, not the bounce bio -
> since the bounce code doesn't own that bio the __ version wasn't
> correct.

I do like the new implementation.  I think the function is broken
before and after tho.  Allocating from fs_bio_set from block layer is
never safe and nothing seems to prevent multiple allocators compete in
the bounce page mempool.  This will need a separate bioset and the
multiple mempool allocation would have to be put inside a mutex.

Also, how was this tested?

Thanks.

-- 
tejun
