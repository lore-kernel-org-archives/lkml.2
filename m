Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0IEGfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:35:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0IEGfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:35:00 -0400
Date: Sat, 4 Sep 2010 23:23:53 -0700
From: Greg KH <gregkh@suse.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Huang Weiyi <weiyi.huang@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: xgifb: Fix compile warning
Message-ID: <20100905062353.GA18329@suse.de>
References: <1283641607.9641.4.camel@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283641607.9641.4.camel@lenovo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 07:06:47PM -0400, Javier Martinez Canillas wrote:
> Hello, In today linux-next I got a some compile warnings with the staging/xgifb driver. This is the first of a 4 patchset that fix all the issues.
> 
> The patches are:
> 
> [PATCH 1/4] staging: xgifb: Fix compile warning
> [PATCH 2/4] staging: xgifb: Add compilation conditionals
> [PATCH 3/4] staging: xgifb: Removes unused variable
> [PATCH 4/4] staging: xgifb: Init uninitialized variables and fix some style issues
> 
> Thanks a lot.
> 
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
>  drivers/staging/xgifb/XGI_main_26.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
> index 7cd3e95..3c80191 100644
> --- a/drivers/staging/xgifb/XGI_main_26.c
> +++ b/drivers/staging/xgifb/XGI_main_26.c
> @@ -3418,7 +3418,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
>  		XGIfb_registered = 1;
>  
>  		printk(KERN_INFO "XGIfb: Installed XGIFB_GET_INFO ioctl (%lx)\n",
> -		       XGIFB_GET_INFO);
> +		       (unsigned long)XGIFB_GET_INFO);

No, you should use %p instead.

Also, you don't spam the kernel log for assigning an ioctl function
pointer, that's just looney...

thanks,

greg k-h
