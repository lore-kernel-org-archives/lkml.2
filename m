Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2ITXrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:47:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55250 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2ITXrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:47:17 -0400
Date: Thu, 20 Sep 2012 16:47:14 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 06/26] block: Use bio_sectors() more consistently
Message-ID: <20120920234713.GF5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-7-git-send-email-koverstreet@google.com>
 <20120920233618.GL7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920233618.GL7264@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 04:36:18PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 05:22:17PM -0700, Kent Overstreet wrote:
> > diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
> > index 321de7b..6e4420a 100644
> > --- a/drivers/block/aoe/aoeblk.c
> > +++ b/drivers/block/aoe/aoeblk.c
> > @@ -199,7 +199,7 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
> >  	buf->bio = bio;
> >  	buf->resid = bio->bi_size;
> >  	buf->sector = bio->bi_sector;
> > -	buf->bv = &bio->bi_io_vec[bio->bi_idx];
> > +	buf->bv = bio_iovec(bio);
> 
> Contamination?

Whoops, yes.

> Also, in general, please cc at least the maintainers of the files that
> you modify.

Meant to ask you about these patches that basically just rename things -
will do.
