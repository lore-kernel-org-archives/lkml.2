Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab1ALCwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 21:52:37 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43115 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1ALCwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 21:52:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=alUewooqG3jPvrKAsB8THiAR6tZhqJGYHxxviEy93nE+78Xz+tg+2hz0MtV6TX/huv
         L+D3QObAwkpuSXoEgn50YwGHfs2vlmAor2Nhc+vyXE26imMt7V+I6jS8nui6VMIUHnes
         +pNPEyYijiZP9qAN2c13uWXEdQt1NyzxgprAU=
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Alex Dubov <oakad@yahoo.com>
In-Reply-To: <20110111155803.5638ec4e.rdunlap@xenotime.net>
References: <1294788975-19584-1-git-send-email-maximlevitsky@gmail.com>
	 <1294788975-19584-2-git-send-email-maximlevitsky@gmail.com>
	 <20110111155124.ee61cd7f.rdunlap@xenotime.net>
	 <20110111155511.bcb90254.akpm@linux-foundation.org>
	 <20110111155803.5638ec4e.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 04:52:29 +0200
Message-ID: <1294800749.29447.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 15:58 -0800, Randy Dunlap wrote:
> On Tue, 11 Jan 2011 15:55:11 -0800 Andrew Morton wrote:
> 
> > On Tue, 11 Jan 2011 15:51:24 -0800
> > Randy Dunlap <rdunlap@xenotime.net> wrote:
> > 
> > > >  /**
> > > > + * sg_advance - advance scatterlist by 'consumed' bytes
> > > > + * @sg - the current sg entry
> > > > + * @consumed - how much bytes to advance
> > > 
> > > kernel-doc notation for parameters is like so:
> > 
> > I think I fixed most of this.  Probably missed some though.
> > 
> > Teach checkpatch to check kerneldoc ;)
> > 
> 
> ugh, no thanks.
> 
> > 
> > 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > fix general disaster in code comments
> > 
> > Cc: Alex Dubov <oakad@yahoo.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  lib/scatterlist.c |   31 ++++++++++++++++++-------------
> >  1 file changed, 18 insertions(+), 13 deletions(-)
> > 
> > diff -puN lib/scatterlist.c~scatterlist-new-helper-functions-fix lib/scatterlist.c
> > --- a/lib/scatterlist.c~scatterlist-new-helper-functions-fix
> > +++ a/lib/scatterlist.c
> > @@ -41,7 +41,7 @@ EXPORT_SYMBOL(sg_next);
> >  /**
> >   * sg_advance - advance scatterlist by 'consumed' bytes
> >   * @sg - the current sg entry
> > - * @consumed - how much bytes to advance
> > + * @consumed - how many bytes to advance
> 
>  * @consumed: how many bytes to advance
> 
> >   *
> >   */
> >  struct scatterlist *sg_advance(struct scatterlist *sg, int consumed)
> > @@ -76,8 +76,8 @@ EXPORT_SYMBOL(sg_advance);
> >   * sg_nents - calculate number of sg entries in sg list
> >   * @sg - the current sg entry
> 
>  * @sg:
> 
> >   *
> > - * Allows to calculate dynamicly the lenght of the sg table, based on
> > - * assumption that last entry is NULL
> > + * Allows to calculate aldynamicly the length of the sg table, based on an
> > + * assumption that the last entry is NULL
> >   */
> >  int sg_nents(struct scatterlist *sg)
> >  {
> > @@ -92,11 +92,11 @@ int sg_nents(struct scatterlist *sg)
> >  EXPORT_SYMBOL(sg_nents);
> >  
> >  /**
> > - * sg_total_len - calculate total lenght of scatterlist
> > + * sg_total_len - calculate total length of scatterlist
> >   * @sg - the current sg entry
> 
>  * @sg:
> 
> >   *
> > - * Dynamicly calculate total number of bytes in a sg list
> > - * based on assumption that list ends with a NULL entry
> > + * Dynamically calculate total number of bytes in a sg list
> 
> preferably:
>                                                   in an sg list
> 
> > + * based on an assumption that the list ends with a NULL entry
> >   */
> >  int sg_total_len(struct scatterlist *sg)
> >  {
> > @@ -182,8 +182,14 @@ void sg_init_one(struct scatterlist *sg,
> >  EXPORT_SYMBOL(sg_init_one);
> >  
> >  /**
> > - * sg_copy - copies sg entries from sg_from to sg_to, such
> > - * as sg_to covers first 'len' bytes from sg_from.
> > + * sg_copy - copy sg entries
> > + * @sg_from: source
> > + * @sg_to: destination
> > + *
> > + * Copies from @sg_from to @sg_to.  @sg_to covers first 'len' bytes from
> > + * @sg_from.
> > + *
> > + * Returns zero on success, else a -ve errno.
> >   */
> >  int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len)
> >  {
> > @@ -616,13 +622,12 @@ size_t sg_copy_to_buffer(struct scatterl
> >  }
> >  EXPORT_SYMBOL(sg_copy_to_buffer);
> >  
> > -
> >  /**
> > - * sg_compare_to_buffer - compare contents of the data pointeted by sg table
> > + * sg_compare_to_buffer - compare contents of the data covered by an sg table
> >   * to a kernel ram buffer
> > - * @sg - the current sg entry
> > - * @buffer - linear buffer to compare with
> > - * @len - lenght of that buffer
> > + * @sg: the current sg entry
> > + * @buffer: linear buffer to compare with
> > + * @len: length of that buffer
> 
> Returns what??
0 if equal and 1 otherwise.
Was too lazy to implement full strcmp compliance.
Is that needed?


All very fair comments.
Will check everything once again.
Thanks for a review!

Best regards,
	Maxim Levitsky

