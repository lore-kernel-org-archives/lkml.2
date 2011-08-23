Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1HWXbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:31:15 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53480 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961Ab1HWX2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:02 -0400
X-Sasl-enc: yYCWE0n17Bb+UFLzUOVamj9v58ODrL5B9b2OS0ICTztx 1314142082
Date: Tue, 23 Aug 2011 16:02:23 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 036/117] Staging: hv: vmbus: Make class_id attribute a
 human readable string
Message-ID: <20110823230223.GK9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-36-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-36-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:24AM -0700, K. Y. Srinivasan wrote:
> Now that we have a human readable device_type, use that and get rid of the
> guid based device type.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/vmbus_drv.c |   20 ++------------------
>  1 files changed, 2 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index 9a0df2c..67415ab 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -113,24 +113,8 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
>  	get_channel_info(hv_dev, &device_info);
>  
>  	if (!strcmp(dev_attr->attr.name, "class_id")) {
> -		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> -			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",

You just changed what this sysfs file contains to have something totally
different than what it used to.

What userspace tools just broke?

If you change the data in the file, shouldn't the name of the file
change as well?

greg k-h
