Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0KCSZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:25:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab0KCSZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:25:28 -0400
Date: Wed, 3 Nov 2010 11:23:14 -0700
From: Greg KH <gregkh@suse.de>
To: Andy Whitcroft <apw@canonical.com>, Dan Carpenter <error27@gmail.com>
Cc: Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: gadget: goku_udc: add registered flag bit
Message-ID: <20101103182314.GA8010@suse.de>
References: <1288807358-11813-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288807358-11813-1-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 06:02:38PM +0000, Andy Whitcroft wrote:
> The commit below cleaned up error handling, in part by introducing a
> registered flag bit.  This however was not added to the device
> structure leding to build failures:
> 
>   commit 319feaabb6c7ccd90da6e3207563c265da7d21ae
>   Author: Dan Carpenter <error27@gmail.com>
>   Date:   Tue Oct 5 18:55:34 2010 +0200
> 
>     usb: gadget: goku_udc: Fix error path
> 
> Add the missing registered flag bit.


Dan, is this patch below the correct fix?  Or should we be looking at
some other flag?

[Andy, please always cc: the original patch author when reporting
problems, to not do so is a bit rude and causes others (i.e. me) extra
work.]

thanks,

greg k-h


> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  drivers/usb/gadget/goku_udc.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/goku_udc.h b/drivers/usb/gadget/goku_udc.h
> index 566cb23..e7e0c69 100644
> --- a/drivers/usb/gadget/goku_udc.h
> +++ b/drivers/usb/gadget/goku_udc.h
> @@ -251,7 +251,8 @@ struct goku_udc {
>  					got_region:1,
>  					req_config:1,
>  					configured:1,
> -					enabled:1;
> +					enabled:1,
> +					registered:1;
>  
>  	/* pci state used to access those endpoints */
>  	struct pci_dev			*pdev;
> -- 
> 1.7.1
