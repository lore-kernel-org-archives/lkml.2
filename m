Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1HWX2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:28:48 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33718 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755899Ab1HWX15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:27:57 -0400
X-Sasl-enc: BDjf2vNvn6ISOGPDSY2RssLaCxUgsNAYhrj/kDsnpKHf 1314142076
Date: Tue, 23 Aug 2011 15:51:50 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 020/117] Staging: hv: vmbus: Support the notion of id
 tables in vmbus_match()
Message-ID: <20110823225150.GG9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-20-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-20-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:08AM -0700, K. Y. Srinivasan wrote:
> Introduce code to handle driver specific id tables to the vmbus core
> (vmbus_match). This would allow us to handle more than one device type
> with a given driver.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/vmbus_drv.c |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index 7baba62..3a8eb36 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -255,21 +255,32 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
>  	return ret;
>  }
>  
> +static bool is_not_null_guid(const __u8 *guid)

Negative function names cause people's heads to get confused.

Please do "is_null_guid()" instead.

thanks,

greg k-h
