Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0CVMYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:24:40 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:59096 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0CVMYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:24:39 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BA76219.4030606@cam.ac.uk>
Date: Mon, 22 Mar 2010 12:27:05 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: sonic zhang <sonic.adi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-iio <linux-iio@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] iio: Function iio_get_new_idr_val() return negative value
 if fails.
References: <1269253414.30009.5.camel@eight.analog.com>
In-Reply-To: <1269253414.30009.5.camel@eight.analog.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/10 10:23, sonic zhang wrote:
> 
> Function iio_get_new_idr_val() return negative value if fails.
> So, only error when ret < 0 in iio_device_register_eventset().
> 
> Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
Youch.  I'm amazed that one hasn't caused more trouble!
Thanks Sonic.  I would normally say the comment is unnecessary 
but then the error suggests it is worth having it.
Actually, it would probably be better to put the docs
in the header rather than here.

Otherwise, (and given the nature of the fix I'm not
that bothered about the comment location).

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

cc'd Greg KH. (please do this with patches that are bug fixes
that don't need much discussion like this one) The drivers
are in his staging tree so that's the route for merging
this sort of fix. 

> ---
>  drivers/staging/iio/industrialio-core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index b456dfc..dd9267c 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -536,6 +536,7 @@ static void iio_device_unregister_sysfs(struct iio_dev *dev_info)
>  	sysfs_remove_group(&dev_info->dev.kobj, dev_info->attrs);
>  }
>  
> +/* This function return negative value if fails. */
>  int iio_get_new_idr_val(struct idr *this_idr)
>  {
>  	int ret;
> @@ -659,7 +660,7 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
>  	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
>  		dev_info->event_interfaces[i].owner = dev_info->driver_module;
>  		ret = iio_get_new_idr_val(&iio_event_idr);
> -		if (ret)
> +		if (ret < 0)
>  			goto error_free_setup_ev_ints;
>  		else
>  			dev_info->event_interfaces[i].id = ret;

