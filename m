Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0JDMP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 08:15:59 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:57168 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754949Ab0JDMP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 08:15:58 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-06.arcor-online.net F3F3310BD98
Message-ID: <4CA9C571.3070909@arcor.de>
Date: Mon, 04 Oct 2010 14:15:45 +0200
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Rahul Ruikar <rahul.ruikar@gmail.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: amd5536udc: Fix error path
References: <1286003420-3774-1-git-send-email-rahul.ruikar@gmail.com>
In-Reply-To: <1286003420-3774-1-git-send-email-rahul.ruikar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

Thanks for the fix!

Thomas


On 10/2/2010 9:10 AM, Rahul Ruikar wrote:
> In function udc_probe()
> call put_device() when device_register() fails.
>
> Signed-off-by: Rahul Ruikar<rahul.ruikar@gmail.com>
> ---
>   drivers/usb/gadget/amd5536udc.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
> index 731150d4..950ee33 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -3382,8 +3382,10 @@ static int udc_probe(struct udc *dev)
>   	udc = dev;
>
>   	retval = device_register(&dev->gadget.dev);
> -	if (retval)
> +	if (retval) {
> +		put_device(&dev->gadget.dev);
>   		goto finished;
> +	}
>
>   	/* timer init */
>   	init_timer(&udc_timer);
>    

