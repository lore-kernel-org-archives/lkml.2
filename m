Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab1IIUrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:47:32 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37197 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759922Ab1IIUr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:47:29 -0400
X-Sasl-enc: mdjN5LnBd8cGVN4lLk6aDaeatgiXHUt8zBFXXc6GKAM+ 1315601248
Date: Fri, 9 Sep 2011 13:42:40 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 09/25] Staging: hv: util: Perform some service specific
 de-initialization in util_remove()
Message-ID: <20110909204240.GF19127@kroah.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-9-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315491876-9554-9-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 07:24:20AM -0700, K. Y. Srinivasan wrote:
> In preparation for modifying the util driver to fully conform to the
> Linux Driver Model, perform some service specific de-initialization in
> util_remove() as opposed to in exit_hyperv_utils() as is currently done.
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/hv_util.c |   29 ++++++++++++++++++++++++-----
>  1 files changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
> index b86128a..2475ab2 100644
> --- a/drivers/staging/hv/hv_util.c
> +++ b/drivers/staging/hv/hv_util.c
> @@ -291,6 +291,30 @@ error:
>  static int util_remove(struct hv_device *dev,
>  			const struct hv_vmbus_device_id *dev_id)
>  {
> +	int service = dev_id->driver_data;
> +
> +	switch (service) {
> +	case HV_SHUTDOWN:
> +		kfree(shut_txf_buf);
> +		break;

This switch and "static" pointers you need to free aren't needed at all
if you do this code logic correctly (i.e. a per-device buffer.)

{sigh}

I'm stopping reviewing now, this is making me grumpy, someone owes me a
bunch of beer...

greg k-h
