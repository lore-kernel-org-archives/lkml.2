Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2I0EmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:42:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60139 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab2I0EmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:42:11 -0400
Date: Wed, 26 Sep 2012 21:41:37 -0700
From: Kent Overstreet <koverstreet@google.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, vgoyal@redhat.com
Subject: Re: [PATCH v3 05/26] md: Convert md_trim_bio() to use bio_advance()
Message-ID: <20120927044137.GC29160@moria.home.lan>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-6-git-send-email-koverstreet@google.com>
 <20120926103827.4d880cf4@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926103827.4d880cf4@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 10:38:27AM +1000, NeilBrown wrote:
> On Mon, 24 Sep 2012 15:34:45 -0700 Kent Overstreet <koverstreet@google.com>
> wrote:
> 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: NeilBrown <neilb@suse.de>
> > ---
> >  drivers/md/md.c | 19 +++++--------------
> >  1 file changed, 5 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 7a2b079..51ce48c 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -190,25 +190,16 @@ void md_trim_bio(struct bio *bio, int offset, int size)
> >  	struct bio_vec *bvec;
> >  	int sofar = 0;
> >  
> > -	size <<= 9;
> >  	if (offset == 0 && size == bio->bi_size)
> >  		return;
> 
> Safer to leave the "size <<= 9" where it is, otherwise that condition will
> always fail.

Whoops, moving that certainly didn't make sense. Thanks!
