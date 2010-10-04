Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab0JDKsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:48:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42738 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0JDKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:48:07 -0400
Message-ID: <4CA9B07D.8080202@ru.mvista.com>
Date: Mon, 04 Oct 2010 14:46:21 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Rahul Ruikar <rahul.ruikar@gmail.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>,
        nm127@freemail.hu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: goku_udc: Fix error path
References: <1286115016-2759-1-git-send-email-rahul.ruikar@gmail.com>
In-Reply-To: <1286115016-2759-1-git-send-email-rahul.ruikar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-10-2010 18:10, Rahul Ruikar wrote:

> call put_device() when device_register() fails.

> Signed-off-by: Rahul Ruikar<rahul.ruikar@gmail.com>
[...]
> diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
> index 1088d08..080779b 100644
> --- a/drivers/usb/gadget/goku_udc.c
> +++ b/drivers/usb/gadget/goku_udc.c
> @@ -1847,8 +1847,13 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	/* done */
>   	the_controller = dev;
>   	retval = device_register(&dev->gadget.dev);
> -	if (retval == 0)
> +	if (retval != 0) {
> +		dev_reg_status = 2;
> +		goto done;
> +	} else {
> +		dev_reg_status = 1;

    Did you mean 'dev->dev_reg_status'?

>   		return 0;
> +	}
>
>   done:
>   	if (dev)
> diff --git a/drivers/usb/gadget/goku_udc.h b/drivers/usb/gadget/goku_udc.h
> index 566cb23..c27b9e2 100644
> --- a/drivers/usb/gadget/goku_udc.h
> +++ b/drivers/usb/gadget/goku_udc.h
> @@ -251,7 +251,8 @@ struct goku_udc {
>   					got_region:1,
>   					req_config:1,
>   					configured:1,
> -					enabled:1;
> +					enabled:1,
> +					dev_reg_status:2;

    I don't see where this new field is read in your patch...

WBR, Sergei
