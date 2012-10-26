Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab2JZMdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:33:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:49508 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541Ab2JZMdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:33:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208";a="160922814"
Date: Fri, 26 Oct 2012 20:33:21 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
Message-ID: <20121026123321.GG2778@yliu-dev.sh.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1351243827.8719.5.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351243827.8719.5.camel@wall-e>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:30:27AM +0200, Stefani Seibold wrote:
> Am Freitag, den 26.10.2012, 15:56 +0800 schrieb Yuanhan Liu:
> > Say, if we want to allocate a filo with size of 6 bytes, it would be safer
> > to allocate 8 bytes instead of 4 bytes.
> > ----
> > I know it works with rounddown_pow_of_two as well, since size is maintained
> > in the kfifo internal part. But, I'm quite curious why Stefani chose
> > rounddown_pow_of_two. To reduce memory?
> > 
> 
> Yes, exactly, if a user do the wrong thing, than the user will get also
> a wrong result, and did not waste memory.

But, isn't it better to 'correct' it? ;-)

> 
> But anyway, if the majority like this patch it is okay for me.

Sorry, do you mean you are OK with this patch?

Thanks,
Yuanhan Liu
> > 
> > Cc: Stefani Seibold <stefani@seibold.net>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > ---
> >  kernel/kfifo.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/kfifo.c b/kernel/kfifo.c
> > index 59dcf5b..0f78378 100644
> > --- a/kernel/kfifo.c
> > +++ b/kernel/kfifo.c
> > @@ -39,11 +39,11 @@ int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
> >  		size_t esize, gfp_t gfp_mask)
> >  {
> >  	/*
> > -	 * round down to the next power of 2, since our 'let the indices
> > +	 * round up to the next power of 2, since our 'let the indices
> >  	 * wrap' technique works only in this case.
> >  	 */
> >  	if (!is_power_of_2(size))
> > -		size = rounddown_pow_of_two(size);
> > +		size = roundup_pow_of_two(size);
> >  
> >  	fifo->in = 0;
> >  	fifo->out = 0;
> > @@ -84,7 +84,7 @@ int __kfifo_init(struct __kfifo *fifo, void *buffer,
> >  	size /= esize;
> >  
> >  	if (!is_power_of_2(size))
> > -		size = rounddown_pow_of_two(size);
> > +		size = roundup_pow_of_two(size);
> >  
> >  	fifo->in = 0;
> >  	fifo->out = 0;
> 
