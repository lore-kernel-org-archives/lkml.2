Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824Ab0J0PnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:43:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60389 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760749Ab0J0PnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pJj7KGQPIQRM9vcm0p+PaEXr2HfeWqOOSaJ3iMYhOxK1xcRGBrR+P30V2xHNRy0hN7
         p5Dv1oNvujjI5WGVu6EkpObdt7s6rPATbkfsl75b4yeTZbU1Xy3qGrQfpia8JfA8SM+I
         O+3pImnaBhNu7AJfbN06T2phFGYZDQ6lZ5jaI=
Date: Wed, 27 Oct 2010 19:43:12 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] block: cciss: fix information leak to userland
Message-ID: <20101027154312.GA9008@albatros>
References: <1287822311-14783-1-git-send-email-segooon@gmail.com>
 <0F5B06BAB751E047AB5C87D1F77A77887D0E2807DF@GVW0547EXC.americas.hpqcorp.net>
 <0F5B06BAB751E047AB5C87D1F77A77887D0E280943@GVW0547EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77887D0E280943@GVW0547EXC.americas.hpqcorp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Oct 25, 2010 at 16:36 +0000, Miller, Mike (OS Dev) wrote:
> 
> 
> > -----Original Message-----
> > From: Miller, Mike (OS Dev)
> > Sent: Monday, October 25, 2010 9:41 AM
> > To: Vasiliy Kulikov; kernel-janitors@vger.kernel.org
> > Cc: Jens Axboe; Stephen M. Cameron; Andrew Morton; ISS StorageDev;
> > linux-kernel@vger.kernel.org
> > Subject: RE: [PATCH 1/2] block: cciss: fix information leak to userland
> > 
> > 
> > 
> > > -----Original Message-----
> > > From: Vasiliy Kulikov [mailto:segooon@gmail.com]
> > > Sent: Saturday, October 23, 2010 3:25 AM
> > > To: kernel-janitors@vger.kernel.org
> > > Cc: Miller, Mike (OS Dev); Jens Axboe; Stephen M. Cameron;
> > > Andrew Morton; ISS StorageDev; linux-kernel@vger.kernel.org
> > > Subject: [PATCH 1/2] block: cciss: fix information leak to userland
> > >
> > > Structure IOCTL_Command_struct is copied to userland with
> > > some padding fields at the end of the struct unitialized.
> > > It leads to leaking of stack memory.
> > >
> > > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > > ---
> > >  drivers/block/cciss.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > > index 762a81a..cd08324 100644
> > > --- a/drivers/block/cciss.c
> > > +++ b/drivers/block/cciss.c
> > > @@ -1142,6 +1142,7 @@ static int
> > > cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
> > >  	int err;
> > >  	u32 cp;
> > >
> > > +	memset(&arg64, 0, sizeof(arg64));
> > >  	err = 0;
> > >  	err |=
> > >  	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
> > > --
> > 
> > Acked-by: Mike Miller <mike.miller@hp.com>
> 
> BTW: this change needs to go into the cciss_ioctl32_big_passthru

I've sent the patch, thanks.

> and the other passthru ioctls, also.

I don't see problems with them, they do copy_from_user() before
filling the structure.

> 
> -- mikem
> 
> > 
> > > 1.7.0.4
> > >
> > >

Thanks,

-- 
Vasiliy
