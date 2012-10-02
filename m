Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2JBUQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:16:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2JBUQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:16:24 -0400
Date: Tue, 2 Oct 2012 13:16:20 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk
Subject: Re: [dm-devel] [PATCH v3 09/26] block: Remove bi_idx references
Message-ID: <20121002201620.GM26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-10-git-send-email-koverstreet@google.com>
 <20121002192434.GE3283@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002192434.GE3283@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 03:24:34PM -0400, Vivek Goyal wrote:
> On Mon, Sep 24, 2012 at 03:34:49PM -0700, Kent Overstreet wrote:
> 
> [..]
> > diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> > index 95e52879..24e5cef 100644
> > --- a/drivers/block/floppy.c
> > +++ b/drivers/block/floppy.c
> > @@ -3778,7 +3778,6 @@ static int __floppy_read_block_0(struct block_device *bdev)
> >  	bio_vec.bv_len = size;
> >  	bio_vec.bv_offset = 0;
> >  	bio.bi_vcnt = 1;
> > -	bio.bi_idx = 0;
> 
> So leaving bio.bi_idx uninitialized is safer than setting it to zero? Can
> you explain a bit more that why this change is required? 

It's not uninitialized, because it just called bio_init() - it was
entirely redundant before.

It's not strictly necessary, but immutable bio vecs require getting rid
of a lot of bi_idx usage, and everything that's left is either
unecessary or better/cleaner done some other way, so it's best to just
get rid of all of them - immutable bvecs changes the semantics of bi_idx
just enough that directly using it tends to be wrong.
