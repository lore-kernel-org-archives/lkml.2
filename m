Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1H2SAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:00:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46830 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559Ab1H2SAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:00:33 -0400
X-Sasl-enc: 6NmIt3Dsz5McI3cBu0nR+MsB2fpfoqUIZVDFMJN9v0qZ 1314640832
Date: Mon, 29 Aug 2011 11:00:26 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 35/46] Staging: hv: Fix a bug in vmbus_match()
Message-ID: <20110829180026.GA19668@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-35-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314469905-7058-35-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 11:31:34AM -0700, K. Y. Srinivasan wrote:
> The recent checkin that add a private pointer to hv_vmbus_device_id
> introduced this bug in vmbus_match; fix it.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/vmbus_drv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index be62b62..51002c0 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -273,7 +273,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
>  
>  	for (; !is_null_guid(id_array->guid); id_array++)
>  		if (!memcmp(&id_array->guid, &hv_dev->dev_type.b,
> -				sizeof(struct hv_vmbus_device_id)))
> +				sizeof(uuid_le)))

Ick, sorry about this, it was my fault.

greg k-h
