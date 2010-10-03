Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0JCQVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 12:21:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34359 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0JCQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 12:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=D5BFluNEBjJkQkfzYYHoG3iaPHQaWRwVayeIjRtgBxxjtBNQAqogSN5LWTslLmWwJI
         rL70GG1TbKOz6QzKsNq5hVpKIaUhETsWAgUSmY3m7oNHCN9U5Paf0ZLpYMf7I+shdJAs
         mVKdNsmJ+RMuwfPf0finFZE8mnyGzahDnRNDI=
Date: Sun, 3 Oct 2010 18:17:01 +0200
From: Dan Carpenter <error27@gmail.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, nm127@freemail.hu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: goku_udc: Fix error path
Message-ID: <20101003161700.GA5646@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Rahul Ruikar <rahul.ruikar@gmail.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Greg Kroah-Hartman <gregkh@suse.de>, nm127@freemail.hu,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1286115016-2759-1-git-send-email-rahul.ruikar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286115016-2759-1-git-send-email-rahul.ruikar@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 07:40:16PM +0530, Rahul Ruikar wrote:
> call put_device() when device_register() fails.
> 

Huh?  I don't see any calls to put_device() in your patch.

regards,
dan carpenter


> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/usb/gadget/goku_udc.c |    7 ++++++-
>  drivers/usb/gadget/goku_udc.h |    3 ++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
> index 1088d08..080779b 100644
> --- a/drivers/usb/gadget/goku_udc.c
> +++ b/drivers/usb/gadget/goku_udc.c
> @@ -1847,8 +1847,13 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	/* done */
>  	the_controller = dev;
>  	retval = device_register(&dev->gadget.dev);
> -	if (retval == 0)
> +	if (retval != 0) {
> +		dev_reg_status = 2;
> +		goto done;
> +	} else {
> +		dev_reg_status = 1;
>  		return 0;
> +	}
>  
>  done:
>  	if (dev)
> diff --git a/drivers/usb/gadget/goku_udc.h b/drivers/usb/gadget/goku_udc.h
> index 566cb23..c27b9e2 100644
> --- a/drivers/usb/gadget/goku_udc.h
> +++ b/drivers/usb/gadget/goku_udc.h
> @@ -251,7 +251,8 @@ struct goku_udc {
>  					got_region:1,
>  					req_config:1,
>  					configured:1,
> -					enabled:1;
> +					enabled:1,
> +					dev_reg_status:2;
>  
>  	/* pci state used to access those endpoints */
>  	struct pci_dev			*pdev;
> -- 
> 1.7.2.3
