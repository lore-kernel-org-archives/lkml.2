Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1HWX2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:28:10 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38820 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755847Ab1HWX1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:27:54 -0400
X-Sasl-enc: s5jijl6XiefLYaQOBSBR4Yefr2eGdQYxN6jOcDdn1sle 1314142072
Date: Tue, 23 Aug 2011 15:46:26 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 011/117] Staging: hv: util: Use the newly introduced
 vmbus ID in util driver
Message-ID: <20110823224626.GD9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-11-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-11-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:45:59AM -0700, K. Y. Srinivasan wrote:
> Use the newly introduced vmbus ID in util driver.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/hv_util.c |   38 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
> index e72bfe0..35540f5 100644
> --- a/drivers/staging/hv/hv_util.c
> +++ b/drivers/staging/hv/hv_util.c
> @@ -226,9 +226,47 @@ static int util_remove(struct hv_device *dev)
>  	return 0;
>  }
>  
> +static const struct hv_vmbus_device_id id_table[] = {
> +	{
> +		/* Shutdown guid */
> +		.guid = {
> +			0x31, 0x60, 0x0B, 0X0E, 0x13, 0x52, 0x34, 0x49,
> +			0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB
> +		}
> +	},
> +	{
> +		/* Time synch guid */
> +		.guid = {
> +			0x30, 0xe6, 0x27, 0x95, 0xae, 0xd0, 0x7b, 0x49,
> +			0xad, 0xce, 0xe8, 0x0a, 0xb0, 0x17, 0x5c, 0xaf
> +		}
> +	},
> +	{
> +		/* Heartbeat guid */
> +		.guid = {
> +			0x39, 0x4f, 0x16, 0x57, 0x15, 0x91, 0x78, 0x4e,
> +			0xab, 0x55, 0x38, 0x2f, 0x3b, 0xd5, 0x42, 0x2d
> +		}
> +	},
> +	{
> +		/* KVP guid */
> +		.guid = {
> +			0xe7, 0xf4, 0xa0, 0xa9, 0x45, 0x5a, 0x96, 0x4d,
> +			0xb8, 0x27, 0x8a, 0x84, 0x1e, 0x8c, 0x3,  0xe6
> +		}
> +	},
> +	{
> +		.guid = {
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
> +		}
> +	},
> +};
> +

Merge this into the previous patch please.

greg k-h
