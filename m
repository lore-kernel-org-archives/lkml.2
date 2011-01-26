Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1AZS15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:27:57 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44962 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1AZS14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:27:56 -0500
Date: Wed, 26 Jan 2011 12:27:47 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] zram/xvmalloc: wrap debug code in #ifdef DEBUG
Message-ID: <20110126182746.GB17383@linux.vnet.ibm.com>
Mail-Followup-To: Pekka Enberg <penberg@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110126172148.GB8446@linux.vnet.ibm.com>
 <20110126172605.GG8446@linux.vnet.ibm.com>
 <AANLkTi=w2Mq102MM=57y6P=YWQ_iUX5rx7oLaabGkCPj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTi=w2Mq102MM=57y6P=YWQ_iUX5rx7oLaabGkCPj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@kernel.org) wrote:
> On Wed, Jan 26, 2011 at 7:26 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> > This wraps the code, noted by comments as being debug code, with
> > #ifdef DEBUG so that it is removed from running in non-debug kernels.
> >
> > Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> > ---
> >  drivers/staging/zram/xvmalloc.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
> > index b3622f1..172514e 100644
> > --- a/drivers/staging/zram/xvmalloc.c
> > +++ b/drivers/staging/zram/xvmalloc.c
> > @@ -219,7 +219,6 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
> >  static void remove_block_head(struct xv_pool *pool,
> >                        struct block_header *block, u32 slindex)
> >  {
> > -       struct block_header *tmpblock;
> >        u32 flindex = slindex / BITS_PER_LONG;
> >
> >        pool->freelist[slindex].page = block->link.next_page;
> > @@ -232,6 +231,8 @@ static void remove_block_head(struct xv_pool *pool,
> >                if (!pool->slbitmap[flindex])
> >                        __clear_bit(flindex, &pool->flbitmap);
> >        } else {
> > +#ifdef DEBUG
> 
> Shouldn't that be something people can enable from Kconfig?

It should be, I'll correct this and re-post.

