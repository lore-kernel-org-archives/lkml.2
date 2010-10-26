Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab0JZNnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:43:22 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:40416 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543Ab0JZNnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:43:21 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-18.arcor-online.net AA1D215C001
Message-ID: <4CC6DAE9.1070402@arcor.de>
Date: Tue, 26 Oct 2010 15:43:05 +0200
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/14] drivers/usb/gadget/amd5536udc.c: delete double assignment
References: <1288088743-3725-1-git-send-email-julia@diku.dk> <1288088743-3725-3-git-send-email-julia@diku.dk>
In-Reply-To: <1288088743-3725-3-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

Thanks!
Thomas

On 10/26/2010 12:25 PM, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> Delete successive assignments to the same location.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @@
> expression i;
> @@
>
> *i = ...;
>   i = ...;
> //</smpl>
>
> Signed-off-by: Julia Lawall<julia@diku.dk>
>
> ---
>   drivers/usb/gadget/amd5536udc.c |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
> index 9034e03..f8dd726 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -3359,7 +3359,6 @@ static int udc_probe(struct udc *dev)
>   	dev_set_name(&dev->gadget.dev, "gadget");
>   	dev->gadget.dev.release = gadget_release;
>   	dev->gadget.name = name;
> -	dev->gadget.name = name;
>   	dev->gadget.is_dualspeed = 1;
>
>   	/* init registers, interrupts, ... */
>
>    

