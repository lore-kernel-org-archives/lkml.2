Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1HWX1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:27:54 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51583 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab1HWX1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:27:49 -0400
X-Sasl-enc: QkbOnS47wLgbjr0Y7pdHLRjhWpybEnoWWjedHFIydAhm 1314142068
Date: Tue, 23 Aug 2011 15:41:57 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Message-ID: <20110823224157.GA9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-3-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-3-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:45:51AM -0700, K. Y. Srinivasan wrote:
> In preparation for implementing vmbus aliases for auto-loading
> Hyper-V drivers, define vmbus specific device ID.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  include/linux/mod_devicetable.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index ae28e93..5a12377 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -405,6 +405,13 @@ struct virtio_device_id {
>  };
>  #define VIRTIO_DEV_ANY_ID	0xffffffff
>  
> +/*
> + * For Hyper-V devices we use the device guid as the id.
> + */
> +struct hv_vmbus_device_id {
> +	__u8 guid[16];
> +};

Why do you not need a driver_data pointer here?  Are you sure you aren't
ever going to need it in the future?  Hint, I think you will...

greg k-h
