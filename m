Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2I2WOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 18:14:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55493 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2I2WOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 18:14:48 -0400
Message-ID: <1348956884.7401.3.camel@maxim-laptop>
Subject: Re: [patch 2/2] memstick: memory leak on error in msb_ftl_scan()
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Date: Sun, 30 Sep 2012 00:14:44 +0200
In-Reply-To: <1348956616.7401.2.camel@maxim-laptop>
References: <20120929071138.GC10993@elgon.mountain>
	 <1348956616.7401.2.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-30 at 00:10 +0200, Maxim Levitsky wrote: 
> On Sat, 2012-09-29 at 10:11 +0300, Dan Carpenter wrote: 
> > We need to free "overwrite_flags" before returning.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
> > index a8e8915..1f9d5cf 100644
> > --- a/drivers/memstick/core/ms_block.c
> > +++ b/drivers/memstick/core/ms_block.c
> > @@ -1408,8 +1408,10 @@ static int msb_ftl_scan(struct msb_data *msb)
> >  			msb_mark_block_used(msb, pba);
> >  			msb_erase_block(msb, pba);
> >  			continue;
> > -		} else if (error)
> > +		} else if (error) {
> > +			kfree(overwrite_flags);
> >  			return error;
> > +		}
> >  
> >  		lba = be16_to_cpu(extra.logical_address);
> >  		managment_flag = extra.management_flag;
> 
> Indeed. I need to be more careful with this,
> I'll do another review of the code, maybe I spot anything else.
> 
> Acked-by: Maxim Levitsky <maximlevitsly@gmail.com>
maximlevitsky@gmail.com> :-(




