Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab1HWXaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:30:46 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34425 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755661Ab1HWX2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:08 -0400
X-Sasl-enc: dNmvFoZjpxbXPlvCHwUQ9+jN8aE2IJUs9qycA3E8u/bN 1314142087
Date: Tue, 23 Aug 2011 16:10:28 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
 manage ref_cnt
Message-ID: <20110823231028.GO9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-86-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-86-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:47:14AM -0700, K. Y. Srinivasan wrote:
> Now that we have a spin lock protecting access to the stor device pointer,
> use it manage the reference count as well.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/hyperv_storage.h |    8 ++++----
>  drivers/staging/hv/storvsc.c        |   10 +++++-----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
> index 53b65be..d946211 100644
> --- a/drivers/staging/hv/hyperv_storage.h
> +++ b/drivers/staging/hv/hyperv_storage.h
> @@ -265,7 +265,7 @@ struct storvsc_device {
>  	struct hv_device *device;
>  
>  	/* 0 indicates the device is being destroyed */
> -	atomic_t ref_count;
> +	int	 ref_count;

Is this really needed?  Can't you rely on the reference count of the
hv_device itself?

greg k-h
