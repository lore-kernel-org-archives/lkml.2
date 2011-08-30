Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1H3TTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:19:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab1H3TTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:19:49 -0400
Date: Tue, 30 Aug 2011 12:19:37 -0700
From: Greg KH <gregkh@suse.de>
To: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Free fw_priv in fw_create_instance
Message-ID: <20110830191937.GA8689@suse.de>
References: <1314731192-1960-1-git-send-email-rajan.aggarwal85@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314731192-1960-1-git-send-email-rajan.aggarwal85@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 12:36:32AM +0530, Rajan Aggarwal wrote:
> fw_priv is not being freed in some of the error scenarios in
> fw_create_instance.

Not true.

> This patch makes sure that this is kfreed properly in all error
> situations in the fw_create_instance logic where it is required.

Nope, this will cause a double-free to happen.

> Signed-off-by: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
> ---
>  drivers/base/firmware_class.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 06ed6b4..3ddbc48 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -497,6 +497,7 @@ err_del_dev:
>  	device_del(f_dev);
>  err_put_dev:
>  	put_device(f_dev);
> +	kfree(fw_priv);

Did you test this patch out?  What happened when you tested it?

How did you find this "problem"?

Care to look a bit closer at the code?

I'd give you a hint, but it's more sporting this way :)

thanks,

greg k-h
