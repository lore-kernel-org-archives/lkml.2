Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0F1PQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:16:46 -0400
Received: from sh.osrg.net ([192.16.179.4]:42986 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab0F1PQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:16:43 -0400
Date: Tue, 29 Jun 2010 00:15:20 +0900
To: snitzer@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, hch@lst.de, axboe@kernel.dk,
       dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
 requests
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100628122955.GA19497@redhat.com>
References: <1277582211-10725-2-git-send-email-snitzer@redhat.com>
	<20100628193122L.fujita.tomonori@lab.ntt.co.jp>
	<20100628122955.GA19497@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100629001245C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 29 Jun 2010 00:15:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 08:29:55 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Jun 28 2010 at  6:33am -0400,
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Sat, 26 Jun 2010 15:56:51 -0400
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
> > > means bio_has_data() will not be true until the SCSI layer adds the
> > > payload to the discard request via blk_add_request_payload.
> > > 
> > > bio_{enable,disable}_inline_vecs are not expected to be widely used so
> > > they were exported using EXPORT_SYMBOL_GPL.
> > > 
> > > This patch avoids the need for the following VM accounting fix for
> > > discards: http://lkml.org/lkml/2010/6/23/361
> > 
> > Why do we need to avoid the above fix?
> 
> We don't _need_ to.  We avoid the need for it as a side-effect of the
> cleanup that my patch provides.
> 
> > Surely, the above fix is hacky but much simpler than this patch.
> 
> My patch wasn't meant as an alternative to Tao Ma's patch.  Again, it
> just obviates the need for it.
> 
> Your tolerance for "hacky" is difficult to understand.  On the one-hand
> (PATCH 1/2) you have no tolerance for "hacky" fixes for leaks (that
> introduce a short-term SCSI layering violation).

Sorry, if not clear enough.

- SCSI layering violation is bad.

- A 'short term' solution always turns out to be a long solution. We
  should have a clean solution from the start.

- Complicating the SCSI I/O completion is bad (already complicated
 enough).

...

And the 'leaks' bug is still in -next. No need to fix it in a hacky
way. We can just drop it from -next.


> But in this case
> you're perfectly fine with BIO_RW_DISCARD special casing?

BIO_RW_DISCARD special is already everywhere in the block layer. I
prefer to have the less. However as long as it's in the block layer, I
can live with it. After all, that's the block layer thing.

At least, it looks much better this patch. This patch is really hacky
(as Jens said).
