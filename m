Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0JOEZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:25:08 -0400
Received: from kroah.org ([198.145.64.141]:34388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab0JOEZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:25:05 -0400
Date: Thu, 14 Oct 2010 21:25:41 -0700
From: Greg KH <greg@kroah.com>
To: m00150988@huawei.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Franko Fang <huananhu@huawei.com>
Subject: Re: [PATCH] fix oops in usbserial_cleanup function;
Message-ID: <20101015042541.GA16134@kroah.com>
References: <faf7c73f11ba6.11ba6faf7c73f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faf7c73f11ba6.11ba6faf7c73f@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 12:14:37PM +0800, m00150988@huawei.com wrote:
> From: marui <m00150988@huawei.com>
> 
> 1. I find this bug on OpenSUSE 11.3 which kernel vesion is 2.6.34, but the latest kernel vesion 2.6.36-rc7 aslo have this bug. This patch is based on the kernel of 2.6.36-rc7.
> 2. Bug report:
>    a. Install huawei datacard dashboard on OpenSUSE 11.3
>    b. Plug in huawei datacard into OpenSUSE 11.3 which kernel verison is 2.6.36-rc7
>    c. After the dashboard has detected the device, I  pull out the usb datacard
>    d. close datashboard,then kernel panic will happen in usbserial_cleanup function. 
>  
>  
> 3. fix the bug:
>    I find usbserial_cleanup should judge the usb device wheher has been disconnected firtly.
> 
> Signed-off-by: marui<m00150988@huawei.com>

I need a full name here please.

> --- linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c	2010-10-06 16:39:52.000000000 -0400
> +++ linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c	2010-10-14 20:59:47.000000000 -0400
> @@ -328,6 +328,20 @@ static void serial_cleanup(struct tty_st
>  	/* The console is magical.  Do not hang up the console hardware
>  	 * or there will be tears.
>  	 */
> +        dbg("%s start\n",__func__);
> +        if(NULL == port)
> +        {
> +            dbg("%s NULL == port\n",__func__);
> +            return;
> +        }
> +	mutex_lock(&port->serial->disc_mutex);

Please read Documentation/CodingStyle for the tabs and brace placements
you need to resolve.

thanks,

greg k-h
