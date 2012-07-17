Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab2GQQEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:04:11 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50354 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2GQQEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:04:08 -0400
Date: Tue, 17 Jul 2012 09:04:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, olaf@aepfle.de, apw@canonical.com
Subject: Re: [PATCH 01/15] Drivers: hv: Format GUIDS as per MSFT standards
Message-ID: <20120717160402.GA20481@kroah.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342298060-12662-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 01:34:06PM -0700, K. Y. Srinivasan wrote:
> Format GUIDS as per MSFT standard. This makes interacting with MSFT
> tool stack easier.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/hv/vmbus_drv.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index a220e57..1f7e54a 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -147,7 +147,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
>  
>  	if (!strcmp(dev_attr->attr.name, "class_id")) {
>  		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> -			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
> +			       "%02x%02x-%02x%02x%02x%02x%02x%02x}\n",

As Joe pointed out, please just use the printk modifier the kernel
already has for GUIDS, and don't roll your own here.  That will work
properly for you, right?

thanks,

greg k-h
