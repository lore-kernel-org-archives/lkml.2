Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2JHAqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:46:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49460 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2JHAqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:46:43 -0400
Date: Sun, 7 Oct 2012 17:46:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:misc: ti-st: fix potential NULL pointer
 dereference in st_register()
Message-ID: <20121008004640.GC12342@kroah.com>
References: <CAPgLHd_PcLZGPtXQUUJ3VZJub+27zTsDvHF6X2vUrKJ9cKZ+7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_PcLZGPtXQUUJ3VZJub+27zTsDvHF6X2vUrKJ9cKZ+7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 08:41:36AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The dereference should be moved below the NULL test.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/misc/ti-st/st_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
> index 46937b1..ee341ea 100644
> --- a/drivers/misc/ti-st/st_core.c
> +++ b/drivers/misc/ti-st/st_core.c
> @@ -511,13 +511,14 @@ long st_register(struct st_proto_s *new_proto)
>  	unsigned long flags = 0;
>  
>  	st_kim_ref(&st_gdata, 0);
> -	pr_info("%s(%d) ", __func__, new_proto->chnl_id);
>  	if (st_gdata == NULL || new_proto == NULL || new_proto->recv == NULL
>  	    || new_proto->reg_complete_cb == NULL) {
>  		pr_err("gdata/new_proto/recv or reg_complete_cb not ready");
>  		return -EINVAL;
>  	}
>  
> +	pr_info("%s(%d) ", __func__, new_proto->chnl_id);

Why print this at all?  Can't you just drop it now?

greg k-h
