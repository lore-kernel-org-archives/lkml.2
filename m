Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab2BIXGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:06:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab2BIXGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:06:53 -0500
Date: Thu, 9 Feb 2012 15:06:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Xi Wang <xi.wang@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Message-Id: <20120209150652.5b1d19dc.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
References: <20120207141155.GA16184@elgon.mountain>
	<4F323388.7040902@kernel.dk>
	<20120208142513.4db2493a.akpm@linux-foundation.org>
	<4F33BF05.208@gmail.com>
	<CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
	<4F33C7D7.1060801@kernel.dk>
	<32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
	<4F33CEAE.60400@gmail.com>
	<alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012 23:47:42 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> > -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> > +static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
> >  {
> >  	if (size != 0 && n > ULONG_MAX / size)
> >  		return NULL;
> > -	return __kmalloc(n * size, flags | __GFP_ZERO);
> > +	return __kmalloc(n * size, flags);
> > +}
> > +
> > +/**
> > + * kcalloc - allocate memory for an array. The memory is set to zero.
> > + * @n: number of elements.
> > + * @size: element size.
> > + * @flags: the type of memory to allocate (see kmalloc).
> > + */
> > +static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> > +{
> > +	return kmalloc_array(n, size, flags | __GFP_ZERO);
> >  }
> >  
> >  #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
> > 
> 
> Does this want adding to Documentation/CodingStyle "Chapter 14: Allocating 
> memory" ?

Spose so.  We could possibly cook up a checkpatch rule too ;)

<gad, CodingStyle has 18 chapters and an appendix??>

