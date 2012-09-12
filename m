Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2ILXUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:20:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33912 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2ILXUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:20:23 -0400
Date: Wed, 12 Sep 2012 16:20:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Joseph Glanville <joseph.glanville@orionvm.com.au>
Cc: NeilBrown <neilb@suse.de>, Kent Overstreet <koverstreet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Vivek Goyal <vgoyal@redhat.com>, drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Message-ID: <20120912232019.GW7677@google.com>
References: <20120905100724.GA27527@soda.linbit>
 <20120906212952.GP29092@google.com>
 <20120907084221.GD7028@soda.linbit>
 <20120910225442.GE7677@google.com>
 <20120910230654.GF7677@google.com>
 <20120910233159.GE19739@google.com>
 <20120911155820.74f1f918@notabene.brown>
 <20120911082501.GH7028@soda.linbit>
 <20120912185824.GS7677@google.com>
 <CAOzFzEjCf7ZPbheq-tfhts-E=Ep1kvn0muksaaTFqJ=cMm772w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzFzEjCf7ZPbheq-tfhts-E=Ep1kvn0muksaaTFqJ=cMm772w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 09:12:25AM +1000, Joseph Glanville wrote:
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4b4dbdf..68b5671 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1809,6 +1809,9 @@ EXPORT_SYMBOL(generic_make_request);
>   * uses that function to do most of the work. Both are fairly rough
>   * interfaces; @bio must be presetup and ready for I/O.
>   *
> + * Ordering of requests is not guaranteed, callers should drain the queue
> + * and issue a flush before submission of any dependent bios.

I think using "requests" here is confusing given that struct request
means something else in the block layer.  Also, the caller doesn't
have to drain the whole queue but just the ones involved in the
dependency and flush doesn't really matter here although mentioning
that flush too doesn't have any ordering guarantee would be nice.
Also, updating submit_bio() comment too would be nice - something
simple about lack of ordering and then reference to
generic_make_request().

Thanks.

-- 
tejun
