Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1HBLxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:53:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46634 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1HBLwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:52:54 -0400
Date: Tue, 2 Aug 2011 13:52:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Andrea Righi <arighi@develer.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] kernel/kfifo.c: trivial: use BUG_ON
In-Reply-To: <20110802113335.GA4185@thinkpad>
Message-ID: <Pine.LNX.4.64.1108021349330.24349@ask.diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
 <1312281304-11847-2-git-send-email-julia@diku.dk> <20110802113335.GA4185@thinkpad>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, Andrea Righi wrote:

> On Tue, Aug 02, 2011 at 12:34:54PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Use BUG_ON(x) rather than if(x) BUG();
> > 
> > The semantic patch that fixes this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @@ identifier x; @@
> > -if (x) BUG();
> > +BUG_ON(x);
> > 
> > @@ identifier x; @@
> > -if (!x) BUG();
> > +BUG_ON(!x);
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> 
> The patch looks good. However, I think we should just get rid of the
> BUG_ON() there. If nents is 0, setup_sgl_buf() would just returns 0 and
> nothing critical will happen.

I don't know the code at all.  Indeed, I'm not sure to see any uses of eg 
__kfifo_dma_in_prepare_r, except in demo code.  But that would imply 
returning 0 for two different reasons: asking for nothing and being out of 
space.

julia

> Also consider that in __kfifo_dma_in_prepare(), the equivalent of
> __kfifo_dma_in_prepare_r() when recsize is 0, we don't check nents at
> all.
> 
> -Andrea
> 
> > ---
> >  kernel/kfifo.c |    6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff -u -p a/kernel/kfifo.c b/kernel/kfifo.c
> > --- a/kernel/kfifo.c
> > +++ b/kernel/kfifo.c
> > @@ -562,8 +562,7 @@ EXPORT_SYMBOL(__kfifo_to_user_r);
> >  unsigned int __kfifo_dma_in_prepare_r(struct __kfifo *fifo,
> >  	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
> >  {
> > -	if (!nents)
> > -		BUG();
> > +	BUG_ON(!nents);
> >  
> >  	len = __kfifo_max_r(len, recsize);
> >  
> > @@ -586,8 +585,7 @@ EXPORT_SYMBOL(__kfifo_dma_in_finish_r);
> >  unsigned int __kfifo_dma_out_prepare_r(struct __kfifo *fifo,
> >  	struct scatterlist *sgl, int nents, unsigned int len, size_t recsize)
> >  {
> > -	if (!nents)
> > -		BUG();
> > +	BUG_ON(!nents);
> >  
> >  	len = __kfifo_max_r(len, recsize);
> >  
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
