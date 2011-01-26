Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1AZRxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:53:06 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45687 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1AZRxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:53:04 -0500
Date: Wed, 26 Jan 2011 11:52:58 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] zram: mark the disk as non-rotating media
Message-ID: <20110126175258.GJ8446@linux.vnet.ibm.com>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126172743.GI8446@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Carpenter (error27@gmail.com) wrote:
> On Wed, Jan 26, 2011 at 11:27:44AM -0600, Robert Jennings wrote:
> > Adding QUEUE_FLAG_NONROT for the in the request_queue flags.  When used
>                            ^^^^^^^^^^^^^^
> "to the" perhaps?

Yeah, that was edited a few times and never re-read.  Thanks.

> > as a swap device, scan_swap_map will avoid the extra work of optimizing
> > for rotating media.
> > 
> > Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> > ---
> >  drivers/staging/zram/zram_drv.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> > index d5e0275..450c618 100644
> > --- a/drivers/staging/zram/zram_drv.c
> > +++ b/drivers/staging/zram/zram_drv.c
> > @@ -593,6 +593,7 @@ static int create_device(struct zram *zram, int device_id)
> >  		goto out;
> >  	}
> >  
> > +	zram->queue->queue_flags ^= QUEUE_FLAG_NONROT;
> 
> QUEUE_FLAG_NONROT is 14.  We want to set the 14 bit.  This won't work.
> 
> Use queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->queue);

I'll correct this.  Thank you.

-Rob Jennings
