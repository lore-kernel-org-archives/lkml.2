Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab1HWX26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:28:58 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53480 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755978Ab1HWX2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:05 -0400
X-Sasl-enc: F+K3Px2AKxX4awxvDJwJzjcNyFTxCu+h9HiJ1zj+7VQP 1314142084
Date: Tue, 23 Aug 2011 16:04:26 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 040/117] Staging: hv: vmbus: Cleanup error handling in
 hv_init()
Message-ID: <20110823230426.GM9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-40-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-40-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:28AM -0700, K. Y. Srinivasan wrote:
> Use standard Linux error codes.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/hv.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
> index 2f94880..e733173 100644
> --- a/drivers/staging/hv/hv.c
> +++ b/drivers/staging/hv/hv.c
> @@ -225,8 +225,8 @@ cleanup:
>  
>  		vfree(virtaddr);
>  	}
> -	ret = -1;
> -	return ret;
> +
> +	return -ENOTSUPP;

The ret variable is no longer needed here, so just remove it entirely in
this patch.

greg k-h
