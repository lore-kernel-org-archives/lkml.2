Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab1BZDkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 22:40:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52465 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1BZDky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 22:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=oTo3uFPL+9hfnD/4QQtmzdUfKaOk6XxOozDPY7EDJTK1Ku75fxuQvAQs9wiryMrmsY
         A9poN2kX0N64idcZNGeC2XQbWgNWRC6Cer4ygHXXE/mTlpz6lM9VRcmRVVGJWjVlLQLq
         l3HsxEkxIokP/nuB/m9Dw9qZ0Rp2bVpodkrQQ=
Date: Sat, 26 Feb 2011 06:40:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 6/6] Staging: hv: Cleanup hyperv_driver variable names
Message-ID: <20110226034039.GE18043@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>, gregkh@suse.de,
	linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
	virtualization@lists.osdl.org
References: <1298686078-30945-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298686078-30945-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 06:07:58PM -0800, K. Y. Srinivasan wrote:
> The title says it all.
> 

For this patch the rename_rev.pl command is:

rename_rev.pl -nc -e 's/(drv|driver)_ctx/drv/g'

> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -46,7 +46,7 @@ struct vmbus_hyperv_driver {
>  	/* FIXME, this is a bug */
>  	/* The driver field is not used in here. Instead, the bus field is */
>  	/* used to represent the driver */
        ^^
This comment out of date now that we're using container_of().

> -	struct hyperv_driver drv_ctx;
> +	struct hyperv_driver dummy;
                             ^^^^^
Delete.

> @@ -849,18 +849,18 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
>  static int vmbus_match(struct device *device, struct device_driver *driver)
>  {
>  	int match = 0;
> -	struct hyperv_driver *driver_ctx = driver_to_hyperv_driver(driver);
> +	struct hyperv_driver *drv = driver_to_hyperv_driver(driver);
>  	struct hyperv_device *device_obj = device_to_hyperv_device(device);
>  
>  	/* We found our driver ? */
> -	if (memcmp(&device_obj->class_id, &driver_ctx->class_id,
> +	if (memcmp(&device_obj->class_id, &drv->class_id,
>  		   sizeof(struct hv_guid)) == 0) {
>  		/*
> -		 * !! NOTE: The driver_ctx is not a vmbus_drv_ctx. We typecast
> +		 * !! NOTE: The drv is not a vmbus_drv_ctx. We typecast
                                                      ^^^^
Out of date.

regards,
dan carpenter
