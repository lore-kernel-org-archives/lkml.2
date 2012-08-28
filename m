Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2H1WHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:07:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48886 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab2H1WHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:07:45 -0400
Date: Tue, 28 Aug 2012 15:07:11 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 5/9] block: Kill bi_destructor
Message-ID: <20120828220711.GC1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-6-git-send-email-koverstreet@google.com>
 <20120828203613.GD24608@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828203613.GD24608@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:36:13PM -0700, Tejun Heo wrote:
> On Tue, Aug 28, 2012 at 10:37:32AM -0700, Kent Overstreet wrote:
> > @@ -385,7 +386,7 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
> >  	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
> >  	bio->bi_max_vecs = nr_iovecs;
> >  	bio->bi_io_vec = bio->bi_inline_vecs;
> > -	bio->bi_destructor = bio_kmalloc_destructor;
> > +	bio->bi_pool = NULL;
> 
> Doesn't bio_init() already memset the whole thing?

Yes it does, holdover from BIO_KMALLOC_POOL. Dropping it.
