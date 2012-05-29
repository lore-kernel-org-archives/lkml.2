Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2E2CPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 22:15:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51874 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2E2CPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 22:15:19 -0400
Date: Mon, 28 May 2012 22:15:15 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v3 07/16] block: Rename bio_split() -> bio_pair_split()
Message-ID: <20120529021515.GB6472@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-8-git-send-email-koverstreet@google.com>
 <4FC3504B.7000903@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC3504B.7000903@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 01:15:39PM +0300, Boaz Harrosh wrote:
> On 05/25/2012 11:25 PM, Kent Overstreet wrote:
> 
> > This is prep work for introducing a more general bio_split()
> > 
> > Change-Id: Ib9c4ff691af889d26bc9ec9fb42a2f3068f34ad9
> > 
> 
> 
> Since these patches will go through Jens tree this kind of
> comment can *never* be true/correct. And it is plenty unwanted
> for sure.

That's from a gerrit hook, which I always forget to delete so I just
disabled the hook on my work machine. Apologies.

> Here:
> bio_do means an operation on bio. But here we are actually operating
> on a bio_pair. So rename it it to bio_pair_do.

I don't follow what you mean by bio_do... but I think I get what you're
after, comment wise.

> 
> We will later introduce a real bio_split() function that receives
> a bio and splits it.
> 
> Or something like that.
> Thanks
> Boaz
> 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> <snip>
> 
> > @@ -201,7 +201,7 @@ struct bio_pair {
> >  	atomic_t			cnt;
> >  	int				error;
> >  };
> > -extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
> > +extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
> >  extern void bio_pair_release(struct bio_pair *dbio);
> >  
> >  extern struct bio_set *bioset_create(unsigned int, unsigned int);
> 
> 
