Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1HWX2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:28:19 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60066 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab1HWX1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:27:51 -0400
X-Sasl-enc: TsQgb9cKc1GAk3HPHjHxZWx9ezfNfVReSHq/dQsugMMM 1314142070
Date: Tue, 23 Aug 2011 15:45:13 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 006/117] Staging: hv: blkvsc: Use the newly introduced
 vmbus ID in the blockvsc driver
Message-ID: <20110823224513.GB9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-6-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-6-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:45:54AM -0700, K. Y. Srinivasan wrote:
> Use the newly introduced vmbus ID in the blockvsc driver.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/blkvsc_drv.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> index 018b293..38117d96 100644
> --- a/drivers/staging/hv/blkvsc_drv.c
> +++ b/drivers/staging/hv/blkvsc_drv.c
> @@ -802,10 +802,26 @@ static void blkvsc_request(struct request_queue *queue)
>  	}
>  }
>  
> +static const struct hv_vmbus_device_id id_table[] = {
> +	{
> +		/* IDE guid */
> +		.guid = {
> +			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> +			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
> +		}
> +	},
> +	{
> +		.guid = {
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
> +		}

No, just zero terminate the list with a simple { } entry, not the whole
thing spelled for every individual byte.

Same goes for the other patches that added this id_table, please fix
those.

thanks,

greg k-h
