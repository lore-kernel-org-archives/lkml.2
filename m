Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2IUAMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:12:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36404 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2IUAMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:12:51 -0400
Date: Thu, 20 Sep 2012 17:06:08 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 10/26] block: Add submit_bio_wait(), remove from md
Message-ID: <20120921000608.GJ5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-11-git-send-email-koverstreet@google.com>
 <20120920235643.GQ7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920235643.GQ7264@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 04:56:43PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 05:22:21PM -0700, Kent Overstreet wrote:
> > Random cleanup - this code was duplicated and it's not really specific
> > to md.
> > 
> > Also added the ability to return the actual error code.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: NeilBrown <neilb@suse.de>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> > --- a/include/linux/bio.h
> > +++ b/include/linux/bio.h
> > @@ -249,6 +249,7 @@ extern void bio_endio(struct bio *, int);
> >  struct request_queue;
> >  extern int bio_phys_segments(struct request_queue *, struct bio *);
> >  
> > +extern int submit_bio_wait(int rw, struct bio *bio);
> >  void bio_advance(struct bio *, unsigned);
> 
> Heh, this is one of the reasons why I don't like extern on function
> prototypes.  It's not necessary and people end up jumping between the
> two forms.  :(

Yeah, I dislike it too but I was trying to follow the style in that file
- I did fix bio_advance() a few minutes ago.
