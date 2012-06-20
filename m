Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab2FTXzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:55:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597Ab2FTXzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:55:08 -0400
Date: Wed, 20 Jun 2012 16:55:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/w1: free the w1_master at w1_free_dev and return
 a correct return value
Message-ID: <20120620235503.GA31520@kroah.com>
References: <1339949879-26085-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339949879-26085-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 09:47:59PM +0530, Devendra Naga wrote:
> the w1_master pointer is allced at the w1_alloc_master and is not freed when called with
> w1_remove_master.
> 
> when w1_alloc_dev fails the return should be -ENODEV as it does
> device_register, and that is the last case where that function
> will fail.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> ---
>  drivers/w1/w1_int.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
> index 6828835..a3cf27d 100644
> --- a/drivers/w1/w1_int.c
> +++ b/drivers/w1/w1_int.c
> @@ -100,6 +100,7 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
>  static void w1_free_dev(struct w1_master *dev)
>  {
>  	device_unregister(&dev->dev);
> +	kfree(dev);

No, this is wrong, the memory will be freed in w1_master_release(),
right?  It is not freed here, sorry, this patch is incorrect.

greg k-h
