Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0JBObW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 10:31:22 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58906 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755482Ab0JBObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 10:31:21 -0400
Date: Sat, 2 Oct 2010 10:31:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Rahul Ruikar <rahul.ruikar@gmail.com>
cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: dummy_hcd: Fix error path
In-Reply-To: <1286004210-3833-1-git-send-email-rahul.ruikar@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1010021018250.15874-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Oct 2010, Rahul Ruikar wrote:

> In function dummy_udc_probe()
> call put_device() when device_register() fails.
> 
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/usb/gadget/dummy_hcd.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
> index dc65462..2548091 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -885,8 +885,10 @@ static int dummy_udc_probe (struct platform_device *pdev)
>  	dum->gadget.dev.parent = &pdev->dev;
>  	dum->gadget.dev.release = dummy_gadget_release;
>  	rc = device_register (&dum->gadget.dev);
> -	if (rc < 0)
> +	if (rc < 0) {
> +		put_device(&dum->gadget.dev);
>  		return rc;
> +	}
>  
>  	usb_get_hcd (dummy_to_hcd (dum));

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Similar changes are needed in net2280.c, file_storage.c and
f_mass_storage.c, probably also in goku_udc.c and langwell_udc.c.  
Would you like to make them?

Alan Stern

