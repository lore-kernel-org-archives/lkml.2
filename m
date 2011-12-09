Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab1LIAFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:05:04 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50241 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836Ab1LIAE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:04:59 -0500
X-Sasl-enc: sIH3l7VwGBMobgarVwmc6EiUkgEjljiEFnEwCHMoXDfB 1323389098
Date: Thu, 8 Dec 2011 16:00:48 -0800
From: Greg KH <greg@kroah.com>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/30] Staging: comedi: fix printk issue in daqboard2000.c
Message-ID: <20111209000048.GA31036@kroah.com>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
 <1323348745-31477-3-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323348745-31477-3-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 06:21:58PM +0530, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the daqboard2000.c file that fixes up a
> printk warning found by the checkpatch.pl tool.
> 
> Converted printks to pr_<levels>.
> 
> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---
>  drivers/staging/comedi/drivers/daqboard2000.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
> index a16060e..265c650 100644
> --- a/drivers/staging/comedi/drivers/daqboard2000.c
> +++ b/drivers/staging/comedi/drivers/daqboard2000.c
> @@ -502,7 +502,7 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
>  
>  static void daqboard2000_resetLocalBus(struct comedi_device *dev)
>  {
> -	printk("daqboard2000_resetLocalBus\n");
> +	pr_debug("daqboard2000_resetLocalBus\n");

What's wrong with dev_dbg()?  Please use the dev_* functions wherever
possible, like here and in all of the other printk patches you sent.

thanks,

greg k-h
