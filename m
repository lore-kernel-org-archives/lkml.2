Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993Ab0DVEAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 00:00:16 -0400
Received: from mail.perches.com ([173.55.12.10]:1667 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab0DVEAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 00:00:14 -0400
Subject: Re: [PATCH] Staging: Comedi: Drivers: Fix coding style issues in
 dt2801.c
From: Joe Perches <joe@perches.com>
To: Gustavo Silva <silvagustavosilva@gmail.com>
Cc: gregkh@suse.de, abbotti@mev.co.uk, devel@driverdev.osuosl.org,
       fmhess@users.sourceforge.net, linux-kernel@vger.kernel.org,
       silvagustavo@users.sourceforge.net
In-Reply-To: <1271907971-8793-1-git-send-email-silvagustavo@users.sourceforge.net>
References: <>
	 <1271907971-8793-1-git-send-email-silvagustavo@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 21:00:11 -0700
Message-ID: <1271908811.1730.613.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 22:46 -0500, Gustavo Silva wrote:
>  drivers/staging/comedi/drivers/dt2801.c |  100 ++++++++++++++-----------------
>  1 files changed, 44 insertions(+), 56 deletions(-)

Hi Gustavo.  A couple of trivial comments.

> diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
> index 3f365ae..c4408d8 100644
> --- a/drivers/staging/comedi/drivers/dt2801.c
> +++ b/drivers/staging/comedi/drivers/dt2801.c
> @@ -102,58 +102,46 @@ COMEDI_INITCLEANUP(driver_dt2801);
>  
>  #if 0

You could just as well remove the #if 0 blocks

> @@ -374,8 +362,8 @@ static int dt2801_writecmd(struct comedi_device *dev, int command)
>  
>  	stat = inb_p(dev->iobase + DT2801_STATUS);
>  	if (stat & DT_S_COMPOSITE_ERROR) {
> -		printk
> -		    ("dt2801: composite-error in dt2801_writecmd(), ignoring\n");
> +		printk(KERN_INFO "dt2801: composite-error in dt2801_writecmd()"
> +								", ignoring\n");

It's good to preface with KERN_, but better might be to use
	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
and strip the "dt2801: " intro and use
	pr_<level>("%s(): composite-error, ignoring\n", __func__)

It's a bit shorter, always gets the appropriate prefix, and
would emit the proper function name if ever refactored.

cheers, Joe

