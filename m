Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767Ab1IIUs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:48:27 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52761 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759977Ab1IIUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:47:30 -0400
X-Sasl-enc: AX+WyKMhZkOklcU/b5LWNrXE+5EewWiNBYIjSGnhsJ7Y 1315601249
Date: Fri, 9 Sep 2011 13:43:09 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
 vmbus_remove()
Message-ID: <20110909204309.GG19127@kroah.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-10-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315491876-9554-10-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 07:24:21AM -0700, K. Y. Srinivasan wrote:
> Return proper error code in vmbus_remove().
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/vmbus_drv.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index b9aeb76..95d33a4 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -325,7 +325,7 @@ static int vmbus_probe(struct device *child_device)
>   */
>  static int vmbus_remove(struct device *child_device)
>  {
> -	int ret;
> +	int ret = 0;

As remove functions can't fail, why return anything at all?

Doesn't make sense, please fix.

greg k-h
