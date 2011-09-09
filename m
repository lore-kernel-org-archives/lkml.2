Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab1IIUre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:47:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44763 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759970Ab1IIUr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:47:27 -0400
X-Sasl-enc: bnuIvvNmvbuPwsCYXkBDFA23JxeqKvTntbWzU+MTfIcL 1315601246
Date: Fri, 9 Sep 2011 13:41:32 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 06/25] Staging: hv: storvsc: Use the driver_data to
 identify ide
Message-ID: <20110909204132.GE19127@kroah.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-6-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315491876-9554-6-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 07:24:17AM -0700, K. Y. Srinivasan wrote:
> Use the driver_data to identify ide devices in storvsc_probe().
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/storvsc_drv.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> index fff1e5b..e2c63e5 100644
> --- a/drivers/staging/hv/storvsc_drv.c
> +++ b/drivers/staging/hv/storvsc_drv.c
> @@ -1366,10 +1366,12 @@ static struct scsi_host_template scsi_driver = {
>  static const struct hv_vmbus_device_id id_table[] = {
>  	/* SCSI guid */
>  	{ VMBUS_DEVICE(0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
> -		       0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f) },
> +		       0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f)
> +	  .driver_data = 0 },

What does 0 mean?  That's the "default" here, right?

>  	/* IDE guid */
>  	{ VMBUS_DEVICE(0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> -		       0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5) },
> +		       0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5)
> +	  .driver_data = 1 },

What does 1 mean?

And yes, I can guess, but please, will you really remember this in 2
years?

enums are your friend...

PLEASE make your code easier to maintain for the person who has to come
clean it up after you, which is usually yourself so you are only making
your own life easier.

greg k-h
