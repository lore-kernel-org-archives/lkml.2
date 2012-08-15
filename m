Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2HOOhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:37:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49959 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754391Ab2HOOhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:37:36 -0400
Date: Wed, 15 Aug 2012 10:37:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] drivers/usb/host/ohci-platform.c: fix error return
 code
In-Reply-To: <1344926858-1162-5-git-send-email-Julia.Lawall@lip6.fr>
Message-ID: <Pine.LNX.4.44L0.1208151037190.1674-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a possibly 0 error return code to a negative one, as returned
> elsewhere in the function.

> diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
> index 10d85b9..e24ec9f 100644
> --- a/drivers/usb/host/ohci-platform.c
> +++ b/drivers/usb/host/ohci-platform.c
> @@ -130,8 +130,10 @@ static int __devinit ohci_platform_probe(struct platform_device *dev)
>  	}
>  
>  	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
> -	if (!hcd->regs)
> +	if (!hcd->regs) {
> +		err = -ENOMEM;
>  		goto err_release_region;
> +	}
>  	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
>  	if (err)
>  		goto err_iounmap;

Acked-by: Alan Stern <stern@rowland.harvard.edu>

