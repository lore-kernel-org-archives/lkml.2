Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2JHPGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:06:07 -0400
Received: from shutemov.name ([176.9.204.213]:59924 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab2JHPGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:06:04 -0400
Date: Mon, 8 Oct 2012 18:06:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: airlied@linux.ie, alan@lxorguk.ukuu.org.uk, yongjun_wei@trendmicro.com.cn,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gma500: medfield: drop bogus NULL check in
 mdfld_dsi_output_init()
Message-ID: <20121008150645.GA27456@shutemov.name>
References: <CAPgLHd-=1KXjxCpNq7yhvKjQkRPuHucA-1q_1ijTUhmEOKR=Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-=1KXjxCpNq7yhvKjQkRPuHucA-1q_1ijTUhmEOKR=Xg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 10:44:06PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Drop the NULL test for dev since it never be NULL.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/gpu/drm/gma500/mdfld_dsi_output.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_output.c b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
> index 32dba2a..b6f49d9 100644
> --- a/drivers/gpu/drm/gma500/mdfld_dsi_output.c
> +++ b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
> @@ -506,7 +506,7 @@ void mdfld_dsi_output_init(struct drm_device *dev,
>  
>  	dev_dbg(dev->dev, "init DSI output on pipe %d\n", pipe);
>  
> -	if (!dev || ((pipe != 0) && (pipe != 2))) {
> +	if ((pipe != 0) && (pipe != 2)) {

It would be nice to remove redundant parentheses while you're there.

Otherwise
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

>  		DRM_ERROR("Invalid parameter\n");
>  		return;
>  	}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
