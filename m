Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0F1Mi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:38:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab0F1Mi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:38:26 -0400
Date: Mon, 28 Jun 2010 08:37:42 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
 requests
Message-ID: <20100628123742.GB19497@redhat.com>
References: <20100622180029.GA15950@redhat.com>
 <1277582211-10725-2-git-send-email-snitzer@redhat.com>
 <4C2896C6.9030607@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2896C6.9030607@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28 2010 at  8:34am -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 2010-06-26 21:56, Mike Snitzer wrote:
> > Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
> > means bio_has_data() will not be true until the SCSI layer adds the
> > payload to the discard request via blk_add_request_payload.
> 
> Sorry, this looks horrible.

Your judgment isn't giving me much to work with... not sure where I go
with "horrible".

> What is the point of this?!

Enables discard requests with _not_ return true for bio_has_data().

> > bio_{enable,disable}_inline_vecs are not expected to be widely used so
> > they were exported using EXPORT_SYMBOL_GPL.
> 
> Never export anything that doesn't have an in-kernel modular user.

Yeap, v2 removed the exports.

> > This patch avoids the need for the following VM accounting fix for
> > discards: http://lkml.org/lkml/2010/6/23/361
> > NOTE: Jens, you said you applied Tao Ma's fix but I cannot see it in
> > your linux-2.6-block's for-next or for-2.6.36... as such I didn't revert
> > it in this patch.
> 
> It's in the for-linus branch, that is stuff headed for the current
> kernel.

OK.

Mike
