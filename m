Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab0JSHcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:32:04 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:1676 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757835Ab0JSHcD (ORCPT
	<rfc822;groupwise-jlee@novell.com:5:1>);
	Tue, 19 Oct 2010 03:32:03 -0400
Message-Id: <4CBDE4170200002300022431@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 19 Oct 2010 01:31:51 -0600
From: "Joey Lee" <jlee@novell.com>
To: "Al Cho" <ACho@novell.com>
Cc: <devel@driverdev.osuosl.org>, <yiyingc@ene.com.tw>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/keucr: fix keucr lost disconnect in
 transport
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al, 

於 五，2010-09-24 於 18:50 +0800，Al Cho 提到：
> The other part of keucr lost usb disconnect.
> Unplug SDcard after thread scan,the wrong rule in usb_stor_port_reset,
> so the driver still fail in stress test.
> 
> Signed-off-by: Al Cho <acho@novell.com>
> ---
>  drivers/staging/keucr/transport.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
> index 7215429..445a62c 100644
> --- a/drivers/staging/keucr/transport.c
> +++ b/drivers/staging/keucr/transport.c
> @@ -763,24 +763,19 @@ int usb_stor_port_reset(struct us_data *us)
>  	int result, rc_lock;
>  
>  	//printk("transport --- usb_stor_port_reset\n");
> -	result = rc_lock = usb_lock_device_for_reset(us->pusb_dev, us->pusb_intf);
> +	result = usb_lock_device_for_reset(us->pusb_dev, us->pusb_intf);
>  	if (result < 0)
>  		printk("unable to lock device for reset: %d\n", result);
> -	else
> -	{
> +	else {
>  		/* Were we disconnected while waiting for the lock? */
> -		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
> -		{
> +		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
>  			result = -EIO;
>  			//printk("No reset during disconnect\n");
> -		}
> -		else
> -		{
> +		} else {
>  			result = usb_reset_device(us->pusb_dev);
>  			//printk("usb_reset_composite_device returns %d\n", result);
>  		}
> -		if (rc_lock)
> -			usb_unlock_device(us->pusb_dev);
> +		usb_unlock_device(us->pusb_dev);
>  	}
>  	return result;
>  }

This patch works to me on MSI netbook.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>


Thank's
Joey Lee

