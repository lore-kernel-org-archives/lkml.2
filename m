Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1HWX2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:28:40 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54580 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab1HWX1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:27:55 -0400
X-Sasl-enc: Y9INRBqogE8ze5cWoDj4KEy6azTDQlsnfAQbXJ6Sql1B 1314142074
Date: Tue, 23 Aug 2011 15:47:11 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 017/117] Staging: hv: mouse: Do not auto-load the mouse
 driver
Message-ID: <20110823224711.GE9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-17-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-17-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:05AM -0700, K. Y. Srinivasan wrote:
> The mouse driver is not functional and so, prevent auto-loading
> of this driver. Earlier we added the MODULE_DEVICE_TABLE() line
> to verify that the appropriate module alias was generated.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/hv_mouse.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> index d6441d6..95986fb 100644
> --- a/drivers/staging/hv/hv_mouse.c
> +++ b/drivers/staging/hv/hv_mouse.c
> @@ -931,7 +931,10 @@ static const struct hv_vmbus_device_id id_table[] = {
>  	},
>  };
>  
> -MODULE_DEVICE_TABLE(vmbus, id_table);
> +/*
> + * The mouse driver is not functional; do not auto-load it.
> + */
> +/* MODULE_DEVICE_TABLE(vmbus, id_table); */

Then you should not have caused it to be autoloaded on the previous
patch.  Please merge this with the previous patch, which would be merged
with the previous patch to that, smushing them all into a smaller patch
series.

greg k-h
