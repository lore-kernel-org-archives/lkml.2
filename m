Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab1IIUsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:48:45 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53886 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759957Ab1IIUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:47:23 -0400
X-Sasl-enc: IwFDumzCvesJfuhxuW6jNN4yQRmRBh+iVLyXLawZB0mo 1315601242
Date: Fri, 9 Sep 2011 13:38:53 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 05/25] Staging: hv: vmbus: Change the signature of struct
 hv_driver probe function
Message-ID: <20110909203853.GC19127@kroah.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-5-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315491876-9554-5-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 07:24:16AM -0700, K. Y. Srinivasan wrote:
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -299,9 +299,15 @@ static int vmbus_probe(struct device *child_device)
>  	struct hv_driver *drv =
>  			drv_to_hv_drv(child_device->driver);
>  	struct hv_device *dev = device_to_hv_device(child_device);
> +	const struct hv_vmbus_device_id *dev_id = drv->id_table;
> +
> +	for (; !is_null_guid(dev_id->guid); dev_id++)
> +		if (!memcmp(&dev_id->guid, &dev->dev_type.b,
> +				sizeof(uuid_le)))
> +			break;

Don't duplicate this section of code twice (at least) in the driver.
Make it a "vmbus_match_device()" function that returns the proper
hv_vmbus_device_id * to do something with.

thanks,

greg k-h
