Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab2GNUYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:24:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38267 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747Ab2GNUYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:24:45 -0400
Message-ID: <1342297484.8377.28.camel@joe2Laptop>
Subject: Re: [PATCH 01/15] Drivers: hv: Format GUIDS as per MSFT standards
From: Joe Perches <joe@perches.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Date: Sat, 14 Jul 2012 13:24:44 -0700
In-Reply-To: <1342298060-12662-1-git-send-email-kys@microsoft.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
	 <1342298060-12662-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-14 at 13:34 -0700, K. Y. Srinivasan wrote:
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
>  			       device_info->chn_type.b[3],
>  			       device_info->chn_type.b[2],
>  			       device_info->chn_type.b[1],
> @@ -166,7 +166,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
>  			       device_info->chn_type.b[15]);
>  	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
>  		ret = sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> -			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
> +			       "%02x%02x-%02x%02x%02x%02x%02x%02x}\n",
>  			       device_info->chn_instance.b[3],
>  			       device_info->chn_instance.b[2],
>  			       device_info->chn_instance.b[1],

	ret = sprintf(buf, "{%pUl}\n", device_info->chn_instance.b);


