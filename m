Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2I0BvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:51:24 -0400
Received: from [156.147.1.151] ([156.147.1.151]:60953 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2I0BvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:51:23 -0400
X-AuditID: 9c930197-b7b6dae000000e70-2c-5063b0f5e860
Date: Thu, 27 Sep 2012 10:53:59 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Calvin Walton <calvin.walton@kepstin.ca>, Jens Axboe <axboe@kernel.dk>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] zram: select ZSMALLOC when ZRAM is configured
Message-ID: <20120927015359.GD10229@bbox>
References: <1348649419-16494-1-git-send-email-minchan@kernel.org>
 <1348649419-16494-4-git-send-email-minchan@kernel.org>
 <20120926161539.GA30132@kroah.com>
 <1348676615.2552.5.camel@ayu>
 <20120926162941.GA29694@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926162941.GA29694@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 09:29:41AM -0700, Greg Kroah-Hartman wrote:
> On Wed, Sep 26, 2012 at 12:23:35PM -0400, Calvin Walton wrote:
> > On Wed, 2012-09-26 at 09:15 -0700, Greg Kroah-Hartman wrote:
> > > On Wed, Sep 26, 2012 at 05:50:19PM +0900, Minchan Kim wrote:
> > > > At the monent, we can configure zram in driver/block once zsmalloc
> > > > in /lib menu is configured firstly. It's not convenient.
> > > > 
> > > > User can configure zram in driver/block regardless of zsmalloc enabling
> > > > by this patch.
> > > > 
> > > > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > > ---
> > > >  drivers/block/zram/Kconfig |    3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
> > > > index be5abe8..ee23a86 100644
> > > > --- a/drivers/block/zram/Kconfig
> > > > +++ b/drivers/block/zram/Kconfig
> > > > @@ -1,6 +1,7 @@
> > > >  config ZRAM
> > > >  	tristate "Compressed RAM block device support"
> > > > -	depends on BLOCK && SYSFS && ZSMALLOC
> > > > +	depends on BLOCK && SYSFS
> > > > +	select ZSMALLOC
> > > 
> > > As ZSMALLOC is dependant on CONFIG_STAGING, this isn't going to work at
> > > all, sorry.
> > 
> > Perhaps you missed [PATCH 1/3] zsmalloc: promote to lib/ ? The first
> > patch in this series moves zsmalloc out of the staging directory, and
> > removes the dependency on CONFIG_STAGING.
> 
> Ah, I did, thanks.
> 
> For 3.7, it's too late to be moving stuff out of staging to the "real"
> part of the kernel as 3.6 is about to be released.
> 
> Possibly, if everyone agrees with this, after 3.7 is out we can do this
> for 3.8, ok?

For me, no problem.
I will send the patchset after listening akpm's opinion about zsmalloc's
location. Maybe nextweek.

Thanks, Greg.

> 
> thanks,
> 
> greg k-h
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
